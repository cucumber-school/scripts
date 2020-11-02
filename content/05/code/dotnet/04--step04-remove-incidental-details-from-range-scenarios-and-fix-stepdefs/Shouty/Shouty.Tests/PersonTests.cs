using System;
using Moq;
using Xunit;

namespace Shouty.Tests
{
    public class PersonTests
    {
        public class TestableNetwork : Network
        {
            // to be able to create a Mock of a Network, we need a default constructor
            public TestableNetwork() : base(100) { }
        }

        private readonly Mock<TestableNetwork> networkMock = new Mock<TestableNetwork>();

        [Fact]
        public void It_subscribes_to_the_network()
        {
            var lucy = new Person(networkMock.Object, 100);
            networkMock.Verify(n => n.Subscribe(lucy));
        }

        [Fact]
        public void It_has_a_location()
        {
            Person person = new Person(networkMock.Object, 100);
            Assert.Equal(100, person.Location);
        }

        [Fact]
        public void Broadcasts_shouts_to_the_network()
        {
            const string message = "Free bagels!";
            var sean = new Person(networkMock.Object, 0);
            sean.Shout(message);
            networkMock.Verify(n => n.Broadcast(message, 0));
        }

        [Fact]
        public void Remembers_messages_heard()
        {
            const string message = "Free bagels!";
            var lucy = new Person(networkMock.Object, 100);
            lucy.Hear(message);
            Assert.Contains(message, lucy.GetMessagesHeard());
        }
    }
}
