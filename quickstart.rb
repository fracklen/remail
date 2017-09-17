require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'rmail'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'pilot-remail'
CLIENT_SECRETS_PATH = 'client_secret.json'
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_SEND

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::RedisTokenStore.new
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

Gmail = Google::Apis::GmailV1

message = RMail::Message.new
message.header['To'] = ARGV[1]
message.header['From'] = ARGV[2]
message.header['Subject'] = "Testing API"
message.body = """Hey Buddy!

This is the first API based test mail.

Hope all is well!
- Me
"""

result = service.send_user_message('me',
                        upload_source: StringIO.new(message.to_s),
                        content_type: 'message/rfc822')

p result
