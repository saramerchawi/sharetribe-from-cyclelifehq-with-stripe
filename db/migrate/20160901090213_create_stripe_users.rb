class CreateStripeUsers < ActiveRecord::Migration
  def change
    create_table :stripe_users do |t|
      t.string :person_id
      t.string :stripe_account_type
      t.string :publishable_key
      t.string :secret_key
      t.string :currenty
      t.string :stripe_account_status
    end
  end
end
