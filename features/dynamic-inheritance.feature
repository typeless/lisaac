Feature: Dynamic Inheritance

  Scenario:
    Given I am in an empty directory
    And   a file "hello.li":
      """
      Section Header

        + name := HELLO;

      Section Inherit

        + parent_root :ROOT := ROOT;

      Section Public

        - main <-
          (
            hello;
            parent_root := TOTO;
            hello;
          );
      """
    And   a file "root.li":
      """
      Section Header

        + name := ROOT;

      Section Public

        - hello <-
        (
          "Hello ROOT".println;
        );
      """
    And   a file "toto.li":
      """
      Section Header

        + name := TOTO;

      Section Inherit

        + parent_root :Expanded ROOT;

      Section Public

        - toto <-
        (
          "Hello back from TOTO".println;
        );

        - hello <-
        (
          "Hello TOTO".println;
          toto;
        );
      """

    When I compile hello.li
    Then it should pass

    When I run ./hello
    Then it should pass with
      """
      Hello ROOT
      Hello TOTO
      Hello back from TOTO

      """

