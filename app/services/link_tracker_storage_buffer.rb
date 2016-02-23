class LinkTrackerStorageBuffer
  include Celluloid

  attr_reader :campaign_run

  BULK_SIZE = 1000

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @buffer = []
  end

  def push(recipient_uuid, message_id, link)
    @buffer << {
        index: {
          _index: 'trackers',
          _type: 'link',
          _id: link.fetch(:uuid),
          data: transformed(recipient_uuid, message_id, link)
        }
      }
    flush if @buffer.size > BULK_SIZE
  end

  def flush

    client.bulk(body: @buffer) if @buffer.any?
    @buffer.clear
  rescue => e
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("#\n"))
  end

  def transformed(recipient_uuid, message_id, link)
    {
      created_at:           Time.zone.now,
      message_id:           message_id,
      recipient_uuid:       recipient_uuid,
      recipient_list_uuid:  recipient_list_uuid,
      customer_uuid:        customer_uuid,
      campaign_uuid:        campaign.uuid,
      campaign_run_uuid:    campaign_run.uuid,
      link_to:              link.fetch(:destination)
    }
  end

  def recipient_list_uuid
    @recipient_list_uuid ||= campaign.recipient_list.uuid
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
    @client = ::Elasticsearch::Client.new log: false
    @client.transport.reload_connections!
    @client
  end
end
