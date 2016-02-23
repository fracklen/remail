class LinkTracker
  attr_reader :campaign_run

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @storage_buffer = LinkTrackerStorageBuffer.new(campaign_run)
  end

  def track_links(rendered, recipient_uuid, recipient, msg_id)
    doc = Nokogiri::HTML(rendered[:body])
    doc.css("a").each do |link|
      tracker = generate_link(link.attributes["href"].value)
      link.attributes["href"].value = redirect_link(tracker[:uuid])
      @storage_buffer.async.push(recipient_uuid, msg_id, tracker)
    end
    {
      subject: rendered[:subject],
      body: doc.to_html
    }
  end

  def flush
    @storage_buffer.future.flush.value
  end

  def generate_link(destination)
    {
      uuid: SecureRandom.hex,
      destination: destination
    }
  end

  def redirect_link(uuid)
    [tracker_cname, "links", uuid].join('/')
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
