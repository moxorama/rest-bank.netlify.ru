class TransfersController < ApplicationController
  def create
    source_account_number = params[:source_account_number]
    destination_account_number = params[:destination_account_number]

    # Запрашиваем аккаунты в один запрос к БД для атомарности, выбираем средствами ruby
    accounts = Account.where(account_number: [source_account_number, destination_account_number])
    
    @source = accounts.find { |a| a.account_number == source_account_number }
    @destination = accounts.find{ |a| a.account_number == destination_account_number }
    
    @amount = params[:amount] || 0

    @transfer = Transfer.create(
      source: @source,
      destination: @destination,
      amount: @amount
    )


    if !@transfer.valid? 
      @error = @transfer.errors.first[0]
      render action: 'error'
      return
    end


    result = @transfer.process_money

    if !@transfer.done?
      @error = @transfer.state
      render action: 'error'
      return
    end

    render action: 'transfer'
  end
end
