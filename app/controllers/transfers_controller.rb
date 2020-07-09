class TransfersController < ApplicationController
  def create
    @source = Account.find_by(account_number: params[:source])
    @destination = Account.find_by(account_number: params[:destination])
    @amount = params[:amount]

    @transfer = Transfer.create(
      source: @source,
      destination: @destination
      amount: @amount
    )

    if !@transfer.valid? 
      render json: 'error'
    end

    @transfer.process_money

    if @transfer.failed?
      render json: 'error'
    end

    render json: 'transfer'
  end
end
