class ApplicationController < ActionController::Base
  include Authentication
  skip_forgery_protection

  helper_method :user_signed_in?

  private

  def user_signed_in?
    Current.session&.user.present?
  end
end
