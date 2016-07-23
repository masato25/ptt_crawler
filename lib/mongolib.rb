#!/usr/bin/env ruby

require 'json'
require 'json/add/core'
require 'mongo'
require 'logger'

#db.gossip.ensureIndex( { url: 1 }, { unique: true } )
class Mongolib

  def initialize
    @logger = Logger.new('./logs/plog.log')

		db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => "pttdb", :user => ENV["railsmongoaccd"], :password => ENV["railsmongopasswd"])
    @coll = db[:gossips]

  end
 
  def to_json(post)
    JSON.parse(JSON.pretty_generate(post))
  end

  def insert(post)
    begin
      @coll.insert_one(self.to_json(post))
    #rescue Mongo::OperationFailure => e
      #puts e
      #if need alert key insert duplicate , open this
      #@logger.error("already had same url key , skip")
    rescue => e
      @logger.error(e)
      @logger.error(post.to_s)
    end
  end

  def query(q=nil)
    @coll.find().first
  end
end
