class StripeController < ApplicationController

  #This class makes changes to db variables of other controllers/modules 
  #we do this here instead of in the People class because we want to keep the code
  #separate for easier upgrades

  def callback
    #we receive the callback from Stripe when a seller registers
    params.each do |key,value|
      Rails.logger.warn "Param #{key}: #{value}"
    end
    flash[:notice] = "In callback"
    @var = params[:code]
    stripe_return_code = params[:code]
    #now use the code to contact stripe for user's key

    @data = client.get_token(stripe_return_code, {
      headers: {
        'grant_type' => "authorization_code"
      }
    } )

    Rails.logger.warn "DATA: #{@data}"

    save_token
  end

  def save_token
    #SELLER
    #save user token permanently so we can interact with stripe on their behalf
    stripe_user = current_user
    stripe_user.update_attributes({
        :provider => "stripe",
        :uid => @data["stripe_user_id"],
        :access_token => @data.token,
        :refresh_token => @data.refresh_token,
        :publishable_key => @data["stripe_publishable_key"]
      })
  end

  def preauth
    #BUYER
    #save buyer's token to db for stripe
    stripe_token = params[:token]
    tx_id = params[:id]

    #create stripe customer 
    customer = Stripe::Customer.create(
      :source => stripe_token
      )
    #TODO: error checking
    #write customer to db
    unless current_user.customer_token?
      current_user.update_attributes({
         :customer_token => customer,
         :customer_active_token => stripe_token
        })
    else 
      current_user.update_attributes({
         :customer_active_token => stripe_token
        })
    end
    redirect_to person_transaction_path(person_id: current_user.id, locale: current_user.locale, id: tx_id)

  end

  private

  def client
    @client ||= OAuth2::Client.new(
#    @client = OAuth2::Client.new(
    Rails.application.secrets.stripe_client_id,
    Rails.application.secrets.stripe_secret_key,
    {
      site: 'https://connect.stripe.com',
      authorize_url: '/oauth/authorize',
      token_url: '/oauth/token'
    }
    ).auth_code
  end

end
