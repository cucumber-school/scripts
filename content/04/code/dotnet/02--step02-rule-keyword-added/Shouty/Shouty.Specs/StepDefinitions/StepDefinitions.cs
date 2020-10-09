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

        [Given("Lucy is {int} metres from Sean")]
        public void GivenLucyIsMetresFromSean(int distance)
        {
            var network = new Network();
            sean = new Person(network);
            lucy = new Person(network);
            lucy.MoveTo(distance);
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
