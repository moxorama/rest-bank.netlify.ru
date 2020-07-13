require 'swagger_helper'

describe 'Transfers API' do
  path '/transfers' do
    post 'Перевод средств между аккаунтами' do
      tags 'Transfer API'
      produces 'application/json'
      parameter name: :source_account_number, in: :body, type: :string, description: 'Номер счета отправителя'
      parameter name: :destination_account_number, in: :body, type: :string, description: 'Номер счета получателя'
      parameter name: :amount, in: :body, type: :integer, description: 'Сумма перевода'

      response '200', 'Перевод cредств между аккаунтами' do
        schema type: :object,
          properties: {
            status: { type: :string },
            transfer: { type: :object,
              properties: {
                source_account_number: { type: :string },
                source_balance: { type: :integer },
                destination_account_number: { type: :string },
                destination_balance: { type: :integer },
                amount: { type: :integer },
              }
            }
          }
          
        it {}
      end
    end
  end
end