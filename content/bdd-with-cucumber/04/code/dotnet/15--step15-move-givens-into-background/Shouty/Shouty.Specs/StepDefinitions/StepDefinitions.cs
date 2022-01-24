using System;
using System.Collections.Generic;
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
            network = new Network();
            people = new Dictionary<string, Person>();
        }

        [Given("a person named {word}")]
        public void GivenAPersonNamed(string name)
        {
            people.Add(name, new Person(network));
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
    }
}
