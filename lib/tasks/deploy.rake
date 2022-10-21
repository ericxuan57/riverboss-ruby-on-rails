task :dev do
  @remote = "git@heroku.com:riverboss.git"
  @app = "riverboss"
end

def current_branch
  @current_branch ||= %x{git symbolic-ref HEAD}.chomp.split('/').last
end

def run(command)
  Bundler.with_clean_env {
    out = `#{command}`
    puts out
    if $?.success?
      out
    else
      exit $?.exitstatus
    end
  }
end

desc "Deploy"

task :deploy do
  run "heroku maintenance:on --app #{@app}"
  run "git push #{@remote} #{current_branch}:master"
  run "heroku run rake db:migrate --app #{@app}"
  run "heroku restart --app #{@app}"
  run "heroku run rake deploy:clear_cache --app #{@app}"
  run "heroku maintenance:off --app #{@app}"
end
