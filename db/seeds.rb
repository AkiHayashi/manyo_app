# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

first_user = User.create!(
  name: 'aki',
  email: 'a@ex.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

second_user = User.create!(
  name: 'neko',
  email: 'neko@ex.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

admin_user = User.create!(
  name: 'admin',
  email: 'admin@ex.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

50.times do |n|
  Task.create!(
    title: "タスクタイトル#{n + 1}",
    content: "内容#{n + 1}",
    deadline_on: Date.today.since(n),
    priority: [0, 1, 2].sample,
    status: [0, 1, 2].sample,
    user_id: [first_user.id, second_user.id].sample
  )
end

50.times do |n|
  Task.create!(
    title: "管理者タスクタイトル#{n + 1}",
    content: "管理者タスク内容#{n + 1}",
    deadline_on: Date.today.since(n),
    priority: [0, 1, 2].sample,
    status: [0, 1, 2].sample,
    user_id: admin_user.id
  )
end