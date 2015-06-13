#初始安裝
* 建議使用ruby 2.2以上版本
* project git clone 完成之後執行
bundle install


#如何運行
<code>
cd lib

ruby execute.rb
</code>

#如何設定爬蟲

* lib/execute.rb
* 表示抓gossip 版的資料 , 往回抓取一個小時的內容<br>
<code>
  Main.new({:limittime => 60* 60}) 
</code>
* 如果你想要抓其他的版<br>
<code>
  Main.new({:url => "https://www.ptt.cc/bbs/Hate/index.html", :limittime => 60* 60})
</code>
<br>
#資料預設是存放至mongodb , 可以修改
* lib/mongolib.rb<br>
<code>

#建議使用2.6.x版本.3.1.x好像會有問題...

#設定mognodb -> 先執行mongo 連進去
<code>
use pttdb

db.createUser(
{ user: "pttuser",
  pwd: "pttpasswd",
  roles: [
    "readWrite"
  ],
  writeConcern: { w: "majority" , wtimeout: 5000 }
})

db.gossips.ensureIndex( { url: 1 }, { unique: true } )
</code>

<code>
#將帳號密碼設到環境變數-> 放到 ~/.bash_profile 中 (mac) 如果是linux就放到
~/.bashrc中
export mongoacct="pttuser"
export mongopass="pttpasswd"
</code>
