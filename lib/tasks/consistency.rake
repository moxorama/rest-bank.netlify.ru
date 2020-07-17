# Тест на корректность многопоточных транзакций
# Корректно работает если других операций, над указанными в тесте аккаунтами не производится
# bundle exec rake 'consistency:test[<исходный_номер_счета>,<целевой_номер_счета>]'

namespace :consistency do 
  task :test, [:source, :destination] do |t, args|
    HOST = 'http://194.87.110.156'
    CONCURRENCY  = 20
    NUM_REQUESTS = 2000
    
    source_account_number = args[:source]
    destination_account_number = args[:destination]

    if source_account_number.blank? || destination_account_number.blank? 
      abort("Usage:\nbundle exec rake 'consistency:test[<source_account>,<destination_account>]'\n")
      return
    end

    response = Typhoeus.get("#{HOST}/accounts/#{source_account_number}")
    source_info = JSON.parse(response.body)

    response = Typhoeus.get("#{HOST}/accounts/#{destination_account_number}")
    destination_info = JSON.parse(response.body)

    if (source_info.dig('status') != 'ok') 
      abort("Wrong source account #{source_account_number}")
    end

    if (destination_info.dig('status') != 'ok') 
      abort("Wrong destination account #{destination_account_number}")
      return
    end

    # Подготовка данных для тестирования целостности
    # Сохраняем значения балансов аккаунтов до начала теста, а также сумму балансов
    source_balance = source_info.dig('account', 'balance') 
    destination_balance = destination_info.dig('account','balance')
    total_balance = source_balance + destination_balance
  
    hydra = Typhoeus::Hydra.new(max_concurrency: 10)

    requests = []

    benchmark = Benchmark.measure ("#{NUM_REQUESTS} requests") {
      requests = NUM_REQUESTS.times.map do 
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

        amount = transfer['amount']
        source_balance_after_transfer = transfer['source_balance'] 
        destination_balance_after_transfer = transfer['destination_balance']
        
        # Проверка - сумма балансов на аккаунтах не должна меняться в любом случае
        accounts_total_status = ((source_balance_after_transfer + destination_balance_after_transfer) == total_balance)
        
        print "Accounts total check: #{accounts_total_status.to_s}\n"

        if (result['status'] == 'ok')
          # Проверка - балансы аккаунтов должны отличаться от ранее сохраненных ровно на сумму перевода
          source_balance_status = ((source_balance - amount) == source_balance_after_transfer)
          destination_balance_status = ((destination_balance + amount) == destination_balance_after_transfer)
          print "Transfer amount: #{amount}\n"
          print 'Source balance check: ' +  source_balance_status.to_s + " (before: #{source_balance}, after: #{source_balance_after_transfer})\n"  
          print 'Destination balance check: ' + destination_balance_status.to_s + " (before: #{destination_balance}, after: #{destination_balance_after_transfer})\n"  

          source_balance = source_balance_after_transfer
          destination_balance = destination_balance_after_transfer
        end
      end
    end

    print "---------------------------------------------------------------------\n"
    print "threads=#{CONCURRENCY}, #{NUM_REQUESTS} requests in #{"%.1f" % benchmark.real} seconds, #{"%.2f" % (NUM_REQUESTS/benchmark.real)} rps\n"



  end
end