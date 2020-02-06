require 'tmpdir'
require_relative './languages'

pwd = Dir.pwd

task :code do
  Dir.chdir(Dir.tmpdir) do
    `rm -rf code`
    `git clone #{pwd} code`
    puts "Cloned into #{Dir.pwd}"
    Dir.chdir("code") do
      `git fetch origin`
      `git config advice.detachedHead false`
      chapters(pwd).each do |chapter|
        `rm -rf #{chapter.dir}/code`
        `mkdir #{chapter.dir}/code`
        language_codes.each do |lang|
          branch = chapter.code_branch(lang)
          cmd = "git ls-remote --exit-code origin #{branch}"
          unless system(cmd)
            puts "No code branch found for #{branch}"
          else
            puts "Found code!"
            dir = "#{chapter.dir}/code/#{lang}"
            `mkdir -p #{dir}`
            `git reset --hard origin/#{branch}`
            `git checkout -b #{branch}`
            commits = `git rev-list #{branch}`.split.reverse
            puts "Found #{commits.count} commits on #{branch}"
            commits.each_with_index do |commit, i|
              puts "fetching code for commit #{commit}"
              dir = "#{chapter.dir}/code/#{lang}/%02d" % i
              `mkdir #{dir}`
              `git checkout #{commit}`
              `git clean -fd`
              `cp -R . #{dir}`
            end
          end
        end
      end
    end
  end
end

def chapters(pwd)
  chapters = Dir.glob("#{pwd}/content/*").select {|f| File.directory? f}.sort.map do |path|
    Chapter.new(path)
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

