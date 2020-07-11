require 'rest-client'

HOST = 'http://rest-bank.netlify.ru'

namespace :benchmark do 
  task :transfers do
    response = RestClient.get(HOST + '/accounts', headers={})

    json = JSON.parse(response.body)
    total_accounts = json['accounts'].length

    Benchmark.ips do |bench|
      bench.config(:time => 5, :warmup => 1)

      bench.report("transfers") do
        source_account = json['accounts'][rand(0..total_accounts-1)]
        destination_account = json['accounts'][rand(0..total_accounts-1)]
        amount = rand(10000..25000)  

        response = RestClient.post(HOST + '/transfers/', {
          source_account: source_account['account_mumber'],
          destination_account: destination_account['account_number'],
          amount: amount
        })
      end
    end
  end
end
