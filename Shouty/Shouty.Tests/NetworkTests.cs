using System;
using Xunit;

namespace Shouty.Tests
{
    public class NetworkTests
    {
        private const int Range = 100;
        private const string Message = "Free bagels!";
        private readonly Network network = new Network(Range);

        [Fact]
        public void Broadcasts_a_message_to_a_listener_within_range()
        {
            int seanLocation = 0;
            var lucy = new Person(network, 0);
            network.Broadcast(Message, seanLocation);

            Assert.Contains(Message, lucy.GetMessagesHeard());
        }

        [Fact]
        public void Does_not_broadcast_a_message_to_a_listener_out_of_range()
        {
            int seanLocation = 0;
            Person laura = new Person(network, 101);
            network.Broadcast(Message, seanLocation);

            Assert.DoesNotContain(Message, laura.GetMessagesHeard());
        }

        [Fact]
        public void Does_not_broadcast_a_message_to_a_listener_out_of_range_negative_distance()
        {
            int sallyLocation = 101;
            Person lionel = new Person(network, 0);
            network.Broadcast(Message, sallyLocation);

            Assert.DoesNotContain(Message, lionel.GetMessagesHeard());
        }
        
        [Fact]
        public void Does_not_broadcast_a_message_over_180_characters_even_if_listener_is_in_range()
        {
            int seanLocation = 0;

            var longMessage = new string('x', 181);

            Person laura = new Person(network, 0);
            network.Broadcast(longMessage, seanLocation);

            Assert.DoesNotContain(longMessage, laura.GetMessagesHeard());
        }
    }
}
