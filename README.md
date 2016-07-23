# PTT Web Ruby spider v2

### 初始安裝
* 建議使用ruby 2.3.1 以上版本
* project git clone 完成之後執行 `bundle install`

### 如何運行
```
#How to use it!
edit -> run.rb

#How to change the qeruy page by time range
Controller.new('https://www.ptt.cc/bbs/Gossiping/index.html',86400 * 10)
```
### 如何設定爬蟲
* lib/execute.rb
* 表示抓gossip 版的資料 , 往回抓取一個小時的內容 `Main.new({:limittime => 60* 60})`
* 如果你想要抓其他的版 `Main.new({:url => "https://www.ptt.cc/bbs/Hate/index.html", :limittime => 60* 60})`
* 資料預設是存放至 `mongodb` , 可以修改 `lib/mongolib.rb`
* 如果想要寫入其他資料庫就需要自己修改程式了. (歡迎PR!)

### 設定mognodb
先執行mongo 連進去
```
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
```
設定環境變數
```
#將帳號密碼設到環境變數-> 放到 ~/.bashrc 中
export mongoacct="pttuser"
export mongopass="pttpasswd"
```
