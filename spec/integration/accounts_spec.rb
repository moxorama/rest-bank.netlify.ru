# spec/integration/blogs_spec.rb
require 'swagger_helper'

describe 'Accounts API' do

  path '/accounts/{account_number}' do

    get 'Show an account' do
      tags 'Accounts'
      produces 'application/json', 'application/xml'
      parameter name: :account_number, in: :path, type: :string

      response '200', 'Account info' do
        schema type: :object,
          properties: {
            account_number: { type: :string },
            balance: { type: :integer },
            status: { type: :string }
          },
          required: [ 'status' ]
          let(:account_number) { Account.create(account_number: 'demo_soruce', balance: 100).account_number }     
          run_test!
      end

      response '200', 'Account info' do
        schema type: :object,
          properties: {
            description: { type: :string },
            status: { type: :string }
          },
          required: [ 'status' ]
          let(:account_number) { 'wrong_account' }     
          run_test!
      end

    end

  
  end
end