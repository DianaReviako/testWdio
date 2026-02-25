Feature: test file artifact

    @artifacts
    Scenario Outline: Artifacts
        Given I am on the login page
        When I print the 'myTest.txt' file content
