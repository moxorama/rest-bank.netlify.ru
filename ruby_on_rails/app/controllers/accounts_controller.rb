class AccountsController < ApplicationController
  def index
    @accounts = Account.all 

  end

  def create
    @account_number = params[:account_number]
    @balance = params[:balance]

    @account = Account.create(account_number: @account_number, balance: @balance)

    if !@account.valid?
      @error = @account.errors.first[0]
      render action: 'error'
      return
    end    

    render action: 'show'
  end


  def show
    @account_number = params[:id]
    @account = Account.find_by(account_number: @account_number)

    if @account.blank?
      @error = 'account_number'
      render action: 'error'
      return
    end
    
    render action: 'show'
  end
end
