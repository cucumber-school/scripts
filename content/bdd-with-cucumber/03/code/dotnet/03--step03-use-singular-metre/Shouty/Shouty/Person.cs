using System;
using System.Collections.Generic;

namespace Shouty
{
    public class Person
    {
        public void MoveTo(int distance)
        {
        }

        public void Shout(string message)
        {
        }

        public IList<string> GetMessagesHeard()
        {
            return new List<string> { "free bagels at Sean's" };
        }
    }
}
