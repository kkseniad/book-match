class UserBooksController < ApplicationController
  before_action :set_user_book, only: %i[ show edit update destroy ]

  # GET /user_books or /user_books.json
  def index
    @user_books = Current.user.user_books.includes(:book)
  end

  # GET /user_books/1 or /user_books/1.json
  def show
  end

  # GET /user_books/new
  def new
    @user_book = UserBook.new
  end

  # GET /user_books/1/edit
  def edit
  end

  # POST /user_books or /user_books/json
  def create
    # Book already exists in DB
    if params[:user_book][:book_id].present?
      @user_book = Current.user.user_books.find_or_initialize_by(book_id: params[:user_book][:book_id])
      @user_book.assign_attributes(user_book_params)

      respond_to do |format|
        if @user_book.save
          format.html { redirect_to @user_book.book, notice: "Book was successfully added to your library." }
          format.json { render :show, status: :created, location: @user_book }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user_book.errors, status: :unprocessable_entity }
        end
      end

      # New book from search results (Open Library API)
    elsif params[:book].present?
      book_data = {
        title: params[:book][:title],
        author: params[:book][:author],
        description: params[:book][:description],
        source: params[:book][:source],
        source_id: params[:book][:source_id],
        isbn: params[:book][:isbn],
        genre: params[:book][:genre]
      }

      result = BookPersistenceService.call(
        book_data,
        Current.user,
        user_book_params[:status]
      )

      @user_book = result[:user_book]

      respond_to do |format|
        format.html { redirect_to @user_book.book, notice: "Book was successfully added to your library." }
        format.json { render :show, status: :created, location: @user_book }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: books_path, alert: "Missing book information." }
        format.json { render json: { error: "Missing book information" }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_books/1 or /user_books/1.json
  def update
    respond_to do |format|
      if @user_book.update(user_book_params)
        format.html { redirect_to @user_book.book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @user_book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_books/1 or /user_books/1.json
  def destroy
    @user_book.destroy!

    respond_to do |format|
      format.html { redirect_to user_books_path, status: :see_other, notice: "Book was successfully removed from your library." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_book
    @user_book = Current.user.user_books.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def user_book_params
    params.require(:user_book).permit(:book_id, :status, :rating)
  end
end
