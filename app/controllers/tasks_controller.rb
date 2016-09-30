class TasksController < ApplicationController
  before_action :authorize
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
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
    @task.update(task_params)
    redirect_to tasks_path # TODO add notice
  end

  def destroy
    @task.destroy
    redirect_to tasks_path # TODO add notice
  end

  def share
    @task =
  end

  private
    def task_params
      params.require(:task).permit(:name, :description)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
