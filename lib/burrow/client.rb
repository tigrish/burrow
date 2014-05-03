class Burrow::Client
  attr_reader :connection

  def initialize(queue)
    @connection = Burrow::Connection.new(queue)
  end

  def publish(method, params={})
    message = Burrow::Message.new(method, params)

    connection.exchange.publish(
      JSON.generate(message.attributes), {
        correlation_id: message.id,
        reply_to:       connection.return_queue.name,
        routing_key:    connection.queue.name
      }
    )

    response = nil
    connection.return_queue.subscribe(block: true) do |delivery_info, properties, payload|
      if properties[:correlation_id] == message.id
        response = payload
        delivery_info.consumer.cancel
      end
    end
    JSON.parse(response)
  end
end
