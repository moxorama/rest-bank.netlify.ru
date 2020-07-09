def source_account
  @account = Account.find_or_create_by(account_number: 'demo_source')
  @account.transactions.each { |t| t.destroy }
end

def destination_account
  @account = Account.find_or_create_by(account_number: 'demo_destination')
  @account.transactions.each { |t| t.destroy }
end

def clean_accounts
  Account.where(account_number: ['source', 'destination']).delete_all
end
