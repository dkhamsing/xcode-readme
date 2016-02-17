# GitHub helper
module CocoapodsReadme
  GITHUB_API_BASE = 'https://api.github.com/'
  GITHUB_RAW_CONTENT_URL = 'https://raw.githubusercontent.com/'

  GITHUB_CREDS_ERROR = 'Missing GitHub credentials in .netrc'

  NETRC_GITHUB_MACHINE = 'api.github.com'

  class << self
    require 'octokit'
    require 'netrc'
    require 'json'

    def github_client
      Octokit::Client.new(netrc: true)
    end

    def github_default_branch(client, repo)
      r = github_repo client, repo
      r['default_branch']
    end

    def github_fork(client, repo)
      client.fork(repo)
    end

    def github_netrc
      n = Netrc.read
      n[NETRC_GITHUB_MACHINE]
    end

    def github_creds
      !(github_netrc.nil?)
    end

    def github_netrc_username
      n = github_netrc
      n[0]
    end

    def github_pull_request(repo,
      branch,
      readme,
      filename,
      commit_message,
      pull_title,
      description,
      log)
      forker = github_netrc_username
      fork = repo.gsub(%r{.*\/}, "#{forker}/")
      log.verbose "Fork: #{fork}" unless log == nil

      github = github_client

      # fork
      puts "Forking to #{fork} ..."
      forked_repo = nil
      while forked_repo.nil?
        forked_repo = github_fork(github, repo)
        sleep 2
        log.verbose 'Forking repo.. sleep' unless log == nil
      end

      # commit change
      puts 'Committing change...'
      ref = "heads/#{branch}"

      begin
        githubref = github.ref(fork, ref)

      rescue StandardError => e
        puts "Error: #{e}"
        delay = 3
        puts "Trying again in #{delay} seconds..."
        sleep delay
        githubref = github.ref(fork, ref)
      end

      sha_latest_commit = githubref.object.sha
      sha_base_tree = github.commit(fork, sha_latest_commit).commit.tree.sha
      file_name = readme
      my_content = File.read(filename)

      blob_sha = github.create_blob(fork, Base64.encode64(my_content), 'base64')
      sha_new_tree = github.create_tree(fork,
                                        [{ path: file_name,
                                           mode: '100644',
                                           type: 'blob',
                                           sha: blob_sha }],
                                        base_tree: sha_base_tree).sha
      sha_new_commit = github.create_commit(fork,
                                            commit_message,
                                            sha_new_tree,
                                            sha_latest_commit).sha
      updated_ref = github.update_ref(fork, ref, sha_new_commit)
      log.verbose "Updated ref: #{updated_ref}" unless log == nil
      log.verbose "Sent commit to fork #{fork}" unless log == nil

      # create pull request
      puts 'Opening pull request...'
      head = "#{forker}:#{branch}"
      log.verbose "Set head to #{head}" unless log == nil

      begin
        created = github.create_pull_request(repo,
                                             branch,
                                             head,
                                             pull_title,
                                             description)
        return created[:html_url]
      rescue StandardError => e
        puts 'Could not create pull request'
        puts "error #{e}"
        exit if e.to_s.include? 'abuse'
        return nil
      end
    end

    def github_readme(client, repo)
      begin
        r = client.readme repo
      rescue StandardError => e
        return [nil, e]
      end

      name = r['name']
      content = r['content']
      decoded = Base64.decode64 content unless content.nil?

      [name, decoded]
    end

    def github_repo(client, repo)
      client.repo(repo)
    end
  end # class
end
