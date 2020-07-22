json.status 'ok'
json.account do
  json.account_number @account.account_number
  json.balance @account.balance
end
