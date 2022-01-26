require 'tmpdir'
require 'awesome_print'
require_relative './languages'
require_relative './model'
require_relative './underline'

root = File.expand_path(File.dirname(__FILE__) + '/..')

task :code, [:lang] => ['code:unroll'] do |t, args|
end

namespace :code do
  task :unroll, [:lang] => :branches do |t, args|
    branches_unrolled = 0
    puts "Unrolling code branches..."
    Dir.chdir(Dir.tmpdir) do
      `git clone --quiet #{root} code` unless Dir.exists?('code') && Dir.exists?('code/.git')
      Dir.chdir("code") do
        `git fetch origin`
        `git config advice.detachedHead false`

        Course.all.each do |course|
          puts
          puts
          puts underline("Course: #{course}")

          course.chapters.each do |chapter|
            `mkdir -p #{chapter.dir}/code`

            puts
            puts underline("Chapter #{chapter.num}")
            course.language_codes.each do |lang|
              branch = chapter.code_branch(lang)
              cmd = "git ls-remote --exit-code origin #{branch} > /dev/null"
              unless system(cmd)
                puts "#{branch} \t- No branch exists. Skipping.".gray
              else
                puts "#{branch} \t- Branch exists. Preparing to unroll commits..."
                dir = "#{chapter.dir}/code/#{lang}"
                `mkdir -p #{dir}`
                `git reset --hard origin/#{branch}`
                `git branch -D #{branch}`
                `git checkout -b #{branch} &> /dev/null`
                commits_raw = `git rev-list #{branch}`
                commits_cache = "#{dir}/.commits"
                existing_commits = File.exists?(commits_cache) && File.read(commits_cache)
                if existing_commits
                  print "Existing commits cached. ".green
                else
                  puts "No existing commits cached at #{commits_cache}"
                end
                if existing_commits == commits_raw
                  puts "Current branch commits match existing ones. Skipping.".green
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
    end
    exit branches_unrolled
  end

  task :clean do
    Dir.glob('content/**/code').each { |file| FileUtils.rm_rf file }
    Dir.chdir(Dir.tmpdir) do
      `rm -rf code`
    end
  end

  task :rename_branches do
    code_branches = `git for-each-ref`.
      split("\n").
      select { |line| line.match? /chapter-\d\d-code-(?:ruby|js|java|dotnet)/ }.
      map { |line|
        rev, _, ref = line.split
        Branch.new(rev, ref)
      }
    code_branches.each do |branch|
      chapter, lang = branch.name.match(/chapter-(\d\d)-code-(\w+)/)[1..2]
      new_name = "code.bdd-with-cucumber.#{chapter}.#{lang}"
      `git branch -m #{branch.name} #{new_name}`
    end
  end

  task :branches, [:lang] do |t, args|
    code_branches = `git for-each-ref`.
      split("\n").
      select { |line| line.match? /code\.[a-z-]+.\d\d.#{args[:lang]}/ }.
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
        puts remote_branch.name.red + ' does not exist locally. Fetching...'
        puts `git fetch origin #{remote_branch.name}:#{remote_branch.name}`
        puts `git branch --set-upstream-to=origin/#{remote_branch.name} #{remote_branch.name}`
      end
    end

    if problems > 0
      fail "You have #{problems} branches that need attention."
    end
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
