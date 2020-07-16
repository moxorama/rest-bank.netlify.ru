class Transfer < ApplicationRecord
  belongs_to :source, class_name: 'Account', foreign_key: "source_id"
  belongs_to :destination, class_name: 'Account', foreign_key: "destination_id"

  validates :source, presence: true
  validates :destination, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :transactions, as: :reason
  include AASM

  aasm column: 'state' do
    state :request, initial: true
    state :done
    state :concurrency
    state :no_balance

    event :complete do
      transitions to: :done
    end

    event :concurrency do
      transitions to: :concurrency
    end

    event :no_balance do
      transitions to: :no_balance
    end
  end

  
  def process_money
    return unless valid?

    transaction do
      begin
        # Сортируем по ID для избежания deadlock
      
        [source, destination]
          .sort { |a,b| a.id <=> b.id }
          .each { |a| a.lock! }
  
        update_attributes(
          initial_source_balance: source.balance, 
          initial_destination_balance: destination.balance
        )

        if self.source.balance <= self.amount
          no_balance!
          return
        end 
    
        source.withdraw(self.amount)
        destination.deposit(self.amount)
        complete!
      rescue
        concurrency!
      end
    end
  end
end
