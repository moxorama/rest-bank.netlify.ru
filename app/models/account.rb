class Account < ApplicationRecord
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :account_number, uniqueness: true

  DEFAULT_UPDATE_OPTIONS = {
    lock: true
  }
  # Блокировка
  def withdraw(amount, options = {})
    opts = DEFAULT_UPDATE_OPTIONS.merge(options)

    unless opts[:lock]
      update!(balance: balance - amount)
      return
    end

    with_lock do 
      update!(balance: balance - amount)
    end
  end

  def deposit(amount, options = {})
    opts = DEFAULT_UPDATE_OPTIONS.merge(options)

    unless opts[:lock]
      update!(balance: balance + amount)
      return
    end

    with_lock do 
      update!(balance: balance + amount)
    end
  end
end
