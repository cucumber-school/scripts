using System;
using Moq;
using Xunit;

namespace Shouty.Tests
{
    public class PersonTests
    {
        private readonly Mock<Network> networkMock = new Mock<Network>();

        [Fact]
        public void It_subscribes_to_the_network()
        {
            var lucy = new Person(networkMock.Object);
            networkMock.Verify(n => n.Subscribe(lucy));
        }

        [Fact]
        public void Broadcasts_shouts_to_the_network()
        {
            const string message = "Free bagels!";
            var sean = new Person(networkMock.Object);
            sean.Shout(message);
            networkMock.Verify(n => n.Broadcast(message));
        }

        [Fact]
        public void Remembers_messages_heard()
        {
            const string message = "Free bagels!";
            var lucy = new Person(networkMock.Object);
            lucy.Hear(message);
            Assert.Contains(message, lucy.GetMessagesHeard());
        }
    }
}
