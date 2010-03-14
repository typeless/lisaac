Feature: Cyclic inheritance
  In order to avoid endless loops at compile time
  I want to detect cyclin inheritance and tell the programmer this is an error

  Background:
    Given Lisaac is available
    And   I am in an empty directory

  Scenario: Basic
    Given a file "cyclic.li":
      """
      Section Header

        + name := CYCLIC;

      Section Inherit

        - parent_object :MAIN <- SELF;

      Section Private

        - tell_me <-
        (
          "I tell you".println;
        );

      """
    And a file "main.li":
      """
      Section Header

        + name := MAIN;

      Section Inherit

        + parent_cyclic :Expanded CYCLIC;

      Section Public

        - main <-
        (
          tell_me;
        );
      """
    When I run lisaac main
    Then it should fail
    And the output should contain
      """
      Cyclic inheritance
      """