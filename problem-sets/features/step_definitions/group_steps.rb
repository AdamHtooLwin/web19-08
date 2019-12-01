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

And("I am part of a group")do
  @group = FactoryBot.create :group1
  @user1group1 = FactoryBot.create :user1group1
end

When ("I click on the show link")do
  visit '/'
  find_link('Show', href: group_path(@group)).click
end

And( "I should see the remove button" ) do
  expect(page).to have_link("Remove")
end

And("I want to remove from the  group")do
  click_link("Remove")
end

Then(" Then I should not see the group name ")do
  expect(page).not_to have_link("Remove")
end











