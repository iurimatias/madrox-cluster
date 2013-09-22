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
require "madrox-cluster/workers"

module Madrox

  def self.config(host_list)
    HostsManager.add_hosts(host_list)
  end

  def self.register(reference, code)
    HostsManager.send_to_all JsonPackage.register(reference, code)
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
    workers = Workers.new(array, block)
    result  = workers.execute
    
    return result
  end

end
