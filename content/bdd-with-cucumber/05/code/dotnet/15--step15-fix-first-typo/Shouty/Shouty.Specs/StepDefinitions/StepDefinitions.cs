using System;
using System.Collections.Generic;
using System.Linq;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using Xunit;

namespace Shouty.Specs.StepDefinitions
{
    [Binding]
    public class StepDefinitions
    {
        private const int DEFAULT_RANGE = 100;

        private string messageFromSean;
        private Network network = new Network(DEFAULT_RANGE);
        private Dictionary<string, Person> people;

        public class Whereabouts
        {
            public string Name { get; set; }
            public int Location { get; set; }
        }

        [StepArgumentTransformation]
        public Whereabouts[] ConvertWhereabouts(Table table)
        {
            return table.CreateSet<Whereabouts>().ToArray();
        }

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

        [Given("a person named {word}")]
        public void GivenAPersonNamed(string name)
        {
            people.Add(name, new Person(network, 0));
        }

        [Given("people are located at")]
        public void GivenPeopleAreLocatedAt(Whereabouts[] whereaboutsList)
        {
            foreach (var whereabouts in whereaboutsList)
            {
                people.Add(whereabouts.Name, new Person(network, whereabouts.Location));
            }
        }

        [When("Sean shouts")]
        public void WhenSeanShouts()
        {
            people["Sean"].Shout("Hello, world");
        }

        [When("Sean shouts {string}")]
        public void WhenSeanShoutsAMessage(string message)
        {
            people["Sean"].Shout(message);
            messageFromSean = message;
        }

        [Then("Lucy should hear Sean's message")]
        public void ThenLucyShouldHearSeansMessage()
        {
            Assert.Contains(messageFromSean, people["Lucy"].GetMessagesHeard());
        }

        [Then("Lucy should hear a shout")]
        public void ThenLucyShouldHearAShout()
        {
            Assert.Equal(1, people["Lucy"].GetMessagesHeard().Count);
        }

        [Then("Larry should not hear a shout")]
        public void ThenLarryShouldNotHearAShout()
        {
            Assert.Equal(0, people["Larry"].GetMessagesHeard().Count);
        }

        [Then("Lucy hears the following messages:")]
        public void ThenLucyHearsTheFollowingMessages(Table expectedMessagesTable)
        {
            var actualMessages = people["Lucy"].GetMessagesHeardEx();
            expectedMessagesTable.CompareToSet(actualMessages);
        }
    }
}
