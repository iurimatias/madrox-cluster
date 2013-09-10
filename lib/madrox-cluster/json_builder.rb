module Madrox
  class JsonPackage

    def self.register(reference, code)
      {:type => "register", :reference => reference, :code => code.to_source}.to_json
    end

    def self.execute(block, args=[])
      {:type => "execute", :code => block.to_source, :args => args}.to_json
    end

    def self.parse(package)
      json = JSON.parse(package)
      OpenStruct.new(json)
    end

  end
end
