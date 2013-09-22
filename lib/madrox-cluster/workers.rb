module Madrox
  class Workers

    def initialize(array, block)
      @result    = []
      @job_queue = array.to_a
      @threads   = []
      @block     = block
      @semaphore = Mutex.new
      @index = -1
    end

    def execute
      execute_jobs
      @threads.map(&:join) #wait for all threads to finish
      HostsManager.close_connections
      @result
    end

    private

    def execute_jobs
      connections = HostsManager.get_free_hosts
      initial_jobs = @job_queue.shift connections.count

      initial_jobs.each_with_index do |value, index|
        @semaphore.lock
        @index += 1
        @semaphore.unlock
        execute_job(connections[index], value, index)
      end
    end

    def execute_job(connection, value, index)
      @threads << Thread.new {
        response = connection.send JsonPackage.execute(@block, [value])
        result = JsonPackage.parse(response)

        execute_next_job
        res = eval(result.result.to_s)
        @result[index] = res
      }
    end

    def execute_next_job
      @semaphore.lock
      connection = HostsManager.get_next_free_host
      value = @job_queue.shift
      @index += 1
      index = @index
      @semaphore.unlock

      return if value.nil?
      execute_job(connection, value, index)
    end

  end
end
