# Command line interface
module CocoapodsReadme
  require 'cocoapods-readme/constants'
  require 'cocoapods-readme/correct'

  class << self
    def cli
      puts "#{PRODUCT} #{VERSION}"

      unless github_creds
        puts 'GitHub credentials are required in .netrc https://github.com/octokit/octokit.rb#using-a-netrc-file'
        exit
      end

      if ARGV.count == 0
        puts "Usage: #{PRODUCT} <repo> \n"\
          "  i.e. #{PRODUCT} AFNetworking/AFNetworking"
        exit
      end

      cli_repo = ARGV[0]
      repo = cli_repo.sub 'https://github.com/', ''
      puts "Checking #{repo} ..."

      File.open(LOG_FILE, 'a') { |f| f.puts '' }
      log = File.read LOG_FILE

      if log.include? repo
        puts "Skipping #{repo}, already in log"
        exit
      end

      # log the repo
      File.open(LOG_FILE, 'a') { |f| f.puts repo }

      correct repo, PULL_REQUEST_DESCRIPTION
    end # def
  end # class
end # module
