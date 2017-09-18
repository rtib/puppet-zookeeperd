require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-strings/tasks'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'
  config.fail_on_warnings = true
  config.ignore_paths = [
    'test/**/*.pp',
    'vendor/**/*.pp',
    'examples/**/*.pp',
    'spec/**/*.pp',
    'pkg/**/*.pp'
  ]
  config.disable_checks = []
end

desc 'Populate CONTRIBUTORS file'
task :contributors do
  system('git log --format="%aN <%aE>" | sort -u > CONTRIBUTORS')
end
