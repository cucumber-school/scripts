require_relative './languages'

class Course
  def self.all
    folders = Dir.glob('content/*').select {|f| File.directory? f}.sort
    folders.map { |f| Course.new(f) }
  end

  attr_reader :name, :path

  def initialize(path)
    @path = File.expand_path(path)
    @name = path.split("/")[1]
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

  def multiple_programming_languages?
    language_codes.any?
  end
end