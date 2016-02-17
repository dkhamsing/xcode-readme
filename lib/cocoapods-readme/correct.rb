# Correct README
module CocoapodsReadme
  require 'cocoapods-readme/diff'
  require 'cocoapods-readme/github'

  class << self
    def correct(repo, description, auto=false, abuse=false)
      c = github_client
      readme, content = github_readme c, repo

      if readme.nil?
        puts 'No README 😢'
        return
      end

      nogood = 'xCode'
      nogood2 = 'XCode'

      # ^ hmm we can do better

      correct = 'Xcode'

      issues = (content.include? nogood) || (content.include? nogood2)

      unless issues
        puts 'No issues ✅'
        return
      end

      if abuse
        puts 'abuse mode on, correct later 🔵'
        fname = 'temp-abuse-todo'
        File.open(fname, 'a') { |f| f.puts repo }

        left = c.rate_limit.remaining
        puts "GitHub rate limit remaining: #{left}"

        if left < 300
          puts "Let's take a break 😅  (resets in #{c.rate_limit['resets_in']}s)"
          exit
        end
        return
      end

      content_corrected = content.gsub(nogood, correct)
        .gsub(nogood2, correct)
        # .gsub(nogood3, correct)
      changes = Differ.diff(content_corrected, content).changes

      puts "Whoa look how they wrote \"#{correct}\" 🔴 😭"

      changes.each_with_index do |c, i|
        puts "#{i+1}. #{c.delete}"
      end

      unless auto
        print "Open pull request? (y/n) "
        user_input = STDIN.gets.chomp
        exit unless user_input.downcase == 'y'
      end

      default_branch = github_default_branch c, repo
      file_updated = 'temp-corrected'
      File.write file_updated, content_corrected
      pull_url = github_pull_request(repo,
        default_branch,
        readme,
        file_updated,
        PULL_REQUEST_COMMIT_MESSAGE,
        PULL_REQUEST_TITLE,
        description,
        nil)
      puts "Done: #{pull_url}"

      if auto
        left = c.rate_limit.remaining
        puts "GitHub rate limit remaining: #{left}"

        if left < 100
          puts "Yeesh, let's take a break 🤔"
          exit
        end

        pause = left > 1000 ? Random.new.rand(30..60) : 300
        puts "Pausing for #{pause}s ... 😴"
        sleep pause
      end
    end # def
  end # class
end
