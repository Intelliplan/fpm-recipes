desc 'display help'
task :default do
  puts 'haf\'s fpm recipes'
  puts `rake -T`
end

desc 'build all recipes'
task :build => [:"recipes:mono", :"recipes:fsharp", :"recipes:python_supervisor", :"recipes:teamcity_server"]

def build dir
  if File.directory? dir then
    Dir.chdir dir do
      system 'fpm-cook' if File.exists? 'recipe.rb'
    end
  end
end

namespace :recipes do
  task :mono do
    build 'mono'
  end

  task :fsharp do
    build 'fsharp'
  end

  task :python_supervisor do
    build 'python-supervisor'
  end

  task :teamcity_server do
    build 'teamcity-server'
  end
end
