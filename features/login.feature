Feature: The Internet Guinea Pig Website

  Scenario Outline: As a user, I can log into the secure area as <username>
    Given I am on the login page
    When I login with <username> and <password>
    Then I should see a flash message saying <message>
    When I print to console value 'will print value from Jenkins'

    Examples:
      | username | password             | message                        |
      | tomsmith | SuperSecretPassword! | You logged into a secure area! |
      | foobar   | barfoo               | Your username is invalid!      |
