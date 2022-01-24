using System;
using TechTalk.SpecFlow;

namespace Shouty.Specs.Support
{
    [Binding]
    public class ParameterTypes
    {
        [StepArgumentTransformation]
        public Person ConvertPerson(string name)
        {
            return new Person(name);
        }
    }
}
