json.accounts @accounts do |account|
  json.account_number account.account_number
  json.balance account.balance
end
