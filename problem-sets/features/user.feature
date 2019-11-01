Feature: User
  In order to use the service, I want to have users sign up and sign in from the landing page

  Scenario: A web user visiting our application page should be able to register.

  Okay

    Given I want to register myself in the application
    And I visit the home page
    Then I should see the sign up form
    When I fill up my details in the form and click on “Register” button
    Then I should be directed back to home/login page
    And I should see the message “Successfully registered”
    When I fill in my credentials in Login form and click on “Login” button
    Then I should be redirected to my user page.

  Scenario: An existing user visiting our application page should be able to login.

  Okay

    Given I am an already registered user.
    And I visit the home page
    Then I should see the login form
    When I fill in my credentials in Login form and click on “Login” button
    Then I should be redirected to my user page.