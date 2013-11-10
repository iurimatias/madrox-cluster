require 'sourcify'
require 'socket'
require 'eventmachine'
require 'json'
require 'pry'

require "madrox-cluster/version"
require "madrox-cluster/host"
require "madrox-cluster/hosts_manager"
require "madrox-cluster/json_builder"
require "madrox-cluster/workers"

module Madrox

  class << self

    def config(host_list)
      HostsManager.add_hosts(host_list)
    end

    def register(reference, code)
      HostsManager.send_to_all JsonPackage.register(reference, code)
    end

    def execute(&block)
      host = HostsManager.get_next_free_host
      response = host.send JsonPackage.execute(block)
      result = JsonPackage.parse(response)
      eval(result.result.to_s)
    end

    def each(array, options = {}, &block)
      collect(array, options, &block)
      nil
    end

    def map(array, options={}, &block)
      collect(array, options, &block)
    end

    def collect(array, options = {}, &block)
      workers = Workers.new(array, block)
      result  = workers.execute
      
      return result
    end

  end
end
