require_relative './model'
require_relative './shots'
require_relative './underline'

task :generate_index_files, [:lang] => [] do |t, args|
  Course.all.each do |course|
    Dir.chdir(course.path) do
  
      puts "Compiling scripts include files for course #{course}"
      unless course.language_codes.any?
        code = "common"
        File.open("./scripts.#{code}.adoc", "w") do |scripts|
          course.chapters.each do |chapter|
            puts chapter
            scripts << "include::#{chapter}/index.adoc[]\n\n"

            script_files = FileList["#{chapter}/*/script.#{code}.adoc"]

            script_files.each { |lesson_script|
              scripts << "include::#{lesson_script}[]\n\n"

              questions_file_name = File.join(File.dirname(lesson_script), "questions.#{code}.adoc")
              if not File.exist?(questions_file_name)
                questions_file_name = File.join(File.dirname(lesson_script), "questions.adoc")
              end
              if File.exist?(questions_file_name)
                scripts << "include::#{questions_file_name}[]\n\n"
              end
            }
          end
        end
      end

      course.language_codes(args).each do |code|
        puts code

        File.open("./scripts.#{code}.adoc", "w") do |scripts|

          course.chapters.each do |chapter|
            scripts << "include::#{chapter}/index.adoc[]\n\n"

            script_files = FileList["#{chapter}/*/script.#{code}.adoc"]

            script_files.each { |lesson_script|
              scripts << "include::#{lesson_script}[]\n\n"

              questions_file_name = File.join(File.dirname(lesson_script), "questions.#{code}.adoc")
              if not File.exist?(questions_file_name)
                questions_file_name = File.join(File.dirname(lesson_script), "questions.adoc")
              end
              if File.exist?(questions_file_name)
                scripts << "include::#{questions_file_name}[]\n\n"
              end
            }
          end
        end
      end
    end
  end
end

task :html, [:lang] => :generate_index_files do |t, args|
  require 'asciidoctor'

  FileUtils.rm_rf Dir.glob('public/*.html')

  puts Course.all

  Course.all.each do |course|
    puts underline("Course: #{course}")

    puts "Rendering main index.html page for course"
    Asciidoctor.convert_file "#{course.path}/index.adoc",
                            safe: 0,
                            mkdirs: true,
                            to_file: "public/#{course}/index.html"

    course.language_codes.each do |code|
      puts "Rendering index.html page for #{code} language"
      Asciidoctor.convert_file "#{course.path}/index.#{code}.adoc",
                              safe: :safe,
                              to_file: "public/#{course}/index.#{code}.html",
                              attributes: { 'shots' => false }
      Asciidoctor.convert_file "#{course.path}/index.#{code}.adoc",
                              safe: :safe,
                              to_file: "public/#{course}/index.#{code}.shots.html",
                              attributes: { 'shots' => true }
    end
  end

  puts "Generating main index.html page for course"
  Asciidoctor.convert_file "content/index.adoc",
                          safe: :safe,
                          to_file: "public/index.html"

end