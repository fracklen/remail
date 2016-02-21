class CsvImportWorker
  include Sidekiq::Worker
  def perform(upload_id)
    upload = RecipientListUpload.find(upload_id)
    RecipientUploadProcessor.new(upload).process
  end
end
