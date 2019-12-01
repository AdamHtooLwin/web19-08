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

When ("I click on the show link")do
  visit '/'
  find_link('Show', href: group_path(@group)).click
end

And( "I should see the remove button" ) do
  expect(page).to have_link("Remove", href: user_group_path(@group_user_group))
end

And("I want to remove from the  group")do
  click_link("Remove")
end

Then(" Then I should not see the group name ")do
  expect(page).not_to have_link("Remove")
end

Given("I am the owner of a group") do
  @group = FactoryBot.create :group1
  @usergroup = FactoryBot.create :usergroup1
end

Given("there is another user") do
  @secondary_user = FactoryBot.create :secondary_user
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

When("I enter an email in the search bar") do
  fill_in "search_user", with: @secondary_user.email
end

When("I click on submit") do
  post add_users_path, group_id: @group.id, search_user: @secondary_user.id
  click_button("Add")
end

Then("I should see the user added") do
  find_link('Show', href: group_path(@group)).click

  expect(page).to have_content @secondary_user.first_name
  expect(page).to have_content @secondary_user.email
end

Given("I am part of a group") do
  @group = FactoryBot.create :group1
  @usergroup = FactoryBot.create :usergroup1
end

Given("I visit the group home page") do
  visit '/'
  find_link('Show', href: group_path(@group)).click
end

Then("I should see a Comments section") do
  expect(page).to have_content "Comments"
end

Then("I should see a Comments form") do
  expect(page).to have_selector('form#new_message')
end

When("I fill in and submit the comment form") do
  fill_in "message_content", with: "Hello it's me!"
  click_button("Send")
end

Then("I should see my comment created") do
  expect(page).to have_content "Hello it's me!"
end

Given("there is another group user") do
  @group_user = FactoryBot.create :to_be_removed_user
  @group_user_group = FactoryBot.create :to_be_removed_user_group
end

When("I click on the remove button") do
  find_link("Remove", href: user_group_path(@group_user_group)).click
end

Then("I should not see the user's name") do
  expect(page).not_to have_content @group_user.first_name
end

Given("I am part of a group but not the admin") do
  @group_owner = FactoryBot.create :group_owner
  @group = FactoryBot.create :leave_group
  @group_owner_user_group = FactoryBot.create :group_owner_user_group
  @leave_group_user_group = FactoryBot.create :leave_group_user_group
end

Then("I should see the group's name") do
  visit '/'
  expect(page).to have_content @group.name
end

When("I should see the leave button") do
  find_link('Leave')
end

When("I click on the leave button") do
  find_link('Leave').click
end

Then("I should not see the group's name anymore") do
  expect(page).not_to have_content @group.name
end






