Feature: Hear shout
  Scenario: Listener is within range
    Given Lucy is located 1 metres from Sean
    When Sean shouts "free bagels at Sean's"
    Then Lucy hears Sean's message
