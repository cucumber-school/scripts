using System;
using System.Collections.Generic;

namespace Shouty
{
    public class Network
    {
        private readonly List<Person> listeners = new List<Person>();

        public virtual void Subscribe(Person person)
        {
            listeners.Add(person);
        }

        public virtual void Broadcast(string message)
        {
            foreach (var listener in listeners)
            {
                listener.Hear(message);
            }
        }
    }
}
