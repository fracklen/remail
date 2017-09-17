require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/redis_token_store'
require 'rmail'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'pilot-remail'
CLIENT_SECRETS_PATH = 'client_secret.json'
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_SEND

class GmailService
  attr_reader :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def authorizer
    return @authorizer if @authorizer
    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::RedisTokenStore.new
    @authorizer = Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, token_store)
    return @authorizer
  end

  def authorization_url
    credentials = authorizer.get_credentials(user_id)
    return nil if credentials.present?
    return authorizer.get_authorization_url(
        base_url: OOB_URI)
  end

  def authorize(code)
    credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
  end

  def sendmail(options)
    credentials = authorizer.get_credentials(user_id)

    service.client_options.application_name = APPLICATION_NAME
    service.authorization = credentials

    message = RMail::Message.new
    message.header['To'] = options[:to]
    message.header['From'] = user_id
    message.header['Subject'] = options[:subject]
    message.body = options[:body]

    result = service.send_user_message('me',
                            upload_source: StringIO.new(message.to_s),
                            content_type: 'message/rfc822')
    return result
  end

  def service
    @service ||= Google::Apis::GmailV1::GmailService.new
  end
end
