#初始安裝
* 建議使用ruby 2.2以上版本
* project colone 完成之後執行
bundle install


#如何設定爬蟲

* lib/execute.rb
* 表示抓gossip 版的資料 , 往回抓取一個小時的內容
<code>
  Main.new({:limittime => 60* 60}) 
</code>
* 如果你想要抓其他的版
<code>
  Main.new({:url => "https://www.ptt.cc/bbs/Hate/index.html", :limittime => 60* 60})
</code>

#資料預設是存放至mongodb , 可以修改
* lib/mongolib.rb
<code>
def initialize                                                                                                        
  #set mongodb url & port
  mongo_client = MongoClient.new("localhost", 7474)                                                                
  db = mongo_client.db("pttdb")                                                                                       
  @coll = db.collection("gossips")                                                                                    
end 
</code>
