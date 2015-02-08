require 'net/http'
require 'net/https'
require '../setup.rb'

class HttpConnect
  include Setup

  def initialize
    @useragent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36"
    @http = Net::HTTP.new('www.ptt.cc', 443)
    px = {}
    begin
      @http.use_ssl = true
      path = '/ask/over18'
      # post ansert
      px = @http.post(path, 'yes=yes')
    rescue => e
      logger.error(e)
      px['set-cookie'] = "over18=1; Path=/"
    end
    @cookie = px['set-cookie']
  end

  def get(url = 'http://www.ptt.cc/bbs/Gossiping/index.html')
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    #set cookie
    req['Cookie'] = @cookie
    req.add_field('User-Agent',@useragent)
    rurl = @http.request(req).body
  end

end
