class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  skip_forgery_protection

  def pundit_user
    Current.user
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  helper_method :user_signed_in?

  private

  def user_signed_in?
    Current.session&.user.present?
  end

  def user_not_authorized
    redirect_to root_path, alert: "You are not authorized to perform this action."
  end
end
