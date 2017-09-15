require "rails_helper"

RSpec.describe Users::GmailAccountsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/gmail_accounts").to route_to("users/gmail_accounts#index")
    end

    it "routes to #new" do
      expect(:get => "/users/gmail_accounts/new").to route_to("users/gmail_accounts#new")
    end

    it "routes to #show" do
      expect(:get => "/users/gmail_accounts/1").to route_to("users/gmail_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/users/gmail_accounts/1/edit").to route_to("users/gmail_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/users/gmail_accounts").to route_to("users/gmail_accounts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/users/gmail_accounts/1").to route_to("users/gmail_accounts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/users/gmail_accounts/1").to route_to("users/gmail_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/users/gmail_accounts/1").to route_to("users/gmail_accounts#destroy", :id => "1")
    end

  end
end
