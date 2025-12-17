class LibraryController < ApplicationController
  before_action :require_authentication
  
  def index
    @user = Current.user
    @read_books = @user.read_books.includes(:user_books)
    @want_to_read_books = @user.want_to_read_books.includes(:user_books)
  end
end
