using System;
using System.Collections.Generic;
using System.Linq;
using TechTalk.SpecFlow;
using Xunit;

namespace Shouty.Specs.StepDefinitions
{
    [Binding]
    public class StepDefinitions
    {
        private string messageFromSean;
        private Network network;
        private Dictionary<string, Person> people;

        [BeforeScenario]
        public void CreateNetwork()
        {
            people = new Dictionary<string, Person>();
        }

        [Given("the range is {int}")]
        public void GivenTheRangeIs(int range)
        {
            network = new Network(range);
        }

        [Given("a person named {word} is located at {int}")]
        public void GivenAPersonNamedIsLocatedAt(string name, int location)
        {
            people.Add(name, new Person(network, location));
        }

        [When("Sean shouts {string}")]
        public void WhenSeanShouts(string message)
        {
            people["Sean"].Shout(message);
            messageFromSean = message;
        }

        [Then("Lucy should hear Sean's message")]
        public void ThenLucyShouldHearSeansMessage()
        {
            Assert.Contains(messageFromSean, people["Lucy"].GetMessagesHeard());
        }

        [Then("Larry should not hear Sean's message")]
        public void ThenLarryShouldNotHearSeansMessage()
        {
            var heardByLarry = people["Larry"].GetMessagesHeard();
            Assert.DoesNotContain(messageFromSean, heardByLarry);
        }
    }
}
