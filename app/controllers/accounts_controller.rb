class AccountsController < ApplicationController
  def create
    @account_number = params[:account_number]
    @amount = params[:amount]

    if Account.exists?(account_number: @account_number) 
      render action: 'error'
      return
    end

    @account = Account.create(account_number: @account_number, balance: 100)

    render action: 'show'
  end

  def show
    @account_number = params[:id]
    @account = Account.find_by(account_number: @account_number)

    if @account.blank?
      render action: 'error'
      return
    end
    
    render action: 'show'
  end
end
