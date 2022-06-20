task :tags do
  refs = `git ls-remote --heads origin | grep refs/heads/code.`.lines.map { |line| line.split(" ").last.strip }
  push_instructions = refs.map do |branch_ref|
    tag_ref = "#{branch_ref.gsub("refs/heads/", "refs/tags/")}.start"
    first_commit=`git rev-list --max-parents=0 #{branch_ref}`.strip
    "#{first_commit}:#{tag_ref}"
  end
  system("git push origin #{push_instructions.join(" ")}")
end
