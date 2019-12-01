Given("I am signed in as a regular user") do
  visit('/')
  fill_in "login_email", with: @user1.email
  fill_in "login_password", with: @user1.password
  click_button 'Log In'
end

Given("I want to create a group") do
  @group = FactoryBot.build :group1
end

Then("I should see link to the create group page") do
  expect(page).to have_link('Create a group')
end

Then("I should see a form to submit a group") do
  expect(page).to have_selector('form#group_form')
end

When("I submit the form") do
  fill_in "Name:", with: @group.name
  click_button("Create Group")
end

Then("I should see my group created") do
  expect(page).to have_content @group.name
end

When("I click on the link") do
  find_link('Create a group', href: new_group_path).click
end

Given("I am the owner of a group") do
  @group = FactoryBot.create :group1
  @usergroup = FactoryBot.create :usergroup1
end

Then("I should see a link to the group") do
  expect(page).to have_link('Show', href: group_path(@group))
end

When("I click on the show group link") do
  find_link('Show', href: group_path(@group)).click
end


Then("I should be redirected to the group home page") do
  expect(page).to have_content @group.name
end

Then("I should see a search bar to search for other users") do
  expect(page).to have_selector('form#add_users_in_a_group_form')
end

When("I enter a username in the search bar") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I click on submit") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see the user added") do
  pending # Write code here that turns the phrase above into concrete actions
end


