Feature: Group Creation
  Users should be able to create and join groups

  Scenario: An existing user should be able to create a group.

    Given I am an already registered user
    And I am signed in
    And I visit the home page
    Then I should see a create group form
    When I submit the form
    Then I should be redirected to the group home page

  Scenario: An existing user should be able to add users to a group

    Given I am an already registered user
    And I am signed in
    And I am the owner of a group
    And I visit the home page
    Then I should see a link to the group
    When I click on the link
    Then I should be redirected to the group home page
    Then I should see a search bar to search for other users
    When I enter a username in the search bar
    Then I should see the results in a drop down
    When I click on a username
    Then I should see it added to the to-be-added list
    When I click on submit
    Then I should be redirected to the group home page
    Then I should see the user added