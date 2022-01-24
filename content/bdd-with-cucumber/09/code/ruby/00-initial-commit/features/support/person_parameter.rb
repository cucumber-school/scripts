ParameterType(
  name:        "person",
  regexp:      /Sean|Lucy|Larry/,
  transformer: -> (name) {
    @people ||= {}

    @people[name] ||= Shouty::Person.new(name, @network, 0)
  }
)
