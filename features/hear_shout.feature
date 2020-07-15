Feature: Hear shout

  Shouty allows users to "hear" other users "shouts" as long as they are close enough to each other.

  Rule: Shouts can be heard by other users

    Scenario: Listener hears a message
      Given a person named Sean
      And a person named Lucy
      When Sean shouts "free bagels at Sean's"
      Then Lucy should hear Sean's message

  Rule: Shouts should only be heard if listener is within range

    Scenario: Listener is within range
      Given the range is 100
      And people are located at
        | name     | Sean | Lucy |
        | location |  0   | 50   |
      When Sean shouts
      Then Lucy should hear a shout

    Scenario: Listener is out of range
      Given the range is 100
      And people are located at
        | name     | Sean | Larry |
        | location |  0   | 150   |
      When Sean shouts
      Then Larry should not hear a shout

  Rule: Listener should be able to hear multiple shouts

    Scenario: Two shouts
      Given a person named Sean
      And a person named Lucy
      When Sean shouts "Free bagels!"
      And Sean shouts "Free toast!"
      Then Lucy hears the following messages:
        | Free bagels! |
        | Free toast!  |

  Rule:  Maximum length of message is 180 characters

    Scenario: Message is too long
      Given a person named Sean
      And a person named Lucy
      When Sean shouts "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890x"
      Then Lucy should not hear a shout
