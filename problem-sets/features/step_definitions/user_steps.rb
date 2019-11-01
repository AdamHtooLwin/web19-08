Given("I am a user") do
  @user1 = FactoryBot.build :user1
end

And("I visit the home page") do
  visit '/'
end

Then("I should see the sign up form") do
  expect(page).to have_selector('form.sign_up')
end

When("I fill up my details in the form and click on “Register” button") do
  visit '/'
  fill_in 'sign_up_first_name', with: @user1.first_name
  fill_in 'sign_up_last_name', with: @user1.last_name
  fill_in 'sign_up_email', with: @user1.email
  fill_in 'sign_up_password', with: @user1.password
  click_button 'Sign up'
end

Then("I should be logged in") do
  expect(page).to have_content 'Welcome'
  expect(page).to have_content 'Sign out'
end


Given("I am an already registered user") do
  @user1 = FactoryBot.create :user1
end

And("I visit home page") do
  visit '/'
end

Then("I should see the login form") do
  expect(page).to have_selector('form.navbar-form')
end

When("I fill in my credentials in Login form and click on “Login” button") do
  fill_in 'login_email', with: @user1.email
  fill_in 'login_password', with: @user1.password
  click_button 'Log In'
end

Then("I should be redirected to my user page.") do
  expect(page).to have_content 'Welcome'
  expect(page).to have_content 'Sign out'
end
