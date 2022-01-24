using System;
using Xunit;

namespace Shouty.Tests
{
    public class NetworkTests
    {
        [Fact]
        public void Broadcasts_a_message_to_all_listeners()
        {
            var network = new Network();
            const string message = "Free bagels!";
            var lucy = new Person(network);
            network.Broadcast(message);
            Assert.Contains(message, lucy.GetMessagesHeard());
        }
    }
}
