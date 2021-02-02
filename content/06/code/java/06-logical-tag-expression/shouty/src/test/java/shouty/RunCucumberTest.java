package shouty;

import io.cucumber.junit.CucumberOptions;
import io.cucumber.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(tags="not @slow", plugin = {"pretty"}, strict = true)
public class RunCucumberTest {
}
