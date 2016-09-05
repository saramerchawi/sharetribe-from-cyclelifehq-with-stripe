class StripeController < ApplicationController

  def callback
    #we receive the callback from Stripe
    params.each do |key,value|
      Rails.logger.warn "Param #{key}: #{value}"
    end
    flash[:notice] = "In callback"
    @var = params[:code]
    stripe_return_code = params[:code]
    #now use the code to contact stripe for user's key

    @data = client.get_token( stripe_return_code, {
      headers: {
        'grant_type' => "authorization_code"
      }
    } )

    Rails.logger.warn "DATA: #{@data}"

    save_token
  end

  def save_token
    #save user token permanently so we can interact with stripe on their behalf
    stripe_user = current_user
    stripe_user.update_attributes({
        :provider => "stripe",
        :uid => @data["stripe_user_id"],
        :access_token => @data.token,
        :refresh_token => @data.refresh_token,
        :publishable_key => @data["stripe_publishable_key"]
      })
#    Rails.logger.warn "user: #{stripe_user}"
  end

  private

  def client
#    @client ||= OAuth2::Client.new(
    @client = OAuth2::Client.new(
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
