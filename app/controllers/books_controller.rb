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
    if params[:query].present?
      # search internal database
      @internal_results = Book.where(
        "title ILIKE ? OR author ILIKE ?", 
        "%#{params[:query]}%", 
        "%#{params[:query]}%"
      )
      
      # If no internal results, search Open Library
      if @internal_results.empty?
        @external_results = BookSearchService.call(params[:query])
      end
    end
    
    respond_to do |format|
      format.html { render :search }
      format.json { render json: { internal: @search_results, external: @external_results } }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params.expect(:id))
  end
end
