require 'json'
require 'json/add/core'
require 'mongo'
require '../setup.rb'

#db.gossips.ensureIndex( { url: 1 }, { unique: true } )
class Mongolib
  include Mongo
  include Setup

  def initialize
    mongo_client = MongoClient.new("localhost", 7474)
    db = mongo_client.db("pttdb")
    @coll = db.collection("gossips")
  end

  def to_json(post)
    JSON.parse(JSON.pretty_generate(post))
  end

  def insert(post)
    begin
      @coll.insert(self.to_json(post))
    rescue Mongo::OperationFailure => e
      puts e
      #if need alert key insert duplicate , open this
      #@logger.error("already had same url key , skip")
    rescue => e
      logger.error(e)
      logger.error(post.to_s)
    end
  end

  def query(q=nil)
    @coll.find().first
  end
end
