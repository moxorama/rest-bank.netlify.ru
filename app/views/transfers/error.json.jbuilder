json.status @error
json.transfer do
  json.source_account_number @transfer&.source&.account_number.to_s
  json.source_balance @transfer&.source&.balance
  json.destination_account_number @transfer&.destination&.account_number.to_s
  json.destination_balance @transfer&.destination&.balance
  json.amount 0
end