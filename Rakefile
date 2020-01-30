require 'awesome_print'

AwesomePrint.defaults = {
  indent: 2,
  index:  false,
}

LANGUAGES = {
  ruby: "Ruby",
  js:   "JavaScript"
}

task :generate_index_files, [:lang] => [] do |t, args|
  language_codes(args).each do |code|
    Dir.chdir('content') do

      chapters = Dir.glob('*').select {|f| File.directory? f}.sort
      File.open("./scripts.#{code}.adoc", "w") do |scripts|

        chapters.each do |chapter|
          scripts << "include::#{chapter}/index.adoc[]\n\n"

          script_files = FileList["#{chapter}/*/script.#{code}.adoc"]

          script_files.each { |file_name|
            scripts << "include::#{file_name}[]\n\n"

            questions_file_name = File.join(File.dirname(file_name), "questions.adoc")
            if File.exist?(questions_file_name)
              scripts << "include::#{questions_file_name}[]\n\n"
            end
          }
        end
      end
    end
  end
end

task :html, [:lang] => :generate_index_files do |t, args|
  require 'asciidoctor'

  FileUtils.rm_rf Dir.glob('public/*.html')

  language_codes(args).each do |code|
    puts "Generating #{code}"
    Asciidoctor.convert_file "content/index.#{code}.adoc",
                             safe: :safe,
                             to_file: "public/#{code}/index.html",
                             mkdirs: true,
                             attributes: { 'shots' => ENV['shots'] }
  end

  Dir.chdir('content') do
    File.open("./languages.adoc", "w") do |f|
      LANGUAGES.each do |lang, name|
        f << "- link:#{lang}/index.html[#{name} Version]\n"

      end
    end
  end

  Asciidoctor.convert_file "content/index.adoc",
                           safe: :safe,
                           to_file: "public/index.html",
                           mkdirs: true,
                           attributes: { 'shots' => ENV['shots'] }
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

require 'asciidoctor'
require 'asciidoctor/extensions'

def tag(text)
  %(<span style="border-radius: 10px; padding: 2px 5px 2px 5px; color: white; font-weight: bold; background-color: red; font-family: sans-serif;">#{text}</span>)
end


class ShotInlineMacro < Asciidoctor::Extensions::InlineMacroProcessor
  use_dsl

  named :shot

  def process parent, target, attrs
    doc = parent.document
    return unless doc.attributes['shots']
    tag("Shot")
  end
end

class AnimationInlineMacro < Asciidoctor::Extensions::InlineMacroProcessor
  use_dsl

  named :animation

  def process parent, target, attrs
    doc = parent.document
    return unless doc.attributes['shots']
    tag("Animation")
  end
end

Asciidoctor::Extensions.register do
  inline_macro ShotInlineMacro if document.basebackend? 'html'
  inline_macro AnimationInlineMacro if document.basebackend? 'html'
end
