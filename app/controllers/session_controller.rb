require 'httparty'

class SessionController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:sign_in]

  def sign_in
    render "session/sign-in"
  end

  def sign_up
    render "session/sign-up"
  end

  def reset_password
    render "session/reset-password"
  end
end
