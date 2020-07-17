# Тест на корректность многопоточных транзакций
# Корректно работает если других операций, над указанными в тесте аккаунтами не производится
# bundle exec rake 'consistency:test[<исходный_номер_счета>,<целевой_номер_счета>]'

namespace :consistency do 
  task :test, [:account_1, :account_2] do |t, args|
    HOST = 'http://194.87.110.156'
    CONCURRENCY  = 4
    NUM_REQUESTS = 10000
    
    account_1_number = args[:account_1]
    account_2_number = args[:account_2]

    if account_1_number.blank? || account_2_number.blank? 
      abort("Usage:\nbundle exec rake 'consistency:test[<account_1>,<account_2>]'\n")
      return
    end

    response = Typhoeus.get("#{HOST}/accounts/#{account_1_number}")
    account_1_info = JSON.parse(response.body)

    response = Typhoeus.get("#{HOST}/accounts/#{account_2_number}")
    account_2_info = JSON.parse(response.body)

    if (account_1_info.dig('status') != 'ok') 
      abort("Wrong source account #{account_1_number}")
      return
    end

    if (account_2_info.dig('status') != 'ok') 
      abort("Wrong destination account #{account_2_number}")
      return
    end

    # Подготовка данных для тестирования целостности
    # Сохраняем значения балансов аккаунтов до начала теста, а также сумму балансов
    total_balance = (
      account_1_info.dig('account', 'balance').to_i + 
      account_2_info.dig('account', 'balance').to_i
    )
  
    hydra = Typhoeus::Hydra.new(max_concurrency: 10)

    requests = []

    benchmark = Benchmark.measure ("#{NUM_REQUESTS} requests") {

      requests = NUM_REQUESTS.times.map do 
        source_account_number, destination_account_number = [account_1_number, account_2_number].shuffle

        request = Typhoeus::Request.new(HOST + '/transfers/',   
          method: :post,
          body: {
            source_account_number: source_account_number,
            destination_account_number: destination_account_number,
            amount: rand(1..10)
          }
        )
        hydra.queue(request)
        request 
      end

      hydra.run
    }

    requests.each do |r| 
      result = JSON.parse(r.response.body)
      print "---------------------------------------------------------------------------------\n"
      p result
      print "\n"
      if (['ok', 'concurrency', 'no_balance'].include?(result['status']))
        transfer = result.dig('transfer')

        source_balance = transfer['source_balance'] 
        destination_balance = transfer['destination_balance']
        
        # Проверка - сумма балансов на аккаунтах не должна меняться в любом случае
        accounts_total_status = ((source_balance + destination_balance) == total_balance)
        
        print "Accounts total check: #{accounts_total_status.to_s}\n"
      end
    end

    print "---------------------------------------------------------------------\n"
    print "threads=#{CONCURRENCY}, #{NUM_REQUESTS} requests in #{"%.1f" % benchmark.real} seconds, #{"%.2f" % (NUM_REQUESTS/benchmark.real)} rps\n"



  end
end