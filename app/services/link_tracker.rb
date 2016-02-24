class LinkTracker
  attr_reader :campaign_run, :storage_buffer

  def initialize(campaign_run)
    @campaign_run = campaign_run
  end

  def track_links(rendered, recipient_uuid, msg_id)
    doc = Nokogiri::HTML(rendered[:body])
    doc.css('a').each do |link|
      process_link(link, recipient_uuid, msg_id)
    end
    {
      subject: rendered[:subject],
      body: doc.to_html
    }
  end

  def process_link(link, recipient_uuid, msg_id)
    return if link.attributes['href'].value.include?(tracker_cname)
    tracker = generate_link(link.attributes['href'].value)
    link.attributes['href'].value = redirect_link(tracker[:uuid])
    storage_buffer.async.push(recipient_uuid, msg_id, tracker)
  end

  def flush
    storage_buffer.future.flush.value
  end

  def finish
    storage_buffer.terminate
  end

  def generate_link(destination)
    {
      uuid: SecureRandom.hex,
      destination: destination
    }
  end

  def redirect_link(uuid)
    [
      tracker_cname,
      'links',
      uuid
    ].join('/')
  end

  def tracker_cname
    @cname ||= "http://#{campaign.domain.name}"
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

  def storage_buffer
    @storage_buffer ||= LinkTrackerStorageBuffer.new(campaign_run)
  end

end
