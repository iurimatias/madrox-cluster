require 'sourcify'
require 'socket'
require 'eventmachine'
require 'json'
require 'parallel'
require 'pry'

module Madrox
  module ServerHandler
    def post_init
      port, ip = Socket.unpack_sockaddr_in(self.get_peername)
      puts "#{ip} has connected"
    end

    def register(reference, code)
      eval("#{reference} = #{code}.call()")
    end

    def receive_data package
      Thread.new {
        data = JSON.parse(package)
        case data["type"]
        when "register"
          register(data["reference"], data["code"])
        when "execute"
          args = data["args"].size == 1 ? data["args"].first : data["args"]
          result = eval(data["code"]).call(args)
          send_data result.to_s + "\n"
        end
      }
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
