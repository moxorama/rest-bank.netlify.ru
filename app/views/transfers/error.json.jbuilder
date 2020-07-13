json.status @error
json.transfer do
  json.source_account_number @source&.account_number.to_s
  json.source_balance @source&.balance.to_i
  json.destination_account_number @destination&.account_number.to_s
  json.destination_balance @destination&.balance.to_i
  json.amount 0
end