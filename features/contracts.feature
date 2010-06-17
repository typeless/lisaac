Feature: Execute contracts
  Contracts are code blocks introduced with the brackets [].
  Depending on where they are, they are checked at various moments:
    Require: before a slot definition
    Ensure: after a slot definition
    Prototype Invariant: at the end of file
    Variable Invariant: at the end of a local definition, right before the ;

  Require and Ensures are checked before and after a slot, when the slot is
  called using the dot notation (SUBJECT.SLOT). Implicit calls (SLOT) from the
  same object do not verify these contracts.

  Prototype Invariant are checked at the same time as Requires and Ensures.
  Invariants are checked twide, once before any Require, and once after any
  Ensure.

  Variable Invariants are not well defined yet

  TODO: check this specification (it doesn't work)

  Background:
    Given lisaac/bin is in the PATH
      And make.lip is installed
      And I am in an empty directory

  @fail
  Scenario: simple contracts
    Given a file "simple.li"
      """
      Section Header

        + name := SIMPLE;

      Section Private

        - proc1 <-
        [
          "PRE proc1".println;
        ]
        (
          "BODY proc1".println;
        )
        [
          "POST proc1".println;
        ];

      Section Public

        - main <-
        (
          proc1;
          "***".println;
          Self.proc1;
          "***".println;
          SIMPLE2.proc2;
        );

        [
          "Prototype Invariant SIMPLE".println;
        ]
      """

      And a file "simple2.li":
      """
      Section Header

        + name := SIMPLE2;

      Section Public

        - proc2 <-
        [
          "PRE proc2".println;
        ]
        (
          "BODY proc2".println;
          proc3
        )
        [
          "POST proc2".println;
        ];

        - proc3 <-
        [
          "PRE proc3".println;
        ]
        (
          "BODY proc3".println;
        )
        [
          "POST proc3".println;
        ];

        [
          "Prototype Invariant SIMPLE2".println;
        ]
      """

     When I run lisaac simple
     Then it should pass

     When I run ./simple
     Then it should pass with
      """
      BODY proc1
      ***
      Prototype Invariant SIMPLE
      PRE proc1
      BODY proc1
      POST proc1
      Prototype Invariant SIMPLE
      ***
      Prototype Invariant SIMPLE2
      PRE proc2
      BODY proc2
      BODY proc3
      POST proc2
      Prototype Invariant SIMPLE2

      """