require './lib/http_connect.rb'
require './lib/ptt_spider.rb'
require './lib/controller.rb'


describe "new main" do
  it "when we new main it need retrun a object" do
    Controller.new != nil
  end
  it "test url paser" do
    s = HttpConnect.new
    pt = PttSpider.new
    puts pt.getboard(s,['ff', 'https://www.ptt.cc/bbs/Gossiping/M.1421449793.A.7A7.html'])
    pt != nil
  end
  it "test datetime" do
    teststr = "Sat Jan 17 01:33:47 2015 +0800".sub("Sat ","")
    puts teststr
    puts DateTime.strptime(teststr, "%b %d %H:%M:%S %Y %z").to_time
    
  end
end
