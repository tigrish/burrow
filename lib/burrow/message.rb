class Burrow::Message
  attr_reader :method, :params

  def initialize(method, params={})
    @method = method
    @params = params
  end

  def id
    @id ||= SecureRandom.hex
  end

  def attributes
    { jsonrpc: '2.0',
      id:      id,
      method:  method,
      params:  params
    }
  end
end
