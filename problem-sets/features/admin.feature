Feature: Admin
  An admin user will want to manage and edit several aspects of the website

  Scenario: An admin user visiting the user management page should be able to see all the users.
    Given I am an admin user
    And I am signed in
    And there are registered users
    And I visit the user management page
    Then I should see all the users currently registered

  Scenario: An admin user should be able to ban users
    Given I am an admin user
    And I am signed in
    And there are registered users
    And I visit the user management page
    Given there is an unbanned user
    When I click ban user
    Then I should be redirected to the admin page
    And I should see the user banned
