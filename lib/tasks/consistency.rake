
def get_random_transfer_params(accounts)  

  amount = rand(10..20)

  return {
    source_account_number: '1',
    destination_account_number: '2',
    amount: amount
  }
end

namespace :consistency do 
  task :test do
    response = Typhoeus.get(HOST + '/accounts/')

    json = JSON.parse(response.body)

    accounts = json['accounts']

    NUM_REQUESTS = 100

    hydra = Typhoeus::Hydra.new(max_concurrency: 10)

    requests = NUM_REQUESTS.times.map do 
      request =  Typhoeus::Request.new(HOST + '/transfers/',   
        method: :post,
        body: get_random_transfer_params(accounts)
      )
      hydra.queue(request)
      request 
    end

    hydra.run

    requests.each do |r| 
      p JSON.parse(r.body)
    end
  end
end