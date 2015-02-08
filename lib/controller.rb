require '../setup.rb'
require './http_connect.rb'
require './mongolib.rb'
require './ptt_spider.rb'

class Controller
  include Setup

  def initialize(url,limittime)
    #create spider object for conn
    @spi = HttpConnect.new()
    @modb = Mongolib.new
    @ps = PttSpider.new(limittime)
    @page_body = self.get_page_byhttpd(url)
    self.run
  end

  def get_page_byhttpd(url)
    #set retry = 3
    tries ||= 3
    begin
      #get current page body
      @page_body = @spi.get(url)
      raise "open page faild , try again" if !@page_body
      logger.info("scuessful get contain - #{url}")

      return @page_body
    rescue => e
      sleep 3
      retry unless (tries -= 1).zero?
      logger.error(e)
      return nil
    end
  end

  def run
    @logger.info("application started.")
    self.previouspage(@page_body,Time.now.to_i)
  end

  def previouspage(page_body,current_page_time)
    prespage = @ps.previouspage(page_body,current_page_time)

    if prespage
      page_body = self.get_page_byhttpd(prespage)
      self.getcontain(page_body)
    else
      logger.info("reach finish condistion job exit.")
      exit
    end

  end

  def getcontain(page_body)
    bo = @ps.get_list_url(page_body)
    current_page_time = nil
    bo.each{|b|
      if b[1] != nil
        post = @ps.getboard(@spi,b)
        if post == nil
          next
          logger.error("skip this record")
        end
        current_page_time = post[:tdate]
        @modb.insert(post)
      end
    }
    logger.info("send current_page_time -> #{Time.at(current_page_time).strftime('%Y%m%d %H:%M:%S')}")
    self.previouspage(page_body,current_page_time)
  end

end
