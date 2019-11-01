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