User.create!(name:  "Admin",
             email: "tubaduc@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             is_admin: true,
             phone: "0909897061",
             address: "A1606, Tan Huong, Tan Phu, HCM")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.vn"
  password = "123456"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               phone: "0909897061",
               address: "A1606, Tan Huong, Tan Phu, HCM")
end
