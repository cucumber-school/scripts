require 'tmpdir'
require_relative './languages'
require 'awesome_print'

pwd = Dir.pwd

task code: 'code:unroll'
namespace :code do
  task :unroll do
    puts "Unrolling code branches..."
    Dir.chdir(Dir.tmpdir) do
      `git clone --quiet #{pwd} code` unless Dir.exists?('code') && Dir.exists?('code/.git')
      Dir.chdir("code") do
        `git fetch origin`
        `git config advice.detachedHead false`
        chapters(pwd).each do |chapter|
          `mkdir -p #{chapter.dir}/code`

          puts
          puts "Chapter #{chapter.num}"
          puts "=========="
          puts 
          language_codes.each do |lang|
            branch = chapter.code_branch(lang)
            cmd = "git ls-remote --exit-code origin #{branch} > /dev/null"
            unless system(cmd)
              puts "#{branch.red} \t- No branch exists. Skipping."
            else
              puts "#{branch.red} \t- Branch exists. Preparing to unroll commits..."
              dir = "#{chapter.dir}/code/#{lang}"
              `mkdir -p #{dir}`
              `git reset --hard origin/#{branch}`
              `git branch -D #{branch}`
              `git checkout -b #{branch} &> /dev/null`
              commits_raw = `git rev-list #{branch}`
              commits_cache = "#{dir}/.commits"
              existing_commits = File.exists?(commits_cache) && File.read(commits_cache)
              if existing_commits
                print "Existing commits cached. "
              else
                puts "No existing commits cached at #{commits_cache}"
              end
              if existing_commits == commits_raw
                puts "Current branch commits match existing ones. Skipping."
              else
                `rm -rf #{dir}/*`
                commits = commits_raw.split.reverse
                puts "Found #{commits.count} commits on #{branch}"
                commits.each_with_index do |commit, i|
                  puts "Fetching code for commit #{commit}"
                  commit_message = `git show -s --format=%s #{commit}`.split("\n").first
                  dir = "#{chapter.dir}/code/#{lang}/%02d-#{commit_message.downcase.gsub(/\W+/, "-")}" % i
                  `mkdir #{dir}`
                  `git checkout #{commit}`
                  `git clean -fd`
                  `cp -R . #{dir}`
                  `rm -rf #{dir}/.git`
                end
                File.open(commits_cache, "w") { |stream| stream << commits_raw }
              end
            end
          end
        end
      end
    end
  end

  task :clean do
    Dir.glob('content/**/code').each { |file| FileUtils.rm_rf file }
    Dir.chdir(Dir.tmpdir) do
      `rm -rf code`
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

