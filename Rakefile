#! /usr/bin/env ruby
require 'rake'

task default: [ :build, :install, :test ]

task :build do
  sh 'gem build zanoxrb.gemspec'
end

task :install do
  sh 'gem install *.gem'
end

task :test do
  FileUtils.cd 'specs' do
    Dir['*_spec.rb'].each do |spec|
      sh "rspec #{spec} --backtrace --color --format doc -r ./spec_helper.rb"
    end
  end
end
