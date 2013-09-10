module Madrox
  module ServerHandler

    def post_init
      port, ip = Socket.unpack_sockaddr_in(self.get_peername)
      puts "#{ip} has connected"
    end

    def register(reference, code)
      eval("#{reference} = #{code}.call()")
    end

    def execute(code, args)
      args = args.first if args.size == 1
      eval(code).call(args)
    end

    #TODO: note, perhaps response should come in a json response as well
    #it could have a 'reference' number, so the connection can be reused
    #and the client knows what result it corresponds to

    def receive_data(package)
      #Thread.new do
        data = JsonPackage.parse(package)
        puts "-----"
        puts data
        case data.type
        when "register"
          register(data.reference, data.code)
        when "execute"
          result = execute(data.code, data.args)
          send_data result.to_s + "\n"
        end
      #end
    end

  end
end
