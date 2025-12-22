class UsersController < ApplicationController
  allow_unauthenticated_access(only: [ :new, :create ])
  before_action :set_user

  def show
    @user = User.where({ :id => params.fetch(:id) }).at(0)
    @read_books = @user.read_books.includes(:user_books)
    @readers = @user.similar_readers.count
    @want_to_read_books = @user.want_to_read_books.includes(:user_books)
    @matching_books = @user.matching_books(Current.user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to user_library_path(@user), notice: "Successfully created a new account"
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(profile_params)
      redirect_to(user_path(@user), notice: "Updated user profile")
    else
      render :edit, alert: "Something went wrong when saving"
    end
  end

  def destroy
    # TODO: delete
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def registration_params
    params.expect(user: [ :email_address, :name, :password, :password_confirmation ])
  end

  def profile_params
    params.expect(user: [ :name, :bio, :email_address, :password, :password_confirmation ])
  end
end
