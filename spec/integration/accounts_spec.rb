require 'swagger_helper'

describe 'Accounts API' do



  path '/accounts/' do
    get 'Список всех аккаунтов' do
      tags 'Accounts API'
      produces 'application/json'
      response '200', 'Список аккаунтов' do
        schema type: :object,
          properties: {
            status: { type: :string },
            accounts: { 
              type: 'array',
              required: false,
              items: { 
                type: 'object',
                properties: {
                  balance: { type: :integer },
                  account_number: { type: :string }
                }
              }
            }
          }

        it {}
      end

      post 'Создание аккаунта' do
        tags 'Accounts API'
        parameter name: :account_number, in: :body, type: :string, description: 'Номер счета'
        response '200', 'Создание нового аккаунта' do
          schema type: :object,
            properties: {
              status: { type: :string },
              account: { 
                type: :object,
                properties: {
                  balance: { type: :integer },
                  account_number: { type: :string }
                }
              },
            }
          it {}
        end
      end
    end

  end

  path '/accounts/{account_number}' do

    get 'Запрос информации по аккаунту' do
      tags 'Accounts API'
      produces 'application/json'
      parameter name: :account_number, in: :path, type: :string, description: 'Номер счета'

      response '200', 'Информация об аккаунте' do
        schema type: :object,
          properties: {
            status: { type: :string },
            account: { 
              type: :object,
              properties: {
                balance: { type: :integer },
                account_number: { type: :string }
              }
            },
          },
          required: [ 'status' ]
        it {}
      end
    end

  
  end
end