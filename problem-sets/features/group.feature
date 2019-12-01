Feature: Group Creation
  Users should be able to create and join groups

  Scenario: An existing user should be able to create a group.

    Given I am an already registered user
    And I am signed in as a regular user
    And I want to create a group
    And I visit the home page
    Then I should see link to the create group page
    When I click on the link
    Then I should see a form to submit a group
    When I submit the form
    And I should see my group created

  Scenario: An existing user should be able to add users to a group

    Given I am an already registered user
    And I am signed in as a regular user
    And I am the owner of a group
    And there is another user
    And I visit the home page
    Then I should see a link to the group
    When I click on the show group link
    Then I should be redirected to the group home page
    Then I should see a search bar to search for other users
    When I enter an email in the search bar
    When I click on submit
    Then I should be redirected to the group home page
    Then I should see the user added

  Scenario: A user should be able to leave comments in a group
    Given I am an already registered user
    And I am signed in as a regular user
    And I am part of a group
    And I visit the group home page
    Then I should see a Comments section
    And I should see a Comments form
    When I fill in and submit the comment form
    Then I should see my comment created

  Scenario: An existing user should be able to remove from the group.
    Given I am an already registered user
    And I am signed in as a regular user
    And I am part of a group
    When I click on the show link
    And I should see the remove button
    Then I should not see the group name

