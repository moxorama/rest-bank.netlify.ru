class TransfersController < ApplicationController
  def create
    source_account_number = params[:source_account_number]
    destination_account_number = params[:destination_account_number]
    @amount = params[:amount] || 0

    @transfer = Transfer.create(
      source_account_number: source_account_number,
      destination_account_number: destination_account_number,
      amount: @amount
    )
    
    @transfer.check_transfer!

    if !@transfer.correct?
      @error = @transfer.state
      render action: 'error'
      return
    end

    result = @transfer.process_money!

    if !@transfer.done?
      @error = @transfer.state
      render action: 'error'
      return
    end

    render action: 'transfer'
  end
end
