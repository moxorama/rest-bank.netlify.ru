require 'swagger_helper'

describe 'Accounts API' do
  path '/accounts/' do
    get 'Список всех аккаунтов' do
      tags 'Accounts API'
      response '200', 'Список аккаунтов' do
        schema type: :object,
          properties: {
            accounts: { 
              type: 'array',
              items: { 
                type: 'object',
                properties: {
                  balance: { type: :integer },
                  account_number: { type: :string }
                }
              }
            },
            status: { type: :string }
          }
          run_test!
      end
    end

  end

  path '/accounts/{account_number}' do

    get 'Запрос информации по аккаунту' do
      tags 'Accounts API'
      produces 'application/json', 'application/xml'
      parameter name: :account_number, in: :path, type: :string, description: 'Номер счета'

      response '200', 'Информация об аккаунте' do
        schema type: :object,
          properties: {
            account: { 
              type: :object,
              parameters: {
                balance: { type: :integer },
                account_number: { type: :string }
              }
            },
            status: { type: :string }
          },
          required: [ 'status' ]
          let(:account_number) { Account.create(account_number: 'demo_source', balance: 100).account_number }     
          run_test!
      end
    end

  
  end
end