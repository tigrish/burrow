module Burrow
  class Client
    attr_reader :connection, :request

    def initialize(queue)
      @connection = Burrow::Connection.new(queue)
    end

    def publish(method, params={})
      @request = Burrow::Request.new(method, params)
      publish_request
      subscribe_response
    end

  protected

    def publish_request
      connection.exchange.publish(
        request.json, {
          correlation_id: request.id,
          reply_to:       connection.return_queue.name,
          routing_key:    connection.queue.name
        }
      )
    end

    def subscribe_response
      response = nil
      connection.return_queue.subscribe(block: true) do |delivery_info, properties, payload|
        if properties[:correlation_id] == request.id
          response = payload
          delivery_info.consumer.cancel
        end
      end
      JSON.parse(response)
    end
  end
end
