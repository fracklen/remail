require 'elasticsearch'

namespace :elastic do
  desc "Set up indexes"
  task setup: [:deliveries] do

  end

  task :deliveries do
    client.indices.create(
      index: 'recipients_v1',
      body: {
        settings: {
          index: {
            number_of_shards: 91,
            number_of_replicas: 1
          }
        }
      }
    )

    client.indices.put_alias(
      index: 'recipients_v1',
      name:  'recipients'
    )

    client.indices.put_mapping(
      index: 'recipients_v1',
      type:  'recipient',
      body: {
        recipient: {
          properties: {
            _rev:       { type: :string },

            created_at: {
              type: :date,
              format: :dateOptionalTime
            },

            recipient_list_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            customer_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            email: {
              type: :string
            },

            custom_data: { type: :object }
          }
        }
      }
    )
  end


  def client
    @client ||= Elasticsearch::Client.new log: true
  end

  def url
    ENV['ELASTICSEARCH_URL'] || 'http://127.0.0.1:9200'
  end

end