FactoryBot.define do
  factory :admin, class: User do
    first_name { "Joe" }
    last_name { "Joe" }
    email { "joe_joe@ait.asia" }
    password { "password" }
    is_admin { true }
  end

  factory :user1, class: User do
    first_name { "User" }
    last_name { "One" }
    email { "user_oneoneone@ait.asia" }
    password { "password" }
    is_admin { false }
  end
end