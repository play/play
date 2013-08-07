Rake::Task[:test].clear

# Load in tests from our api directory, too
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
end
