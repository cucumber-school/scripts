require 'tmpdir'
require_relative './languages'
require 'awesome_print'

pwd = Dir.pwd

task :code, [:lang] => ['code:unroll'] do |t, args|
end

namespace :code do
  task :unroll, [:lang] => :branches do |t, args|
    branches_unrolled = 0
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
          language_codes(args).each do |lang|
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
                branches_unrolled += 1
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
    exit branches_unrolled
  end

  task :clean do
    Dir.glob('content/**/code').each { |file| FileUtils.rm_rf file }
    Dir.chdir(Dir.tmpdir) do
      `rm -rf code`
    end
  end

  task :branches, [:lang] do |t, args|
    code_branches = `git for-each-ref`.
      split("\n").
      select { |line| line.match? /chapter-\d\d-code-#{args[:lang]}/ }.
      map { |line|
        rev, _, ref = line.split
        Branch.new(rev, ref)
      }

    remote_code_branches = code_branches.select(&:remote?)
    local_code_branches = code_branches.reject(&:remote?)

    problems = 0
    puts "Comparing local code branches with origin repo..."
    for remote_branch in remote_code_branches
      local_branch = local_code_branches.find { |b| b.name === remote_branch.name }
      if local_branch
        if local_branch.rev === remote_branch.rev
          puts remote_branch.name.green
        else
          puts remote_branch.name.red + ' exists but has a different revision to origin'
          problems +=1
        end
      else
        puts remote_branch.name.red + ' does not exist locally'
        problems +=1
      end
    end

    if problems > 0
      fail "You have #{problems} branches that need attention."
    end
  end
end

def chapters(pwd)
  chapters = Dir.glob("#{pwd}/content/*").select {|f| File.directory? f}.sort.map do |path|
    Chapter.new(path)
  end
end

class Branch
  attr_reader :rev
  attr_reader :ref

  def initialize(rev, ref)
    @rev, @ref = rev, ref
  end

  def name
    @ref.split("/").last
  end

  def remote?
    @ref.match?(/refs\/remotes\/origin/)
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

