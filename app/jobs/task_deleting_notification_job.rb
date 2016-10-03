class TaskDeletingNotificationJob < ApplicationJob
  queue_as :default

  def perform(current_user, task, root_url)
    EM.run do
      client = Faye::Client.new("#{root_url}faye")
      puts "#{root_url}faye"
      puts client

      task.users.each do |user|
        publication = client.publish(
          "/#{user.id}",
          'text' => "#{current_user.name}(#{current_user.email}) deleted shared task '#{task.name}'."
        )

        publication.callback do
          puts 'Message received by server!'
        end

        publication.errback do |error|
          puts 'There was a problem: ' + error.message
        end
      end
    end
  end
end
