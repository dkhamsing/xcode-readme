# Batch correcting
module CocoapodsReadme
  require 'cocoapods-readme/constants'
  require 'cocoapods-readme/correct'

  class << self
    COMMAND = BATCH
    OPTION_ABUSE = 'abuse'

    def batch
      puts "#{PRODUCT} #{VERSION}"

      unless github_creds
        puts 'GitHub credentials are required in .netrc https://github.com/octokit/octokit.rb#using-a-netrc-file'
        exit
      end

      opt_abuse = "--#{OPTION_ABUSE}"
      if ARGV.count == 0
        puts "Usage: #{COMMAND} <file> [#{opt_abuse}] \n"\
             "       file \t list of repos, one repo per line \n"\
             "       #{opt_abuse} \t skip pull requests (abuse detected)"
        exit
      end

      filename = ARGV[0]
      begin
        c = File.read filename
      rescue => e
        puts "file open error: #{e}"
        exit
      end

      repos = c.split( "\n")
        .select { |r| r.include? '/' }
        .map { |l| l.sub 'https://github.com/', ''}

      File.open(LOG_FILE, 'a') { |f| f.puts '' }
      repos.each.with_index do |repo, i|
        log = File.read LOG_FILE

        print "#{i+1}/#{repos.count}. #{repo}: "

        if log.include? repo
          puts "Skipping, already in log"
          next
        end

        # log the repo
        File.open(LOG_FILE, 'a') { |f| f.puts repo }

        correct repo, PULL_REQUEST_DESCRIPTION, true, (ARGV.include? opt_abuse)
      end
    end # def
  end # class
end # module
