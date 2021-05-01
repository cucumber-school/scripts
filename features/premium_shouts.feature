Feature: Premium account

    Rules:
    * Mention the word "buy" and you lose 5 credits.
    * Over-long messages cost 2 credits

  Background:
    Given the range is 100
    And people are located at
      | name     | Sean | Lucy |
      | location | 0    | 100  |

  Scenario: Test premium account features
    Given Sean has bought 30 credits
    When Sean shouts a message containing the word "buy"
    And Sean shouts a message
    And Sean shouts a message
    And Sean shouts a long message
    When Sean shouts a message containing the word "buy"
    And Sean shouts an over-long message
    When Sean shouts a message containing the word "buy"
    And Sean shouts the following message
      """
      Here are some things you will love about Sean's:
      - the bagels
      - the coffee
      - the chickens
      Come and visit us today! We'd really love to see you.
      Pop round anytime, honestly it's fine.
      """
    And Sean shouts a message
    Then Lucy hears all Sean's messages
    And Sean should have 11 credits

  @todo
  Scenario: BUG #2789
    Given Sean has bought 30 credits
    When Sean shouts "buy, buy buy!"
    Then Sean should have 25 credits
