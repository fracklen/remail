class PixelTracker
  attr_reader :campaign_run

  def initialize(campaign_run)
    @campaign_run = campaign_run
  end

  def track_opens(rendered, msg_id)
    doc = Nokogiri::HTML(rendered[:body])
    doc.css('html').first.add_child(generate_tag(msg_id, doc))
    {
      subject: rendered[:subject],
      body: doc.to_html
    }
  end

  def generate_tag(msg_id, doc)
    "<img src=\"#{tracking_url(msg_id)}\"></img>"
  end

  def tracking_url(id)
    [tracker_cname, "pixels", id].join('/')
  end

  def tracker_cname
    @cname ||= "http://#{campaign.domain.link_hostname}"
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
