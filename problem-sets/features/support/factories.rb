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

  factory :secondary_user, class: User do
    id { 3 }
    first_name { "John" }
    last_name { "Doe" }
    email { "jdoe@ait.asia" }
    password { "password" }
    is_admin { false }
  end

  factory :to_be_removed_user, class: User do
    id { 4 }
    first_name { "Peter" }
    last_name { "Smith" }
    email { "psmith@ait.asia" }
    password { "password" }
    is_admin { false }
  end

  factory :leave_group, class: Group do
    id { 2 }
    name { "SV91" }
    user_id { 5 }
  end

  factory :group_owner, class: User do
    id { 5 }
    first_name { "Peter" }
    last_name { "Dean" }
    email { "pdean@ait.asia" }
    password { "password" }
    is_admin { false }
  end

  factory :group_owner_user_group, class: UserGroup do
    group_id { 2 }
    user_id { 5 }
  end

  factory :leave_group_user_group, class: UserGroup do
    group_id { 2 }
    user_id { 2 }
  end

  factory :to_be_removed_user_group, class: UserGroup do
    group_id { 1 }
    user_id { 4 }
  end

  factory :group1, class: Group do
    id { 1 }
    name { "SV90" }
    user_id { 2 }
  end

  factory :user1group1, class: UserGroup do
    user_id { 2 }
    group_id { 1 }
  end

  factory :usergroup1, class: UserGroup do
    id { 1 }
    group_id { 1 }
    user_id { 2 }
  end
end