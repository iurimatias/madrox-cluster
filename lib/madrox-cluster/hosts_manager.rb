module Madrox
  class HostsManager

    def self.add_hosts(host_list)
      host_list.each do |host|
        hostname, port = host.split(":")
        add_host(hostname, port)
      end
    end

    def self.add_host(hostname, port)
      @@hosts ||= []
      @@hosts << Host.new(hostname, port)
    end

    def self.get_next_free_host
      @@hosts.min_by { |h| h.jobs }
    end

    def self.get_free_hosts()
      @@hosts.select { |host| host.jobs == 0 }
    end

    def self.send_to_all(payload)
      @@hosts.each { |host| host.send payload, false }
    end

    def self.close_connections
      @@hosts.map(&:close_connection)
    end

  end
end
