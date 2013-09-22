require 'sourcify'
require 'socket'
require 'eventmachine'
require 'json'
require 'parallel'
require 'pry'

require 'madrox-cluster/json_builder'
require 'madrox-cluster/server/server_handler'

module Madrox

  class Server
    def self.start(hostname, port=2000)
      puts "starting server on #{hostname}:#{port}"
      puts "WARNING: Madrox is still under development! expect glitches!"
      EventMachine.run {
        EventMachine.start_server hostname, port, ServerHandler
      }
    end
  end

end
