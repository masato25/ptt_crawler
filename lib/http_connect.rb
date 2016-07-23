#!/usr/bin/env ruby

require 'net/http'
require 'net/https'

class HttpConnect

  def initialize(useragent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36")
    @logger = Logger.new('./logs/plog.log')
    @http = Net::HTTP.new('www.ptt.cc', 443)
    px = {}
    begin
      @http.use_ssl = true
      path = '/ask/over18'
      px = @http.post(path, 'yes=yes')
    rescue
      px['set-cookie'] = "over18=1; Path=/"
    end
    @cookie = px['set-cookie']
    @useragnet = useragent
  end

  def get(url = 'http://www.ptt.cc/bbs/Gossiping/index.html')
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['Cookie'] = @cookie 
    req.add_field('User-Agent',@useragent)
		rurl = ""		
		begin
    	rurl = @http.request(req).body
		rescue
			sleep 3
    	rurl = @http.request(req).body
		end
    #@logger.info("get first url: #{rurl}")
    #return rurl
  end

end

