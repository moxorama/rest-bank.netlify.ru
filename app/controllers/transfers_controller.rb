class TransfersController < ApplicationController
  def create
    @source = Account.find_by(account_number: params[:source_account_number])
    @destination = Account.find_by(account_number: params[:destination_account_number])
    @amount = params[:amount] || 0

    @transfer = Transfer.create(
      source: @source,
      destination: @destination,
      amount: @amount
    )

    if !@transfer.valid? 
      render action: 'error'
      return
    end

    @transfer.process_money

    if @transfer.failed?
      render action: 'error'
      return
    end

    render action: 'transfer'
  end
end
