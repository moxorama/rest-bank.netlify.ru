json.transfer do
  json.status 'error'
  json.description 'Some description'
  json.source_account @source&.account_number
  json.source_balance @source&.balance
  json.destination_account @destination&.account_number
  json.destination_balance @destination&.balance
end