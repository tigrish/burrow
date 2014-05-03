class Burrow::Server
  attr_reader :connection

  def initialize(queue)
    @connection = Burrow::Connection.new(queue)
  end

  def subscribe
    connection.queue.subscribe(block: true) do |delivery_info, properties, payload|
      request  = JSON.parse(payload)
      result   = yield [request['method'], request['params']]
      response = Burrow::Response.new(request['id'], result)
      publish_response(response, properties)
    end
  end

protected

  def publish_response(response, properties)
    connection.exchange.publish(
      response.json, {
        routing_key:    properties.reply_to,
        correlation_id: properties.correlation_id
      }
    )
  end
end
