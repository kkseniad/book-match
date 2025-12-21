class BooksController < ApplicationController
  before_action :set_book, only: %i[ show ]

  # GET /books or /books.json
  def index
    @recommended_books = Current.user.recommended_books
    @books = Book.where(featured: true)
  end

  # GET /books/1 or /books/1.json
  def show
    @user_book = Current.user.user_books.find_or_initialize_by(book_id: @book.id)
  end

  def search
    @results = BookSearchService.call(params[:query])
    
    respond_to do |format|
      format.html { render :search }
      format.json { render json: @results }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params.expect(:id))
  end
end
