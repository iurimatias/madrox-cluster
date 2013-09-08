require 'sourcify'
require 'socket'
require 'eventmachine'
require 'json'
require 'parallel'
require 'pry'

module Madrox
  module ServerHandler
    def post_init
      #send_data "free"
    end

    #possible calls
    # execute
    # register

    #TODO: make this non blockable
    def receive_data data
      #send_data "busy"
      packages = data.split("|||")
      puts "got"
      puts packages
      packages.each do |package|
        #Thread.new {
          #binding.pry
          data = JSON.parse(package)
          args = data["args"].size == 1 ? data["args"].first : data["args"]
          result = eval(data["code"]).call(args)
          puts result
          send_data result.to_s + "\n"
          puts "sending msg... #{result}"
        #}
      end
    end

    def unbind
      puts "-- someone disconnected from the echo server!"
    end
  end

  class Server
    def self.start(hostname, port=2000)
      puts "starting server on #{hostname}:#{port}"
      EventMachine.run {
        EventMachine.start_server hostname, port, ServerHandler
      }
    end
  end

end
