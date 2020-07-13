require "rails_helper"
require "support/accounts_helper"

TRANSFER_AMOUNT = 50
INITIAL_AMOUNT = 100

describe "Transfer API:" do
  before :all do
    clean_accounts
    source_account
    destination_account
  end

  it 'successful transfer' do
    post '/transfers', params: {
      source_account_number: 'demo_source',
      destination_account_number: 'demo_destination',
      amount: TRANSFER_AMOUNT
    }
    
    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    
    expect(json['transfer']['source_account_number']).to eq 'demo_source'
    expect(json['transfer']['source_balance']).to eq (INITIAL_AMOUNT - TRANSFER_AMOUNT)
    expect(json['transfer']['destination_account_number']).to eq 'demo_destination'
    expect(json['transfer']['destination_balance']).to eq (INITIAL_AMOUNT + TRANSFER_AMOUNT)
  end

  it 'no funds' do
    post '/transfers', params: {
      source_account_number: 'demo_source',
      destination_account_number: 'demo_destination',
      amount: TRANSFER_AMOUNT*10
    }

    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    
    expect(json['status']).to eq 'no_balance'
    expect(json['transfer']['source_account_number']).to eq 'demo_source'
    expect(json['transfer']['source_balance']).to eq (INITIAL_AMOUNT - TRANSFER_AMOUNT)
    expect(json['transfer']['destination_account_number']).to eq 'demo_destination'
    expect(json['transfer']['destination_balance']).to eq (INITIAL_AMOUNT + TRANSFER_AMOUNT)
  end

  it 'transfer with missing source' do
    post '/transfers', params: {
      source_account_number: 'wrong_source',
      destination_account_number: 'demo_destination',
      amount: TRANSFER_AMOUNT
    }

    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    
    expect(json['status']).to eq 'source'
    expect(json['transfer']['destination_account_number']).to eq 'demo_destination'
    expect(json['transfer']['destination_balance']).to eq (INITIAL_AMOUNT + TRANSFER_AMOUNT)
  end

  it 'transfer with missing destination' do
    post '/transfers', params: {
      source_account_number: 'demo_source',
      destination_account_number: 'wrong_destination',
      amount: TRANSFER_AMOUNT
    }

    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    
    expect(json['status']).to eq 'destination'
    expect(json['transfer']['source_account_number']).to eq 'demo_source'
    expect(json['transfer']['source_balance']).to eq (INITIAL_AMOUNT - TRANSFER_AMOUNT)
  end

  it 'negative amount transfer' do
    post '/transfers', params: {
      source_account_number: 'demo_source',
      destination_account_number: 'demo_destination',
      amount: -200
    }

    expect(response).to have_http_status 200

    json = JSON.parse(response.body)

    expect(json['status']).to eq 'amount'
    expect(json['transfer']['source_account_number']).to eq 'demo_source'
    expect(json['transfer']['source_balance']).to eq (INITIAL_AMOUNT - TRANSFER_AMOUNT)
    expect(json['transfer']['destination_account_number']).to eq 'demo_destination'
    expect(json['transfer']['destination_balance']).to eq (INITIAL_AMOUNT + TRANSFER_AMOUNT)
  end
end
