Feature: Shout

  Scenario: Listener within range
    Given Lucy is 15 metres from Sean
    When Sean shouts "free bagels at Sean's"
    Then Lucy should hear Sean's message

  Scenario: Listener hears a different mesage
    Given Lucy is 15 metres from Sean
    When Sean shouts "Free coffee!"
    Then Lucy should hear Sean's message
