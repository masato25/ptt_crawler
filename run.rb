#!/usr/bin/env ruby

require './lib/controller.rb'
require 'logger'

@logger = Logger.new('./logs/plog.log')
@logger.info("@execute it!")
# 60 * 50 = 50分鐘
m = Controller.new('https://www.ptt.cc/bbs/Gossiping/index.html', 60 * 50)
m.run
