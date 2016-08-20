class PaymentsController < ApplicationController

  include MathHelper

  before_filter :payment_can_be_conducted

  before_filter :only => [ :new ] do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_inbox")
  end

  def new
    @conversation = Transaction.find(params[:message_id])
    @payment = @conversation.payment  #This expects that each conversation already has a (pending) payment at this point

    @payment_gateway = @current_community.payment_gateway

    if @payment_gateway.can_receive_payments?(@payment.recipient)
      @payment_data = @payment_gateway.payment_data(@payment,
                :return_url => done_person_message_payment_url(:id => @payment.id),
                :cancel_url => new_person_message_payment_url,
                :locale => I18n.locale,
                :mock => @current_community.settings["mock_cf_payments"])
    else
      flash[:error] = t("layouts.notifications.cannot_receive_payment")
      redirect_to single_conversation_path(:conversation_type => :received, :id => @conversation.id) and return
    end
  end

  private

  def payment_can_be_conducted
    @conversation = Transaction.find(params[:message_id])
    redirect_to person_message_path(@current_user, @conversation) unless @conversation.requires_payment?(@current_community)
  end

end
