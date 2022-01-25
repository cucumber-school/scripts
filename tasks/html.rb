require_relative './model'
require_relative './shots'
require_relative './underline'

task :generate_index_files, [:lang] => [] do |t, args|
  Course.all.each do |course|
    Dir.chdir(course.path) do
  
      puts "Compiling .adoc scripts include files for course #{course.name}"
      variants = course.language_codes.any? ? course.language_codes(args) : ["common"]
      variants.each do |code|
        File.open("./scripts.#{code}.adoc", "w") do |scripts|
          course.chapters.each do |chapter|
            scripts << asciidoc_include("#{chapter}/index.adoc")
            chapter.content_to_include(code).map { |path| asciidoc_include(path) }.each do |line|
              scripts << line
            end
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
    puts
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

  puts "Generating main index.html page for site"
  Asciidoctor.convert_file "content/index.adoc",
                          safe: :safe,
                          to_file: "public/index.html"

end

def asciidoc_include(path)
  "include::#{path}[]\n\n"
end