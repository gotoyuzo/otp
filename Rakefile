require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |test|
  test.pattern = "test/**/test_*.rb"
  test.verbose = true
end

desc "Run rubocop"
task :rubocop do
  sh "rubocop lib -f html -o rubocop.html"
end

task :default => [:test, :rubocop]
