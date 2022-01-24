require_relative './course'
require_relative './shots'

task :generate_index_files, [:lang] => [] do |t, args|
  Course.all.each do |course|
    Dir.chdir(course.path) do
  
      course.language_codes(args).each do |code|
        chapters = Dir.glob('*').select {|f| File.directory? f}.sort
        File.open("./scripts.#{code}.adoc", "w") do |scripts|

          chapters.each do |chapter|
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

  Course.all.each do |course|
    puts underline("Course: #{course}")

    puts "Generating main index page"
    Asciidoctor.convert_file "#{course.path}/index.adoc",
                            safe: :safe,
                            mkdirs: true,
                            to_file: "public/#{course}/index.html"

    course.language_codes.each do |code|
      puts "Generating index page for #{code} language"
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

  puts "Generating main index page"
  Asciidoctor.convert_file "content/index.adoc",
                          safe: :safe,
                          to_file: "public/index.html"

end

def underline(string)
  string + "\n" + ("=" * string.length) + "\n\n"
end