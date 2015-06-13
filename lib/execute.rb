require './main.rb'

#每45min跑一次
Main.new({:url => "https://www.ptt.cc/bbs/Gossiping/index.html",:limittime => 60* 45})
