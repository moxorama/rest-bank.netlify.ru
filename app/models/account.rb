class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :balance, presence: true, numericality: true
end
