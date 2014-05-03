class Burrow::Client
  attr_reader :message, :connection

  def initialize(queue, method, params={})
    @connection = Burrow::Connection.new(queue)
    @message    = Burrow::Message.new(method, params)
  end

  def self.call(queue, method, params)
    new(queue, method, params).call
  end

  def call
    publish
    subscribe
  end

  def publish
    connection.exchange.publish(
      JSON.generate(message.attributes), {
        correlation_id: message.id,
        reply_to:       connection.return_queue.name,
        routing_key:    connection.queue.name
      }
    )
  end

  def subscribe
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
