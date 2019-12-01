Feature: User
  In order to use the service, I want to have users sign up and sign in from the landing page

  Scenario: A web user visiting our application page should be able to register.

  Okay

    Given I am a user
    And I visit the home page
    Then I should see the sign up form
    When I fill up my details in the form and click on “Register” button
    Then I should be logged in

  Scenario: An existing user visiting our application page should be able to login.

  Okay

    Given I am an already registered user
    And I visit home page
    Then I should see the login form
    When I fill in my credentials in Login form and click on “Login” button
    Then I should be redirected to my user page.

  Scenario:  An existing user visiting our application page should be able to edit on the profile

    Okay
    Given I am an already registered user
    And I am signed in as a normal user
    And I visit the profile page
    Then I should see the edit account form
    When I fill in my credentials in Edit Account form and click on “SAVE” button
    Then I should be redirected to my user page.