using System;
using System.Collections.Generic;

namespace Shouty
{
    public class Person
    {
        private readonly Network network;
        private readonly List<string> messagesHeard = new List<string>();

        public Person(Network network)
        {
            this.network = network;
            network.Subscribe(this);
        }

        public void MoveTo(int distance)
        {
        }

        public void Shout(string message)
        {
            network.Broadcast(message);
        }

        public IList<string> GetMessagesHeard()
        {
            return messagesHeard;
        }

        public void Hear(string message)
        {
            messagesHeard.Add(message);
        }
    }
}
