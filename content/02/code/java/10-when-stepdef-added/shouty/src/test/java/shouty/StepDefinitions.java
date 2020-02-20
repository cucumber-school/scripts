package shouty;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

public class StepDefinitions {
    Person lucy = new Person();
    Person sean = new Person();

    @Given("Lucy is {int} metres from Sean")
    public void lucy_is_metres_from_Sean(Integer distance) {

        lucy.setLocation(distance);
        sean.setLocation(0);
    }

    @When("Sean shouts {string}")
    public void sean_shouts(String message) {
        sean.shout(message):
     }

    @Then("Lucy should hear Sean's message")
    public void lucy_should_hear_Sean_s_message() {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }
}
