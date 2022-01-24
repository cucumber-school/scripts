require_relative './languages'

ROOT = File.expand_path(File.dirname(__FILE__) + '/..')

class Course
  def self.all
    folders = Dir.glob("#{ROOT}/content/*").select {|f| File.directory? f}.sort
    folders.map { |f| Course.new(f) }
  end

  attr_reader :name, :path

  def initialize(path)
    @path = File.expand_path(path)
    @name = path.split("/").last
  end

  def to_s
    name
  end

  def language_codes(args = {})
    candidates = Array(args[:lang] || LANGUAGES.keys)
    candidates.filter { |lang| 
      Dir.glob("#{path}/index.#{lang}.adoc").any?
    }
  end

  def chapters
    Dir.glob("#{path}/*").
      select { |f| File.directory? f}.
      sort.
      map { |path| Chapter.new(path) }
  end
end

class Chapter
  def initialize(path)
    @path = File.expand_path(path)
  end

  def num
    "%02d" % @path.split("/").last.to_i
  end

  def dir
    @path
  end

  def code_branch(lang)
    "chapter-#{num}-code-#{lang}"
  end

  def to_s
    num.to_s
  end

  def content_to_include(language_code)
    result = []
    script_files = FileList["#{num}/*/script.#{language_code}.adoc"]
    script_files.each { |lesson_script|
      result << lesson_script

      questions_file_name = File.join(File.dirname(lesson_script), "questions.#{language_code}.adoc")
      if not File.exist?(questions_file_name)
        questions_file_name = File.join(File.dirname(lesson_script), "questions.adoc")
      end
      if File.exist?(questions_file_name)
        result << questions_file_name
      end
    }
    result
  end
end