Feature: Hear shout

  Shouty allows users to "hear" other users "shouts" as long as they are close enough to each other.

  Rule: Shouts should only be heard if listener is within range

    Scenario: Listener is within range
      Given the range is 100
      And Sean is located at 0
      And Lucy is located at 50
      When Sean shouts
      Then Lucy should hear Sean's message

    Scenario: Listener is out of range
      Given the range is 100
      And Sean is located at 0
      And Larry is located at 150
      When Sean shouts
      Then Larry should not hear a shout

  Rule: Listener should be able to hear multiple shouts

    Scenario: Two shouts
      Given the range is 100
      And Sean is located at 0
      And Lucy is located at 50
      When Sean shouts "Free bagels!"
      And Sean shouts "Free toast!"
      Then Lucy hears the following messages:
        | Free bagels! |
        | Free toast!  |

  Rule:  Maximum length of message is 180 characters

    Scenario: Message is too long
      Given the range is 100
      And Sean is located at 0
      And Lucy is located at 50
      When Sean shouts the following message
        """
        This is a really long message
        so long in fact that I am not going to
        be allowed to send it, at least if I keep
        typing like this until the length is over
        the limit of 180 characters.
        """
      Then Lucy should not hear a shout
