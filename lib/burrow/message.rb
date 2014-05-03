class Burrow::Message
  attr_reader: :params

  def initialize(params={})
    @params = params
  end

  def id
    @id ||= SecureRandom.hex
  end

  def attributes
    default_attributes.merge(params)
  end

  def default_attributes
    { jsonrpc: '2.0' }
  end
end
