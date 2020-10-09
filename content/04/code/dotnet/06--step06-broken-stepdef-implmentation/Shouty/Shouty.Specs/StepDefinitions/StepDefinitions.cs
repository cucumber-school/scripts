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

        [Given("Lucy is {int} metres from Sean")]
        public void GivenLucyIsMetresFromSean(int distance)
        {
            var network = new Network();
            sean = new Person(network);
            lucy = new Person(network);
            lucy.MoveTo(distance);
        }

        [Given("a person named Lucy")]
        public void GivenAPersonNamedLucy()
        {
            network = new Network();
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
