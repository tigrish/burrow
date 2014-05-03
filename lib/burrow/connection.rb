class Burrow::Connection
  attr_reader :queue_name

  def initialize(queue_name)
    @queue_name = queue_name
  end

  def connection
    @connection ||= begin
      c = Bunny.new
      c.start
      c
    end
  end

  def channel
    @channel ||= connection.create_channel
  end

  def queue
    channel.queue(queue_name, auto_delete: false)
  end

  def exchange
    @exchange ||= channel.default_exchange
  end

  def return_queue
    channel.queue('', exclusive: true)
  end
end