using System;
using System.Collections.Generic;

namespace Shouty
{
    public class Network
    {
        private readonly List<Person> listeners = new List<Person>();
        private readonly int range;

        public Network(int range)
        {
            this.range = range;
        }

        public virtual void Subscribe(Person person)
        {
            listeners.Add(person);
        }

        public virtual void Broadcast(string message, int shouterLocation)
        {
            foreach (var listener in listeners)
            {
                var withinRange = Math.Abs(listener.Location - shouterLocation) <= range;
                var shortEnough = message.Length <= 180;
                if (withinRange && shortEnough)
                    listener.Hear(message);
            }
        }
    }
}
