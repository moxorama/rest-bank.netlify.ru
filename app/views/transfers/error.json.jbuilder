json.status 'error'
json.description 'Some description'
json.transfer do
  json.source_account_number @source&.account_number
  json.source_balance @source&.balance
  json.destination_account_number @destination&.account_number
  json.destination_balance @destination&.balance
  json.amount 0
end