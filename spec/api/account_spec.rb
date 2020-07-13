require "rails_helper"
require "support/accounts_helper"

TEST_AMOUNT = 100


describe "Accounts API:" do
  before :all do
    clean_accounts
  end

  it "create account" do

    post '/accounts/', params: {
      account_number: 'demo_source',
      balance: TEST_AMOUNT
    }

    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    expect(json['status']).to eq 'ok'
    expect(json['account']['account_number']).to eq 'demo_source'
    expect(json['account']['balance']).to eq TEST_AMOUNT
    
    account = Account.find_by(account_number: 'demo_source')
    expect(account.balance).to eq TEST_AMOUNT
  end

  it "create account with negative amount" do

    post '/accounts/', params: {
      account_number: 'demo_destination',
      balance: -TEST_AMOUNT
    }

    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    expect(json['status']).to eq 'balance'
    
    account = Account.find_by(account_number: 'demo_source')
    expect(account.balance).to eq TEST_AMOUNT
  end

  it "show account balance" do
    get '/accounts/demo_source'

    expect(response).to have_http_status 200
    
    json = JSON.parse(response.body)

    expect(json['status']).to eq 'ok'
    expect(json['account']['account_number']).to eq 'demo_source'
    expect(json['account']['balance']).to eq TEST_AMOUNT
  end

  it "non existing account balance" do
    get '/accounts/wrong_account'

    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    expect(json['status']).to eq 'account_number'
  end
end