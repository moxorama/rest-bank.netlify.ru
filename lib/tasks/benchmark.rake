
def get_random_transfer_params(accounts)
  total_accounts = accounts.length

  source_account = accounts[rand(0..total_accounts-1)]
  destination_account = accounts[rand(0..total_accounts-1)]
  amount = rand(10000..25000)  

  return {
    source_account_number: source_account['account_number'],
    destination_account_number: destination_account['account_number'],
    amount: amount
  }
end

namespace :benchmark do 
  task :single do
    HOST = 'http://194.87.110.156'
    

    response = Typhoeus.get(HOST + '/accounts/')

    json = JSON.parse(response.body)

    accounts = json['accounts']

    hydra = Typhoeus::Hydra.new()

    Benchmark.ips do |bench|
      bench.config(:time => 10, :warmup => 3)
   
  
      bench.report("transfers") do 
        response =  Typhoeus::Request.post(HOST + '/transfers/',
          body: get_random_transfer_params(accounts)
        )
      end
    end
  end


  task :concurrent do
    HOST = 'http://194.87.110.156'
    CONCURRENCY  = 10
    

    response = Typhoeus.get(HOST + '/accounts/')

    json = JSON.parse(response.body)

    accounts = json['accounts']

    NUM_REQUESTS = 5000

    hydra = Typhoeus::Hydra.new(max_concurrency: CONCURRENCY)

    result = Benchmark.measure ("#{NUM_REQUESTS} concurrent requests") {
      requests = NUM_REQUESTS.times.map do 
        request =  Typhoeus::Request.new(HOST + '/transfers/',   
          method: :post,
          body: get_random_transfer_params(accounts)
        )
        hydra.queue(request)
        request 
      end

      hydra.run
    }
    print "---------------------------------------------------------------------"
    print "threads=#{CONCURRENCY}, #{NUM_REQUESTS} requests in #{"%.1f" % result.real} seconds, #{"%.2f" % (NUM_REQUESTS/result.real)} rps"
  end
end
