class PagesController < ApplicationController
  allow_unauthenticated_access(only: :landing)

  def landing
    if authenticated?
      redirect_to user_library_path(Current)
    else
      render :landing
    end
  end
end
