json.status 'ok'
json.transfer do
  json.amount @transfer.amount
  json.source_account_number @source.account_number
  json.source_balance @source.source_initial_balance
  json.destination_account_number @destination.account_number
  json.destination_balance @destination.destination_initial_balance
end
