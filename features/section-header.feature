Feature: Section Header
  The Section Header of a prototype contains important metadata. The following
  slots are recognized:
    - name: name of the prototype (if the prototype is COP)
    + name: name of the prototype (non COP)
    - import: list of types to auto-import from
    - export: list of types to auto-export to
    - external: external code enclosed in `\`` to be included in the compiled
      code
    - default: expression, default value of the variables of this type
    - type: external code coding the native type
    - version: integer representing the version number (TODO: float at least)
    - lip: LIP code to be executed when the prototype comes alive
    - date, comment, author, bibliography, language, copyright, bug_report:
      metadata strings

  The `name` slot is mandatory and must be the first.

  TODO: test the effect of:
    - wrong name
    - Expanded, Strict
    - lip prototype
    - auto import/export
    - external code, external type
    - default value

  Background:
    Given lisaac/bin is in the PATH
      And make.lip is installed
      And I am in an empty directory

  Scenario: Missing Section Header
    Given a file "main.li"
      """
      Section Public

        - main <-
        (
          "Hello".println;
        );

      """

     When I run lisaac main
     Then it should fail
      And the output should contain
      """
      Section `Header' is needed
      """
  Scenario: Missing slot name
    Given a file "main.li"
      """
      Section Header

      Section Public

        - main <-
        (
          "Hello".println;
        );

      """

     When I run lisaac main
     Then it should fail
      And the output should contain
      """
      Slot `name' not found
      """

  Scenario: Header Slots
    Given a file "main.li"
      """
      Section Header

        + name := MAIN;
        - import := INTEGER, REAL;
        - export := INTEGER, REAL;
        - external := `/* nothing */`;
        - default := NULL;
        - type := `void*`;
        - version := 1_01; // FLOAT would be better than INTEGER !!!
        - lip <- ( "Hello LIP\n".print );
        - date := "20051987";
        - comment := "toto";
        - author := "Mildred";
        - bibliography := "This is a test";
        - language := "FR";
        - copyright := "2010";
        - bug_report := "nowhere";

      Section Public

        - main <-
        (
          "Hello LISAAC".println;
        );

      """

     When I run lisaac main
     Then it should pass
      And the output should contain
      """
      Hello LIP
      """
     When I run ./main
     Then it should pass with
      """
      Hello LISAAC

      """
