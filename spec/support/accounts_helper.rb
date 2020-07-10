def source_account
  @account = Account.find_or_create_by(account_number: 'demo_source', balance: 0)
  @account.transactions.each { |t| t.destroy }

  Transaction.create(account: @account, amount: 100)
end

def destination_account
  @account = Account.find_or_create_by(account_number: 'demo_destination', balance: 0)
  @account.transactions.each { |t| t.destroy }

  Transaction.create(account: @account, amount: 100)
end

def clean_accounts
  Account.where(account_number: ['demo_source', 'demo_destination']).each { |a| a.destroy }
end
