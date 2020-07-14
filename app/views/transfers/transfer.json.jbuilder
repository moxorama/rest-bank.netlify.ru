json.status 'ok'
json.transfer do
  json.amount @transfer.amount
  json.source_account_number @source.account_number
  json.source_balance @source.balance
  json.destination_account_number @destination.initial_destination_balance
  json.destination_balance @destination.balance
end
