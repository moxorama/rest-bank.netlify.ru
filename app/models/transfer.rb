class Transfer < ApplicationRecord
  belongs_to :source, class_name: 'Account', foreign_key: "source_id", optional: true
  belongs_to :destination, class_name: 'Account', foreign_key: "destination_id", optional: true

  include AASM

  aasm column: 'state' do
    state :request, initial: true
    state :correct
    state :done
    state :negative_amount
    state :no_balance
    state :source
    state :destination

    event :approve! do
      transitions to: :correct
    end

    event :complete do
      transitions to: :done
    end

    event :negative_amount! do
      transitions to: :negative_amount
    end

    event :no_balance do
      transitions to: :no_balance
    end

    event :no_source do 
      transitions to: :source
    end

    event :no_destination do
      transitions to: :destination
    end
  end

  
  def process_money!   
    return unless correct?
    
    transaction do
      begin  
        source.lock!
        destination.lock!

        save_initial_balance

        source.withdraw(self.amount)
        destination.deposit(self.amount)
        complete!
      rescue
        no_balance!
      end
    end
  end


  def check_transfer!
    accounts = Account
      .where(account_number: [source_account_number, destination_account_number])
      .order(:id)
    
    source = accounts.find { |a| (a.account_number == source_account_number) }
    destination = accounts.find { |a| (a.account_number == destination_account_number) }

    # Сохраняем значения балансов на случай если откатываем по причине неконсистентсности
    update_attributes(
      source: source, 
      initial_source_balance: source&.balance.to_i,
      destination: destination,
      initial_destination_balance: destination&.balance.to_i
    )

    if (source.blank?)
      no_source!
      return
    end

    if (destination.blank?)
      no_destination!
      return
    end

    if (amount < 0)
      negative_amount!
      return
    end

    approve!
  end

  def save_initial_balance
    update_attributes(initial_source_balance: source.balance, initial_destination_balance: destination.balance)
  end
end
