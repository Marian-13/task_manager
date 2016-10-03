class TasksController < ApplicationController
  before_action :authorize
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  # accepts_nested_attributes_for :emails

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
    if params[:emails]
      if !params[:emails].empty?
        notice_success = []
        notice_failure = []

        params[:emails].each do |email|
          if !email.empty? && email =~ User::EMAIL_REGEX
            if @user = User.find_by_email(email)
              if @task.users.find_by_id(@user.id)
                notice_failure << "This task was already shared with #{@user.name}(#{@user.email})"
              else
                @task.users << @user
                @task.update(task_params)
                NotifierJob.perform_now(@user, root_url) # TODO NotifierJob
                notice_success << "Task has been successfully shared with #{@user.name}(#{@user.email})"
              end
            else
              notice_failure << "No user with email #{email} found."
            end
          end
        end

        flash[:notice_success] = notice_success

        if notice_failure.empty?
          redirect_to tasks_path
        else
          flash[:notice_failure] = notice_failure
          render :edit
        end
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
