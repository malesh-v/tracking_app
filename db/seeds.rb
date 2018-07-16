# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#rake db:seed RAILS_ENV=test run for rspec !!!

#staff members
StaffMember.create!(login: 'admin_temp', password: '123123', password_confirmation: '123123', admin: true)
5.times do |i|
  StaffMember.create!(login: "staff_example_#{i}", password: '123123', password_confirmation: '123123')
end

#statuses default
Status.create(name: 'Waiting for Staff Response')
Status.create(name: 'Waiting for Customer')
Status.create(name: 'On Hold')
Status.create(name: 'Completed')

#departmants exapmle
Department.create(name: 'QA')
Department.create(name: 'Development')
Department.create(name: 'Marketing')

#client
Client.create(name: 'first name', email: 'email@mail.ru')

