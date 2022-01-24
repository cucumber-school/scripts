task :default do
  sh "bundle exec rspec"
  sh "bundle exec cucumber --tags 'not @todo' --format progress"
end
