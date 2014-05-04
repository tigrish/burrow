module Burrow
  class Response
    attr_reader :id, :params

    def initialize(id, params)
      @id     = id
      @params = params
    end

    def json
      JSON.generate(attributes)
    end

    def attributes
      {
        id:     id,
        result: params,
        jsonrpc: '2.0'
      }
    end
  end
end
