#!/usr/bin/env ruby

require './lib/controller.rb'
require 'logger'

@logger = Logger.new('./logs/plog.log')
@logger.info("@execute it!")
#86400 * 25 = 重新抓取最近25天的資料
m = Controller.new('https://www.ptt.cc/bbs/Gossiping/index.html',86400 * 25)
m.run
