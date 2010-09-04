Feature: Hello World
  In order to show basic features of a language
  As a Lisaac programmer
  I want to be able to compile a hello world

  Scenario: Debug
    Given I am in an empty directory
    #When I run pwd
     #And I print the last command output
     #And I run which lisaac
     #And I print the last command output
     #And I run echo $PATH
     #And I print the last command output

  Scenario: Compile Hello World
    Given I am in an empty directory
    And   a file "hello.li":
      """
      Section Header

        + name := HELLO;

      Section Public

        - main <-
          (
            "Hello World!".println;
          );
      """

    When I compile hello.li
    Then it should pass
    And  the output should contain
      """
      Depending pass:
      """
    And  the output should contain
      """
      Executing pass:
      """
    And  the output should not contain
      """
      WARNING
      """
    And  "hello" should exist

    When I run ./hello
    Then it should pass with
      """
      Hello World!

      """
    
