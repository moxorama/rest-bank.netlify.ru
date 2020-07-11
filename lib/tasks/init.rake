namespace :init do
  task :accounts => :environment do
    1000.times do 
      balance = rand(15000..45000)
      account_number = SecureRandom.uuid
      Account.create(account_number: account_number, balance: balance)
    end
  end
end