require 'sourcify'
require 'socket'
require 'eventmachine'
require 'json'
require 'parallel'
require 'pry'

require "madrox-cluster/version"
require "madrox-cluster/host"
require "madrox-cluster/hosts_manager"
require "madrox-cluster/json_builder"

module Madrox

  def self.config(host_list)
    HostsManager.add_hosts(host_list)
  end

  def self.register(reference, code)
    host = HostsManager.get_next_free_host
    host.send JsonPackage.register(reference, code), false
  end

  def self.execute(&block)
    host = HostsManager.get_next_free_host
    response = host.send JsonPackage.execute(block)
    result = JsonPackage.parse(response)
    eval(result.result.to_s)
  end

  def self.each(array, options = {}, &block)
    self.collect(array, options, &block)
    nil
  end

  def self.map(array, options={}, &block)
    self.collect(array, options, &block)
  end

  def self.collect(array, options = {}, &block)
    array = array.to_a # force Enumerables into an Array

    connections = HostsManager.get_free_hosts(array.size)

    #map only x-available servers, loop until all is complete
    collection = Parallel.map_with_index(array, :in_threads => array.size) do |x, index|
    #collection = array.each_with_index do |x, index|
      #TODO: ideal would be to delay this until there is a 'free' server
      connection = connections[index]
      
      response = connection.send JsonPackage.execute(block, [x])
      result = JsonPackage.parse(response)

      eval(result.result.to_s)
    end

    collection
  end

end
