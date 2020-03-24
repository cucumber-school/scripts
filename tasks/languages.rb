LANGUAGES = {
  ruby:   "Ruby",
  js:     "JavaScript",
  java:   "Java",
  dotnet: "SpecFlow",
}

task :list do
  puts "Available languages: \n"

  LANGUAGES.each do |code, name|
    puts " rake \"html[#{lang}]\"  # Generate HTML for #{name} version."
  end
end

def language_codes(args = {})
  Array(args[:lang] || LANGUAGES.keys)
end

