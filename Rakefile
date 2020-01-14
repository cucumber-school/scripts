task :generate_index_files do
  Dir.chdir('ruby') do
    script_files = FileList["**/script.adoc"]

    File.open("./index-files.adoc", "w") do |f|
      script_files.each { |file_name|
        f << "include::#{file_name}[]\n"

        questions_file_name = file_name.gsub(/script/, "questions")
        if File.exist?(questions_file_name)
          f << "include::#{questions_file_name}[]\n"
        end
      }
    end
  end
end

task :html => :generate_index_files do
  require 'asciidoctor'

  Asciidoctor.convert_file 'ruby/index.adoc',
                           safe: :unsafe,
                           to_dir: 'public',
                           mkdirs: true
end

task :default => :html
