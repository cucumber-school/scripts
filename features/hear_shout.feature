Feature: Hear shout
  Scenario: Listener is within range
    Given Lucy is standing 1 metre from Sean
    When Sean shouts "free bagels at Sean's"
    Then Lucy hears Sean's message
