using System;
using TechTalk.SpecFlow;
using Xunit;

namespace Shouty.Specs.StepDefinitions
{
    [Binding]
    public class StepDefinitions
    {
        private Person lucy;
        private Person sean;
        private string messageFromSean;
        private Network network;

        [BeforeScenario]
        public void CreateNetwork()
        {
            network = new Network();
        }

        [Given("a person named Lucy")]
        public void GivenAPersonNamedLucy()
        {
            lucy = new Person(network);
        }

        [Given("a person named Sean")]
        public void GivenAPersonNamedSean()
        {
            sean = new Person(network);
        }

        [When("Sean shouts {string}")]
        public void WhenSeanShouts(string message)
        {
            sean.Shout(message);
            messageFromSean = message;
        }

        [Then("Lucy should hear Sean's message")]
        public void ThenLucyShouldHearSeansMessage()
        {
            Assert.Contains(messageFromSean, lucy.GetMessagesHeard());
        }
    }
}
