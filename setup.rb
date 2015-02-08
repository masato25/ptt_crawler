require 'logger'

module Setup

  def logger
    if @logger == nil
      @logger = Logger.new("#{pwd}/log/debug.log", 'daily')
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    end
    @logger
  end

  def pwd
    File.expand_path(File.dirname(__FILE__))
  end
end
