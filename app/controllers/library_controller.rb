class LibraryController < ApplicationController
  def index
    @user = Current.user
    @read_books = @user.read_books
    @want_to_read_books = @user.want_to_read_books
  end
end
