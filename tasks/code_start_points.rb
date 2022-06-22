task :code_start_points do
  system("git fetch")
  refs = `git ls-remote --heads origin | grep refs/heads/code. | grep -v .start$`.lines.map { |line| line.split(" ").last.strip }
  push_instructions = refs.map do |branch_ref|
    start_point_ref = "#{branch_ref}.start"
    first_commit=`git rev-list --max-parents=0 #{branch_ref.gsub("refs/heads", "refs/remotes/origin")}`.strip
    "#{first_commit}:#{start_point_ref}"
  end
  system("git push --force origin #{push_instructions.join(" ")}")
end
