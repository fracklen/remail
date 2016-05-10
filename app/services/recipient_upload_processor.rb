require 'tempfile'
require 'csv'

class RecipientUploadProcessor
  attr_reader :upload, :file, :recipient_list

  BULK_SIZE = 500

  class << self
    def process_delayed(upload)
      CsvImportWorker.perform_async(upload.id)
    end
  end

  def initialize(upload)
    @upload = upload
    @recipient_list = upload.recipient_list
    @headers = nil
  end

  def process
    write_file
    parse_chunks
    delete_file
  end

  private

  def queue_records(records)
    docs = {}
    records.each do |record|
      id = generate_id(record)
      docs[id] = transformed(record)
    end
    ElasticStorageWorker
      .perform_async('recipients','recipient', docs)
  end

  def generate_id(record)
    [recipient_list.uuid, record[:email]].join('-')
  end

  def transformed(record)
    result = {
      recipient_list_uuid: recipient_list.uuid,
      customer_uuid:       recipient_list.customer.uuid,
      created_at:          Time.zone.now,
      custom_data:         Hash[record],
      email:               record[:email],
    }
  end

  def parse_chunks
    records = []
    CSV.foreach(@file.path, {headers: true, header_converters: :symbol}) do |record|
      records << record
      if records.size > BULK_SIZE
        queue_records(records)
        records = []
      end
    end
    queue_records(records)
  end

  def write_file
    @file = Tempfile.new('upload')
    @file.write(upload.csv_data)
    upload.csv_data = nil # Allow massive GC
    @file.close
  end

  def delete_file
    @file.unlink
  end
end
