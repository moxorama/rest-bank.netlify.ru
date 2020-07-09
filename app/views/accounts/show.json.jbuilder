json.account do
  json.status 'ok'
  json.account_number @account.account_number
  json.balance @account.balance
end