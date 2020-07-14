json.status @error
json.transfer do
  json.source_account_number @source&.account_number.to_s
  json.source_balance @transfer.initial_source_balance
  json.destination_account_number @destination&.account_number.to_s
  json.destination_balance @transfer.initial_destination_balance
  json.amount 0
end