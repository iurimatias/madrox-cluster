module Madrox
  class Host
    attr_accessor :jobs

    def initialize(hostname, port)
      @hostname = hostname
      @port     = port
      @jobs     = 0
    end

    def connect
      @connection = TCPSocket.new(@hostname, @port)
    end

    def send(package, should_get_reply=true)
      @connection.connect
      @connection.sendmsg package #add \n

      result = should_get_reply ? @connection.gets : nil

      close_connection
      result.chop
    rescue
      puts "error: retrying.."
      retry
    end

    def close_connection
      @connection.close
    end
    
  end
end
