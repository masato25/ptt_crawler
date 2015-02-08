require '../setup.rb'
require './controller.rb'

class Main
  include Setup

  def initialize(args ={} )
    url = args[:url] || 'http://www.ptt.cc/bbs/Gossiping/index.html'
    limittime = args[:limittime] ||  60 * 60
    logger.info("init")
    #after initizlized , the application will auto execute!
    Controller.new(url,limittime)
  end

end


