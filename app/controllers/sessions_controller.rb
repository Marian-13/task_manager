class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to tasks_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to tasks_path
    else
      flash[:notice] = 'Incorrect email or password. Please try again.'
      render 'sessions/new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
