require 'elasticsearch'

namespace :elastic do
  desc "Set up indexes"
  task setup: [
    :recipients,
    :deliveries,
    :link_trackers,
    :click_events,
    :open_events
  ]

  task :recipients do
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
    ) unless client.indices.exists?(index: 'recipients_v1')

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

  task :deliveries do
    client.indices.create(
      index: 'deliveries_v1',
      body: {
        settings: {
          index: {
            number_of_shards: 91,
            number_of_replicas: 1
          }
        }
      }
    ) unless client.indices.exists?(index: 'deliveries_v1')

    client.indices.put_alias(
      index: 'deliveries_v1',
      name:  'deliveries'
    )

    client.indices.put_mapping(
      index: 'deliveries_v1',
      type:  'delivery',
      body: {
        delivery: {
          properties: {
            _rev:       { type: :string },

            created_at: {
              type: :date,
              format: :dateOptionalTime
            },

            recipient_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
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

            campaign_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            campaign_run_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            email: {
              type: :string
            }
          }
        }
      }
    )
  end

  task :link_trackers do
    client.indices.create(
      index: 'trackers_v1',
      body: {
        settings: {
          index: {
            number_of_shards: 91,
            number_of_replicas: 1
          }
        }
      }
    ) unless client.indices.exists?(index: 'trackers_v1')

    client.indices.put_alias(
      index: 'trackers_v1',
      name:  'trackers'
    )

    client.indices.put_mapping(
      index: 'trackers_v1',
      type:  'link',
      body: {
        link: {
          properties: {
            _rev:       { type: :string },

            created_at: {
              type: :date,
              format: :dateOptionalTime
            },

            message_id: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            recipient_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
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

            campaign_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            campaign_run_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            link_to: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            }
          }
        }
      }
    )
  end

  task :click_events do
    client.indices.create(
      index: 'events_v1',
      body: {
        settings: {
          index: {
            number_of_shards: 91,
            number_of_replicas: 1
          }
        }
      }
    ) unless client.indices.exists?(index: 'events_v1')

    client.indices.put_alias(
      index: 'events_v1',
      name:  'events'
    )

    client.indices.put_mapping(
      index: 'events_v1',
      type:  'click',
      body: {
        click: {
          properties: {
            _rev:       { type: :string },

            created_at: {
              type: :date,
              format: :dateOptionalTime
            },

            message_id: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            recipient_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
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

            campaign_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            campaign_run_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            link_to: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            user_agent: {
              type: :string
            },
            ip: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            }
          }
        }
      }
    )
  end

  task :open_events do
    client.indices.create(
      index: 'events_v1',
      body: {
        settings: {
          index: {
            number_of_shards: 91,
            number_of_replicas: 1
          }
        }
      }
    ) unless client.indices.exists?(index: 'events_v1')

    client.indices.put_alias(
      index: 'events_v1',
      name:  'events'
    )

    client.indices.put_mapping(
      index: 'events_v1',
      type:  'open',
      body: {
        open: {
          properties: {
            _rev:       { type: :string },

            created_at: {
              type: :date,
              format: :dateOptionalTime
            },

            message_id: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            recipient_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
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

            campaign_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            campaign_run_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            link_to: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            user_agent: {
              type: :string
            },
            ip: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            }
          }
        }
      }
    )
  end

    task :open_events do
    client.indices.create(
      index: 'unsubscriptions_v1',
      body: {
        settings: {
          index: {
            number_of_shards: 91,
            number_of_replicas: 1
          }
        }
      }
    ) unless client.indices.exists?(index: 'unsubscriptions_v1')

    client.indices.put_alias(
      index: 'unsubscriptions_v1',
      name:  'unsubscriptions'
    )

    client.indices.put_mapping(
      index: 'unsubscriptions_v1',
      type:  'unsubscriber',
      body: {
        unsubscriber: {
          properties: {
            _rev:       { type: :string },

            created_at: {
              type: :date,
              format: :dateOptionalTime
            },

            message_id: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            recipient_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
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

            campaign_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            campaign_run_uuid: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            email: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            },

            user_agent: {
              type: :string
            },
            ip: {
              type: :string,
              fields: {
                raw: { type: :string, index: :not_analyzed }
              }
            }
          }
        }
      }
    )
  end

  def client
    @client ||= Elasticsearch::Client.new(host: host, log: false)
  end

  def host
    URI(url).host
  end

  def url
    ENV['ELASTICSEARCH_URL'] || 'http://127.0.0.1:9200'
  end

end
