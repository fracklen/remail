require 'tempfile'
require 'csv'

class RecipientUploadProcessor
  attr_reader :upload, :file, :recipient_list

  BULK_SIZE = 1000

  class << self
    def process_delayed(upload)
      delay.process_id(upload.id)
    end

    def process_id(upload_id)
      new(RecipientListUpload.find(upload_id)).process
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

  def push_records(records)
    bulk = []
    records.each do |record|
      bulk << {
        index: {
          _index: 'recipients',
          _type: 'recipient',
          _id: generate_id(record),
          data: transformed(record)
        }
      }
    end
    client.bulk body: bulk
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
        push_records(records)
        records = []
      end
    end
    push_records(records)
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

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: true
    @client.transport.reload_connections!
    @client
  end
end
