class StripeStandalone < Struct.new( :target_user )

  COUNTRIES = [
    { name: 'Australia', code: 'AU' },
    { name: 'Canada', code: 'CA' },
    { name: 'Denmark', code: 'DK' },
    { name: 'Finland', code: 'FI' },
    { name: 'France', code: 'FR' },
    { name: 'Ireland', code: 'IE' }
    { name: 'Norway', code: 'NO' },
    { name: 'Sweden', code: 'SE' },
    { name: 'United Kingdom', code: 'GB' },
    { name: 'United States', code: 'US' },
  ]

    def create_stripe_account! (country)
    	if !country.in?(COUNTRIES.map { |co| co[:code] })
    		return

        begin
        	@stripe_account = Stripe::Account.create(
        		email: user.email,
        		country: country
        	)
        #add error checking here
    end

    if @stripe_account
      user.update_attributes(
        currency: @account.default_currency,
        stripe_account_type: 'standalone',
        stripe_user_id: @account.id,
        secret_key: @account.keys.secret,
        publishable_key: @account.keys.publishable,
        stripe_account_status: account_status
      )