$(document).ready ->
  return unless StripeCheckout?

  is_submitted = false

  payButton = $('.pay-button')
  form = payButton.closest('form')
  handler = null

  createHandler = ->
    handler = StripeCheckout.configure
      key: window.publishable_key
      description: window.description
      amount: window.payment_amount
      email: window.current_user_email
      image: window.image
      zipCode: true

      allowRememberMe: false
      closed: ->
        form.removeClass('processing') unless is_submitted
      token: (token) ->
        is_submitted = true
        form.find('input[name=token]').val(token.id)
        form.get(0).submit()

  createHandler()

  payButton.click (e) ->
    e.preventDefault()
    form.addClass('processing')

    handler.open
      name: 'CyclelifeHQ'

