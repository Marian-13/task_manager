class TaskDeletingNotificationJob < ApplicationJob
  queue_as :default

  def perform(current_user, task, root_url)
    EM.run do
      client = Faye::Client.new("#{root_url}faye")

      task.users.each do |user|
        publication = client.publish(
          "/#{user.id}",
          'text' => "#{current_user.name}(#{current_user.email}) deleted shared task '#{task.name}'."
        )
      end
    end
  end
end
