LANGUAGES = {
  ruby: "Ruby",
  js:   "JavaScript"
}

task :generate_index_files, [:lang] => [] do |t, args|
  language_codes(args).each do |code|
    Dir.chdir('content') do
      script_files = FileList["**/script.#{code}.adoc"]

      File.open("./index-files.#{code}.adoc", "w") do |f|
        script_files.each { |file_name|
          f << "include::#{file_name}[]\n\n"

          questions_file_name = File.join(File.dirname(file_name), "questions.adoc")
          if File.exist?(questions_file_name)
            f << "include::#{questions_file_name}[]\n\n"
          end
        }
      end
    end
  end
end

task :html, [:lang] => [:generate_index_files] do |t, args|
  require 'asciidoctor'

  FileUtils.rm_rf Dir.glob('public/*.html')

  language_codes(args).each do |code|
    puts "Generating #{code}"
    Asciidoctor.convert_file "content/index.#{code}.adoc",
                             safe: :unsafe,
                             to_file: "public/#{code}/index.html",
                             mkdirs: true
  end

  Dir.chdir('content') do
    File.open("./languages.adoc", "w") do |f|
      LANGUAGES.each do |lang, name|
        f << "- link:#{lang}/index.html[#{name} Version]\n"

      end
    end
  end

  Asciidoctor.convert_file "content/index.adoc",
                           safe: :unsafe,
                           to_file: "public/index.html",
                           mkdirs: true
end

task :list do
  puts "Available languages: \n"

  LANGUAGES.each do |code, name|
    puts " rake \"html[#{lang}]\"  # Generate HTML for #{name} version."
  end
end

task :default => :html

def language_codes(args)
  Array(args[:lang] || LANGUAGES.keys)
end
