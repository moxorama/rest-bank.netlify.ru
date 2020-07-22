json.status @error
json.transfer do
  json.uuid @transfer.transfer_uuid
  json.source_account_number @transfer&.source&.account_number.to_s
  json.source_balance @transfer&.initial_source_balance
  json.destination_account_number @transfer&.destination&.account_number.to_s
  json.destination_balance @transfer&.initial_destination_balance
  json.amount 0
end