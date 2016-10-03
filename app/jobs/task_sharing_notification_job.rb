class TaskSharingNotificationJob < ApplicationJob
  queue_as :default

  # TODO correct message
  def perform(user, task, root_url)
    EM.run do
      client = Faye::Client.new("#{root_url}faye")
      puts "#{root_url}faye"
      puts client
      
      publication = client.publish(
        "/#{user.id}",
        'text' => "#{user.name}(#{user.email}) shared a task '#{task.name}' \
                   with you. Reload page to see it."
      )

    #   publication.callback do
    #     puts 'Message received by server!'
    #   end
    #
    #   publication.errback do |error|
    #     puts 'There was a problem: ' + error.message
    #   end
    end
  end
end
