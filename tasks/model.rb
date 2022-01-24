require_relative './languages'

class Course
  def self.all(path = Dir.pwd)
    puts path
    folders = Dir.glob("#{path}/content/*").select {|f| File.directory? f}.sort
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
end
