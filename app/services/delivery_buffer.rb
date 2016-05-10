class DeliveryBuffer

  attr_reader :campaign_run

  BULK_SIZE = 500

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @buffer = {}
  end

  def push(recipient_uuid, recipient, mail)
    @buffer[mail.message_id] = transformed(recipient_uuid, recipient, mail)
    flush if @buffer.size > BULK_SIZE
  end

  def flush
    ElasticStorageWorker
      .perform_async('deliveries','delivery', @buffer)
    @buffer = {}
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
end




