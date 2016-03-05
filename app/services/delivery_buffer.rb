class DeliveryBuffer
  include Celluloid

  attr_reader :campaign_run

  BULK_SIZE = 1000

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @buffer = []
  end

  def push(recipient_uuid, recipient, mail)
    @buffer << {
        index: {
          _index: 'deliveries',
          _type: 'delivery',
          _id: mail.message_id,
          data: transformed(recipient_uuid, recipient, mail)
        }
      }
    flush if @buffer.size > BULK_SIZE
  end

  def flush
    client.bulk body: @buffer
    @buffer.clear
  end

  def transformed(recipient_uuid, recipient, mail)
    {
      created_at:           Time.zone.now,
      message_id:           mail.message_id,
      recipient_uuid:       recipient_uuid,
      recipient_list_uuid:  recipient['recipient_list_uuid'],
      customer_uuid:        customer_uuid,
      campaign_uuid:        campaign.uuid,
      campaign_run_uuid:    campaign_run.uuid,
      email:                recipient['email']
    }
  end

  def customer_uuid
    @customer_uuid ||= customer.uuid
  end

  def customer
    @customer ||= campaign.customer
  end

  def campaign
    @campaign ||= campaign_run.campaign
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: true
    @client.transport.reload_connections!
    @client
  end
end




