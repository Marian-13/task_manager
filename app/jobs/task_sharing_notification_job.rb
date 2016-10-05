class TaskSharingNotificationJob < ApplicationJob
  queue_as :default

  # TODO correct message
  def perform(current_user, user, task, root_url)
    EM.run do
      client = Faye::Client.new("#{root_url}faye")

      publication = client.publish(
        "/#{user.id}",
        'text' => "#{current_user.name}(#{current_user.email}) shared a task '#{task.name}' \
                   with you. See it in the task list."
      )
    end
  end
end
