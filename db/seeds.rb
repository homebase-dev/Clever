# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['registered', 'member', 'banned', 'moderator', 'admin', 'free_member'].each do |role|
  Role.find_or_create_by({name: role})
end

['context_not_visible', 'context_always_visible', 'context_visible_at_beginning'].each do |test_workflow|
  TestWorkflow.find_or_create_by({name: test_workflow})
end