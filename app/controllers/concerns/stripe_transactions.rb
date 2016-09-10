module StripeTransactions
	extend ActiveSupport::Concern

  	included do
  		preauth(@current_user, @stripe_token)
#  		self.include(ClassMethods)
# # #		scope :disabled, -> { where(disabled: true) }
  	end

	# def self.included(base)
	# 	base.extend(ClassMethods)
	# end
# 	module ClassMethods
	class_methods do
    #store the token, save the user as a customer, if needed
	    def preauth(current_user, stripe_token)
	        user = @current_user
#			Rails.log.warn "USER: #{user.given_name}"
				user.find(@current_user.id)
	            user.update_attributes = ({
	               :customer_token => "test1",
	               :customer_active_token => "test2"
	                })
	        if !user.customer_token.nil
	            #create new customer object
	            customer = Stripe::Customer.create(
	                :source => @stripe_token
	                )
	            #TO DO: error checking
	            #write customer to db
	            user.update_attributes = ({
	               :customer_token => customer,
	               :customer_active_token => @stripe_token
	                })
	        end
	    end
	end


end

