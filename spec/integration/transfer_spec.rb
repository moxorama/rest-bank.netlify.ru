require 'swagger_helper'

describe 'Transfers API' do
  path '/transfers' do
    post 'Перевод средств между аккаунтами' do
      tags 'Transfer API'
      produces 'application/json'
      description "
### Перевод средств между аккаунтами
        
Возможные значения status
  - ok - все ok
  - source - не найден аккаунт отправителя
  - destination - не найден аккаунт получателя
  - amount - недопустимое значение суммы перевода
  - no_balance - не хватает средств на аккаунте отправителя
  - concurrency - перевод не прошел - попытка нескольких одновременных переводов с этого аккаунта, следует повторить перевод позже

Вызов возвращает актуальные значения баланса на каждом из аккаунтов, вне зависимости от успешности перевода.
Если перевод не был сделан, то amount = 0
Если аккаунт не найден, то в ответе будет пустая строка в качестве его номера и 0 баланс
"
      parameter name: :source_account_number, in: :query, type: :string, description: 'Номер счета отправителя'
      parameter name: :destination_account_number, in: :query, type: :string, description: 'Номер счета получателя'
      parameter name: :amount, in: :query, type: :integer, description: 'Сумма перевода'

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