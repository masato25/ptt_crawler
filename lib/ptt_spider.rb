#!/usr/bin/env ruby
require 'nokogiri'
require 'date'
require './lib/post.rb'
require './lib/mongolib'
require 'logger'

class PttSpider
  
  def initialize(timeage = 60 * 32)
    @mdb = Mongolib.new
    @logger = Logger.new('./logs/plog.log')
    @timeage = timeage
  end
    
  def get_list_url(body)
    page = Nokogiri::HTML(body)
    posts = page.css("#main-container").css(".r-ent")
    result = []
    posts.each{|p|
      mark = p.css('.mark').text || 0
      title = p.css('.title').text || ""
      title = title.gsub(/(^\s+|\s+$)/,"")
      url = p.css('a').first || nil
      url = "https://www.ptt.cc" + url["href"] if url != nil
      result = result.push([title,url])
    }
    result
  end

  def getnextpage(body,ptime)
    page = Nokogiri::HTML(body)
    page = page.css("div.btn-group.btn-group-paging")
    sleep Random.rand(8)
    #60 * 32
    if (Time.now.to_i - @timeage) < ptime
      begin
        url = 'https://www.ptt.cc' + page.css("a")[1]['href'] 
        @logger.info(url)
        url
      rescue => e
        @logger.error(e)
        @logger.error(page.css("a")[1])
      end
    else
      @logger.error( 'https://www.ptt.c' + page.css("a")[1]['href'])
      return false
    end
  end

  def getcontian(contain)
    contain = contain.sub(/[\w\W]+<span class=\"article-meta-tag\">時間<\/span>[\w\W]+?<\/div>/,'')
    contain = contain.sub(/<span class=\"f2\">.+來自:[\w\W]+/,'')
  end

  def getboard(web_obj,cbody)
      title, url = cbody
      body = web_obj.get(url)
      tdate, author, author_nick_name, src, contain = nil, nil, nil, nil, nil
    begin
      page = Nokogiri::HTML(body)
      page = page.css("#main-container")
      author = page.css(".article-meta-value").first.text.force_encoding("utf-8")
      tdate = page.css(".article-meta-value")[3].text + " +0800"
      tdate = DateTime.strptime(tdate, "%a %b %d %H:%M:%S %Y %z").to_time.to_i
      author_nick_name = author.scan(/\((.*?)\)/)[0][0]
      author = author.gsub(/\s*\(.+/,"")
      src = page.to_s.scan(/批踢踢實業坊\(ptt\.cc\), 來自: (\d+\.\d+\.\d+\.\d+)/)[0][0]
      contain = page.to_s
      contain = getcontian(contain).force_encoding("utf-8")
      Post.new(tdate, url, title, author, author_nick_name, src, contain)
    rescue => e
      @logger.error(e)
      @logger.error([tdate, url, title, author, author_nick_name, src].join(","))
      return nil
    end
  end

end
