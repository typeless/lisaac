Feature: Expanded Objects

  Expanded objects are used as values and not reference. Objects can be defined
  as Expanded when the prototype is declared, or when a variable is declared.

  It is possible to convert from Expanded to Reference objects and vice-versa:

    | Expanded  -> Expanded  | Copy value                      |
    | Expanded  -> Reference | Copy value (reference not null) |
    | Reference -> Expanded  | Copy value (reference not null) |
    | Reference -> Reference | Copy reference                  |

  Background:
    Given I am in an empty directory

  Scenario:
    Given a file "aa.li"
      """
      Section Header
        + name := AA;
      Section Insert
        - parent_object :Expanded OBJECT;
      Section Public
        + num :INTEGER := 0;
        - set_num i:INTEGER <- (num := i;);
      """
    Given a file "bb.li"
      """
      Section Header
        + name := Expanded BB;
      Section Public
        + num :INTEGER := 0;
        - set_num i:INTEGER <- (num := i;);
      """
    Given a file "main.li"
      """
      Section Header
        + name := MAIN;
      Section Public
        - main <-
        ( + ae  : Expanded AA;
          + ar1 : AA;
          + ar2 : AA;
          + b1  : BB;
          + b2  : BB;

          ae.set_num 1;
          ar1 := AA.clone;
          ar2 := AA.clone;
          ar1.set_num 2;
          ar2.set_num 3;
          b1.set_num 4;
          b2.set_num 5;

          ? { ar1.num = 2 };
          ? { ar2.num = 3 };
          ar1 := ar2;
          ? { ar1.num = 3 };
          ? { ar2.num = 3 };
          ar1.set_num 6;
          ? { ar1.num = 6 };
          ? { ar2.num = 6 };
          ar2.set_num 7;
          ? { ar1.num = 7 };
          ? { ar2.num = 7 };

          ? { ae.num = 1 };
          ar1 := ae;
          ? { ae.num = 1 };
          ? { ar1.num = 1 };
          ? { ar2.num = 1 };
          ae.set_num 8;
          ? { ae.num = 8 };
          ? { ar1.num = 1 };
          ? { ar2.num = 1 };

          ae := ar1;
          ? { ae.num = 1 };
          ? { ar1.num = 1 };
          ae.set_num 9;
          ? { ae.num = 9 };
          ? { ar1.num = 1 };

          ? { b1.num = 4 };
          ? { b2.num = 5 };
          b2 := b1;
          ? { b1.num = 4 };
          ? { b2.num = 4 };

          "OK".println;
        );
      """

     When I compile main.li
     Then it should pass

     When I run ./main
     Then it should pass with
      """
      OK

      """

