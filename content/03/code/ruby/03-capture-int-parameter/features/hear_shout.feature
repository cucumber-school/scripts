Feature: Hear shout
  Scenario: Listener is out of range
    Given Lucy is located 1000 metres from Sean
    When Sean shouts "free bagels at Sean's"
    Then Lucy does not hear Sean's message
