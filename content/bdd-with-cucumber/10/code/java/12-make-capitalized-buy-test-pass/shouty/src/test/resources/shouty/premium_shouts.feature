Feature: Premium account
  Questions:
  * What about the one where the same message is both over-long and contains the word "buy"
  * What happens if Sean runs out of credits?

  Background:
    Given the range is 100
    And Sean is located at 0
    And Lucy is located at 100

  Rule: Mention the word "buy" and you lose 5 credits.

    Scenario: Shout several messages containing the word “buy”
      Given Sean has bought 30 credits
      And Sean shouts 3 messages containing the word "buy"
      Then Lucy hears all Sean's messages
      And Sean should have 15 credits

  Rule: Over-long messages cost 2 credits

    Scenario: Sean shouts some over-long messages
      Given Sean has bought 30 credits
      When Sean shouts 2 over-long messages
      Then Lucy hears all Sean's messages
      And Sean should have 26 credits