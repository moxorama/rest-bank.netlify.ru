require 'swagger_helper'

describe 'Accounts API' do



  path '/accounts/' do
    get 'Список всех аккаунтов' do
      tags 'Accounts API'
description "
### Возвращает список всех созданных аккаунтов
        
Возможные значения status
  - ok - все ok
    
      
accounts - cодержит список всех аккаутов
"
      produces 'application/json'
      response '200', '' do
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
    end

    post 'Создание аккаунта' do
      tags 'Accounts API'
      produces 'application/json'
      description "
### Создает новый аккаунт
  
Возможные значения status
  - ok - все ok
  - account_number - аккаунт с таким номером уже есть
  - balance - недопустимое значение баланса

account - информация по созданному аккаунту
"
      parameter name: :account_number, in: :query, type: :string, description: 'Номер счета'
      parameter name: :balance, in: :query, type: :number, description: 'Начальный баланс'

      response '200', '' do
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

  path '/accounts/{account_number}' do

    get 'Запрос информации по аккаунту' do
      tags 'Accounts API'
      produces 'application/json'
      description "
### Возвращает информацию об аккаунте
  
Возможные значения status
  - ok - все ok
  - account_number - аккаунт не найден
"
      parameter name: :account_number, in: :path, type: :string, description: 'Номер счета'
      response '200', '' do
        schema type: :object,
          properties: {
            status: { type: :string },
            account: { 
              type: :object,
              properties: {
                balance: { type: :integer, description: 'Актуальный баланс аккаунта' },
                account_number: { type: :string, description: 'Номер аккаунта' }
              }
            },
          },
          required: [ 'status' ]
        it {}
      end
    end
 
  end
end