class UsersController < ApplicationController
  allow_unauthenticated_access(only: [:new, :create]) 
  
  def show
    @user = User.where({ :id => params.fetch(:id) }).at(0)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to user_path(@user), notice: "Successfully created a new account"
    else
      render :new, alert: "Unable to create a user"
    end
  end


  def edit
    @user = User.where({ :id => params.fetch(:id) }).at(0)  
  end

  def update
    @user = User.where({ :id => params.fetch(:id) }).at(0)
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

  def registration_params
    params.expect(user: [ :email_address, :name, :password, :password_confirmation ])
  end

  def profile_params
    params.expect(user: [ :name, :bio, :email_address, :password, :password_confirmation ])
  end

end
