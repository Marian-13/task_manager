class TasksController < ApplicationController
  before_action :authorize
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
    @channel = "/#{current_user.id}"
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @user = current_user

    if @task.save
      @user.tasks << @task
      @user.save
      redirect_to @task # TODO add notice
    else
      render :new
    end
  end

  def update
    if !params[:task][:another_user_email].empty? &&
        params[:task][:another_user_email] =~ User::EMAIL_REGEX

      @user = User.find_by_email(params[:task][:another_user_email])

      if @user
        if @task.users.find_by_id(@user.id)
          flash[:notice] = "This task already shared with #{@user.name}(#{@user.email})"
          render :edit
        else
          @task.users << @user
          @task.update(task_params)
          NotifierJob.perform_now(@user, root_url) # TODO NotifierJob
          redirect_to tasks_path # TODO add notice
        end
      else
        flash[:notice] = "No user with specified email found."
        render :edit
      end
    else
      @task.update(task_params)
      redirect_to tasks_path # TODO add notice
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path # TODO add notice
  end

  private
    def task_params
      params.require(:task).permit(:name, :description)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
