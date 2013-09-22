module Madrox
  class Host
    attr_accessor :jobs, :connection

    def initialize(hostname, port)
      @hostname = hostname
      @port     = port
      @jobs     = 0
      @semaphore = Mutex.new
    end

    def connect
      @connection = TCPSocket.new(@hostname, @port)
    rescue Errno::ECONNREFUSED => e
      raise "problem connecting to #{@hostname}:#{@port}"
    end

    def send(package, should_get_reply=true)
      @semaphore.lock
      connect
      @jobs += 1
      @connection.sendmsg package #add \n

      result = should_get_reply ? @connection.gets.chop : nil
      @jobs -= 1
      @semaphore.unlock

      result
    #rescue
    #  retry
    end

    def close_connection
      @connection.close
    end

  end
end
