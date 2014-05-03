class Burrow::Client
  attr_reader :queue_name, :message, :connection

  def initialize(queue_name, params={})
    @queue_name = queue_name
    @message    = Message.new(params)
    @connection = Connection.new(queue_name)
  end

  def self.call(queue_name, params)
    new(queue_name, params).call
  end

  def call
    publish
    subscribe
  end

  def publish
    connection.exchange.publish(json.generate(message.attributes), {
      message_id:  message.id
      reply_to:    connection.return_queue.name,
      routing_key: connection.queue.name
    })
    message.id
  end

  def subscribe
    connection.return_queue.subscribe(block: true) do |delivery_info, properties, payload|
      if properties[:correlation_id] == message_id
        response = payload
        delivery_info.consumer.cancel
      end
    end
    JSON.parse(response)
  end
end
