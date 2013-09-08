require 'sourcify'
require 'socket'
require 'eventmachine'
require 'json'
require 'parallel'
require 'pry'

require "madrox-cluster/version"

module Madrox

  def self.config(host_list)
    @@hosts = host_list.collect do |host|
      hostname, port = host.split(":")
      puts "connecting to #{hostname}:#{port}"

      {jobs: 0, hostname: hostname, port: port}
    end
  end

  def self.get_next_free_host
    #@@hosts.find { |h| h[:status] == "free" }
    server = @@hosts.min_by { |h| h[:jobs] }
    server[:jobs] += 1
    server
    #@@hosts.sample
  end

  def self.execute(&block)
    host = self.get_next_free_host
    connection = TCPSocket.new(host[:hostname], host[:port]) 

    package = {type: "execute", code: block.to_source, args: []}.to_json

    connection.sendmsg package

    puts "finished sending msg"
    result = ""
    if line = connection.gets
      result << line
      puts "received #{line.chop}"
    end

    connection.close
    puts "finished receiving msg"
    eval(result.chop)
  end

  def self.each(array, options = {}, &block)
    array = array.to_a # force Enumerables into an Array

    #create connections first to avoid race conditions
    #NOTE: perhaps connections can be reused..., with concurrency this can be
    #tricky..
    connections = array.collect do |x|
      host = self.get_next_free_host
      TCPSocket.new(host[:hostname], host[:port]) 
    end

    res = Parallel.each_with_index(array, :in_threads => array.size) do |x, index|
      #TODO: ideal would be to delay this until there is a 'free' server
      connection = connections[index]

      begin
        package = {type: "execute", code: block.to_source, args: [x]}.to_json

        connection.sendmsg package # + "|||"
      rescue
        puts "error: retrying.."
        retry
      end

      puts "finished sending msg"
      result = ""
      if line = connection.gets
        result << line
        puts "received #{line.chop}"
      end

      connection.close
      puts "finished receiving msg"
      eval(result.chop)
    end

    res
  end

  def self.map(array, options={}, &block)
    self.collect(array, options, &block)
  end

  def self.collect(array, options = {}, &block)
    array = array.to_a # force Enumerables into an Array

    #create connections first to avoid race conditions
    #NOTE: perhaps connections can be reused..., with concurrency this can be
    #tricky..
    connections = array.collect do |x|
      host = self.get_next_free_host
      TCPSocket.new(host[:hostname], host[:port]) 
    end

    #map only x-available servers, loop until all is complete
    res = Parallel.map_with_index(array, :in_threads => array.size) do |x, index|
      #TODO: ideal would be to delay this until there is a 'free' server
      connection = connections[index]

      begin
        package = {type: "execute", code: block.to_source, args: [x]}.to_json

        connection.sendmsg package # + "|||"
      rescue
        puts "error: retrying.."
        retry
      end

      puts "finished sending msg"
      result = ""
      if line = connection.gets
        result << line
        puts "received #{line.chop}"
      end

      connection.close
      puts "finished receiving msg"
      eval(result.chop)
    end

    res
  end

end
