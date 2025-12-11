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
    # TODO: edit user   
  end

  def update
    # TODO: update user
  end

  def destroy
    # TODO: delete
  end

  private

  def registration_params
    params.expect(user: [ :email_address, :name, :password, :password_confirmation ])
  end

end
