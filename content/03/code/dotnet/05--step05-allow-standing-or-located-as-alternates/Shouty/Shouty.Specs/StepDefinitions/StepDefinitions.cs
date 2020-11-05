using System;
using TechTalk.SpecFlow;
using Xunit;

namespace Shouty.Specs.StepDefinitions
{
    [Binding]
    public class StepDefinitions
    {
        private Person lucy = new Person();
        private Person sean = new Person();
        private string messageFromSean;

        [Given("Lucy is located/standing {int} metre(s) from Sean")]
        public void GivenLucyIsLocatedMetresFromSean(int distance)
        {
            throw new NotImplementedException($"Lucy is {distance * 100} centimetres from Sean");
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
