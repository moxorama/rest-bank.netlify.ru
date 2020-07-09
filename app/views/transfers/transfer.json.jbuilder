json.transfer do
  json.status 'ok'
  json.amount @transfer.amount
  json.source_account @source.account_number
  json.source_balance @source.balance
  json.destination_account @destination.account_number
  json.destination_balance @destination.balance
end
