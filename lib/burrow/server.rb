class Burrow::Server
  attr_reader :connection

  def initialize(queue)
    @connection = Burrow::Connection.new(queue)
  end

  def subscribe
    connection.queue.subscribe(block: true) do |delivery_info, properties, payload|
      request  = JSON.parse(payload)

      response = yield [request['method'], request['params']]

      reply = {
        'id'      => request['id'],
        'result'  => response,
        'jsonrpc' => '2.0'
      }

      connection.exchange.publish(
        JSON.generate(reply), {
          routing_key:    properties.reply_to, 
          correlation_id: properties.correlation_id
        }
      )
    end
  end
end
