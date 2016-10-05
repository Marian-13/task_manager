User.all.each { |user| user.destroy }
Task.all.each { |task| task.destroy }

(1..5).each do |i|
  user = User.create(name: "User0#{i}", email: "user0#{i}@email.com", password: 'secret')

  (1..5).each do |j|
    task = Task.create(name: "#{user.name} Task#{j}",
                       description: "#{user.name} Task#{j} Description")
    user.tasks << task
  end
end
