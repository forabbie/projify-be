# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def create_task_priorities
  TaskPriority.destroy_all

  priorities = ['high', 'medium', 'low']

  priorities.each do |priority|
    TaskPriority.create!(name: priority)
  end

  puts "Created #{TaskPriority.count} task priorities"
end

def create_task_statuses
  TaskStatus.destroy_all

  statuses = ['not started', 'in progress', 'completed', 'stuck']

  statuses.each do |status|
    TaskStatus.create!(name: status)
  end

  puts "Created #{TaskStatus.count} task status"
end
create_task_priorities
create_task_statuses