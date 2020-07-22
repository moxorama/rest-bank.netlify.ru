json.status 'ok'
json.transfer do
  json.uuid @transfer.transfer_uuid
  json.amount @transfer.amount
  json.source_account_number @transfer.source.account_number
  json.source_balance @transfer.source.balance
  json.destination_account_number @transfer.destination.account_number
  json.destination_balance @transfer.destination.balance
end
