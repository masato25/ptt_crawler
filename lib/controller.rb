#!/usr/bin/env ruby

require './lib/http_connect.rb'
require './lib/ptt_spider.rb'
require './lib/mongolib'
require 'logger'

class Controller

  def initialize(url='http://www.ptt.cc/bbs/Gossiping/index.html',timeage=60 * 32)
    @logger = Logger.new('./logs/plog.log')
    @btime = Time.now.to_i
    #create spider object for conn
    @spi = HttpConnect.new()
    #get current page body
    @page_body = @spi.get(url)
    @ps = PttSpider.new(timeage)
    @mo = Mongolib.new

    #work around for fix head post problem
    @count = 0
  end

  def run
    self.nextpage(@page_body,@btime)
  end

  def nextpage(page_body,btime)
    nextp = @ps.getnextpage(page_body, btime)
    if nextp && @count < 4
      page_body = @spi.get(nextp)
      self.getcontain(page_body)
      #work around for fix head post problem
      @count += 1
    else
      @logger.info("reach finish condistion job exit.")
      exit
    end
  end

  def getcontain(page_body)
    bo = @ps.get_list_url(page_body)
    tmp_btime = []
    bo.each{|b|
      if b[1] != nil
        post = @ps.getboard(@spi,b)
        if post == nil
          next
          @logger.info("skip this record")
        end
        tmp_btime = tmp_btime.push(post[:tdate])
        @mo.insert(post)
      end
    }
    btime = tmp_btime.sort{|t| - t }.first || @btime
    @logger.info("send page_body -> #{Time.at(btime).strftime('%Y%m%d %H:%M:%S')}")
    self.nextpage(page_body, btime)
  end

end
