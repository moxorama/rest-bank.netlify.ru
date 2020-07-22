def source_account
  @account = Account.find_by(account_number: 'demo_source')
  @account.destroy unless @account.blank?

  @account = Account.create(account_number: 'demo_source',  balance: 100)
end

def destination_account
  @account = Account.find_by(account_number: 'demo_destination')
  @account.destroy unless @account.blank?

  @account = Account.create(account_number: 'demo_destination', balance: 100)
end

def clean_accounts
  Account.where(account_number: ['demo_source', 'demo_destination']).each { |a| a.destroy }
end
