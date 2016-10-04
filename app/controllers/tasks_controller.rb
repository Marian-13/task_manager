class TasksController < ApplicationController
  before_action :authorize
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_channel, only: [:index, :show, :edit]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    @tasks = current_user.tasks
  end

  def show
    # TODO model Notification
    # TODO cover with RSpec
    # TODO refactor
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      current_user.tasks << @task

      # TODO DRY update
      flash[:notice_success] = []
      flash[:notice_failure] = []

      users = valid_users(
        @task,
        ->(callback_message) { flash[:notice_success] << callback_message },
        ->(callback_message) { flash[:notice_failure] << callback_message }
      )

      unless users.empty?
        users.each do |user|
          @task.users << user
          TaskSharingNotificationJob.perform_now(current_user, @task, root_url) # TODO NotifierJob
        end
      end

      # TODO remove @task.errors.any? in _model_errors
      if flash[:notice_failure].empty? && !@task.errors.any?
        flash[:notice_success] << "Task was successfully created."
        redirect_to @task
      else
        render :edit
      end
    else
      render :new
    end
  end

  def update
    @task.update(task_params)

    # TODO DRY create
    flash[:notice_success] = []
    flash[:notice_failure] = []

    users = valid_users(
      @task,
      ->(callback_message) { flash[:notice_success] << callback_message },
      ->(callback_message) { flash[:notice_failure] << callback_message }
    )

    unless users.empty?
      users.each do |user|
        @task.users << user
        TaskSharingNotificationJob.perform_now(user, @task, root_url) # TODO NotifierJob
      end
    end

    # TODO remove @task.errors.any? in _model_errors
    if flash[:notice_failure].empty? && !@task.errors.any?
      flash[:notice_success] << "Task was successfully edited."
      redirect_to task_path
    else
      render :edit
    end
  end

  def destroy
    TaskDeletingNotificationJob.perform_now(current_user, @task, root_url)

    @task.destroy

    flash[:notice_success] = ["Task was successfully deleted."]
    redirect_to tasks_path
  end

  private
    def task_params
      params.require(:task).permit(:name, :description)
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def set_channel
      @channel = "/#{current_user.id}"
    end

    def valid_emails_params(task, notice_failure_callback)
      emails = []

      if params[:emails]
        params[:emails].each do |key|
          email = params[:emails][key]

          if !email.empty?
            if email =~ User::EMAIL_REGEX
              emails << email
            else
              notice_failure_callback.call("Invalid format of email '#{email}'.")
            end
          end
        end
      end

      emails
    end

    def valid_users(task, notice_success_callback, notice_failure_callback)
      emails = valid_emails_params(@task, notice_failure_callback)

      users = []

      unless emails.empty?
        emails.each do |email|
          user = User.find_by_email(email)

          if user
            if task.users.find_by_id(user.id)
              notice_failure_callback.call(
                "This task was already shared with #{user.name} '#{user.email}'."
              )
            else
              notice_success_callback.call(
                "Task was successfully shared with #{user.name} '#{user.email}'."
              )
              users << user
            end
          else
            notice_failure_callback.call("No user with email '#{email}' found.")
          end
        end
      end

      users
    end

    def render_not_found
      render plain: "Task do not exist."   # TODO remove
    end
end
