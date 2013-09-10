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
    rescue Errno::ECONNREFUSED => e
      puts "problem connecting to #{@hostname}:#{@port}"
      #TODO: get another connection instead
      exit
    end

    def send(package, should_get_reply=true)
      connect
      @connection.sendmsg package #add \n

      result = should_get_reply ? @connection.gets.chop : nil

      close_connection
      result
    #rescue
    #  retry
    end

    def close_connection
      @connection.close
    end
    
  end
end
