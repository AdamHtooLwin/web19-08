Given("I want to register myself in the application") do
  # pending # Write code here that turns the phrase above into concrete actions
end

Given("I visit the home page") do
  visit '/'
end

Then("I should see the sign up form") do
  expect(page).to have_selector('form.sign_up')
end

When("I fill up my details in the form and click on “Register” button") do
  visit '/'
  fill_in 'sign_up_first_name', with: 'user1.first_name'
  fill_in 'sign_up_last_name', with: 'user1.last_name'
  fill_in 'sign_up_email', with: 'user1.email'
  fill_in 'sign_up_password', with: 'password'
  click_button 'Sign up'
end

Then("I should be directed back to home\/login page") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see the message “Successfully registered”") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I fill in my credentials in Login form and click on “Login” button") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should be redirected to my user page.") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I am an already registered user.") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see the login form") do
  pending # Write code here that turns the phrase above into concrete actions
end
