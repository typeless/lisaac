Feature: Bootstrapping
  In order to have a self hosting compiler
  As a Lisaac devlopper
  I want to bootstrap the compiler

  Background:
    Given lisaac/ is in the PATH
    And   make.lip is installed
    And   a file "tmp/path.h" constructed with:
      """
      printf '#define LISAAC_DIRECTORY "%s"\n' "`pwd`"
      """

  Scenario:
    Given I am in "tmp/"
    When  I run lisaac ../src/make.lip -compiler -optim -o lisaac1
    Then  it should pass
    And   "lisaac1.c" should exist
    And   "lisaac1" should exist
    When  I run ./lisaac1 ../src/make.lip -compiler -optim -o lisaac2
    Then  it should pass
    And   "lisaac2.c" should exist
    And   "lisaac2" should exist
    When  I run ./lisaac2 ../src/make.lip -compiler -optim -o lisaac3
    Then  it should pass
    And   "lisaac3.c" should exist
    And   "lisaac3" should exist
