Feature: Admin
  An admin user will want to manage and edit several aspects of the website

  Scenario: An admin user visiting the user management page should be able to see all the users.
    Given I am an admin user
    And I visit the user management page
    Then I should see all the users currently registered
