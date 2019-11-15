FactoryBot.define do
  factory :admin, class: User do
    id { 1 }
    first_name { "Joe" }
    last_name { "Joe" }
    email { "joe_joe@ait.asia" }
    password { "password" }
    is_admin { true }
  end

  factory :user1, class: User do
    id { 2 }
    first_name { "User" }
    last_name { "One" }
    email { "user_oneoneone@ait.asia" }
    password { "password" }
    is_admin { false }
  end

  factory :group1, class: Group do
    id { 1 }
    name { "SV90" }
    user_id { 2 }
  end
end