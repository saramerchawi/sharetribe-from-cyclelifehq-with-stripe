class Stripe < ActiveRecord::Base
  validates :transaction_id, presence: true
  validates :sender_id, presence: true
  validates :recipient_id, presence: true
end