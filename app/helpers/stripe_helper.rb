module StripeHelper
  def is_myself?
    @user == current_user
  end
end
