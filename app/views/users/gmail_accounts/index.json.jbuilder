json.array!(@users_gmail_accounts) do |users_gmail_account|
  json.extract! users_gmail_account, :id, :customer_id, :username, :password, :sent, :burned
  json.url users_gmail_account_url(users_gmail_account, format: :json)
end
