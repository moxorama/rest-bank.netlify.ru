class TransfersController < ApplicationController
  def create
    @source = Account.find_by(account_number: params[:source_account_number])
    @destination = Account.find_by(account_number: params[:destination_account_number])
    @amount = params[:amount] || 0

    sleep 10
    
    p @source.balance
    p @destination.balance

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
