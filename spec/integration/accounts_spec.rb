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
          required: [ 'account_number', 'balance', 'status' ]

      end

    end

  
  end
end