module Madrox
  class JsonPackage
    class << self

      def register(reference, code)
        {:type => "register", :reference => reference, :code => code.to_source}.to_json
      end

      def execute(block, args=[])
        {:type => "execute", :code => block.to_source, :args => args}.to_json
      end

      def result(result)
        {:type => "result", :result => result}.to_json
      end

      def parse(package)
        json = JSON.parse(package)
        OpenStruct.new(json)
      end

    end
  end
end
