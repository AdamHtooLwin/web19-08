Given("I am an admin user") do
  @admin = FactoryBot.create :admin
end

And("I am signed in") do
  visit('/')
  fill_in "login_email", with: @admin.email
  fill_in "login_password", with: @admin.password
  click_button 'Log In'
end

And("there are registered users") do
  @user = FactoryBot.create :user1
end

Given("I visit the user management page") do
  visit('/user_admin/index')
end

Then("I should see all the users currently registered") do
  expect(page).to have_content "#{@admin.email}"
  expect(page).to have_content "#{@admin.id}"
  expect(page).to have_content "#{@admin.first_name}"
  expect(page).to have_content "#{@admin.last_name}"

  expect(page).to have_content "#{@user.email}"
  expect(page).to have_content "#{@user.id}"
  expect(page).to have_content "#{@user.first_name}"
  expect(page).to have_content "#{@user.last_name}"
end

Given("there is an unbanned user") do
  expect(page).to have_link 'Ban'
end

When("I click ban user") do
  find_link('Ban', href: user_admin_ban_user_path(:user_id => @user.id)).click
end

Then("I should be redirected to the admin page") do
  expect(page).to have_current_path(user_admin_index_path)
end

Then("I should see the user banned") do
  expect(page).to have_link 'Unban', href: user_admin_ban_user_path(:user_id => @user.id)
end

