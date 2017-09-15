class CampaignRunner
  attr_reader :campaign_run

  class << self
    def schedule(campaign_run)
      CampaignWorker.perform_async(campaign_run.id)
    end
  end

  def initialize(campaign_run)
    @campaign_run = campaign_run
  end

  def start
    update_state_start

    processed = campaign_run.processed
    sent = campaign_run.sent
    rejected = campaign_run.rejected

    iterator.find_each do |id, recipient|
      begin
        mailer.send_mail(id, recipient)
        sent += 1
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
        rejected += 1
      end

      processed += 1
      update_state(processed, sent, rejected)
    end
    update_state_end(processed)
  rescue => e
    update_error(e)
  ensure
    mailer.finish
  end

  def update_state(processed, sent, rejected)
    # Save the database...
    if total_recipients > 1000
      return unless processed % (total_recipients / 1000) == 0
    end

    @campaign_run.update_attributes(
      processed: processed,
      sent:      sent,
      rejected:  rejected
    )
  end

  def update_state_start
    @campaign_run.state            = 'STARTED'
    @campaign_run.total_recipients = total_recipients
    @campaign_run.save
  end

  def update_state_end(processed)
    @campaign_run.update_attributes(
      state: 'FINISHED',
      processed: total_recipients
    )
  end

  def update_error(e)
    @campaign_run.state      = 'ERROR'
    @campaign_run.last_error = "#{e.message}\n#{e.backtrace.join("\n")}"
    @campaign_run.save
  end

  def mailer
    @mailer ||= GmailMailer.new(campaign_run)
  end

  def iterator
    @iterator ||= RecipientIterator.new(recipient_list)
  end

  def total_recipients
    @total_recipients ||= recipient_list_service.count[recipient_list.uuid]
  end

  def recipient_list_service
    @recipient_list_service ||= RecipientListService
      .new(campaign_run.campaign.customer)
  end

  def recipient_list
    campaign_run.campaign.recipient_list
  end

end
