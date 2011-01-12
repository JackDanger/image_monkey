
task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << '.'
  test.ruby_opts << '-rubygems'
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end
