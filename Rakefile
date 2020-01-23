LANGUAGES = %w[ruby js]

task :generate_index_files, [:lang] => [] do |t, args|
  languages(args).each do |lang|
    Dir.chdir('content') do
      script_files = FileList["**/script.#{lang}.adoc"]

      File.open("./index-files.#{lang}.adoc", "w") do |f|
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

  languages(args).each do |lang|
    puts "Generating #{lang}"
    Asciidoctor.convert_file "content/index.#{lang}.adoc",
                             safe: :unsafe,
                             to_file: "public/#{lang}/index.html",
                             mkdirs: true
  end

  Asciidoctor.convert_file "content/index.adoc",
                           safe: :unsafe,
                           to_file: "public/index.html",
                           mkdirs: true
end

task :list do
  puts "Available languages: \n"

  LANGUAGES.each do |lang|
    puts " rake \"html[#{lang}]\""
  end
end

task :default => :html

def languages(args)
  Array(args[:lang] || LANGUAGES)
end
