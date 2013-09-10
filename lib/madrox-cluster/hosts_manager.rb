module Madrox
  class HostsManager

    def self.add_hosts(host_list)
      host_list.each do |host|
        hostname, port = host.split(":")
        add_host(hostname, port)
      end
    end

    def self.add_host(hostname, port)
      #TODO: use set instead
      @@hosts ||= []
      @@hosts << Host.new(hostname, port)
    end

    def self.get_next_free_host
      #@@hosts.find { |h| h[:status] == "free" }
      server = @@hosts.min_by { |h| h.jobs }
      server.jobs += 1
      server
    end

    def self.get_free_hosts(num)
      #create connections first to avoid race conditions
      #NOTE: perhaps connections can be reused..., with concurrency this can be
      #tricky..
      connections = (1..num).collect do |x|
        host = self.get_next_free_host
        host.connect
        host
      end
    end

  end
end
