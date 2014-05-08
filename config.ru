#!/Users/macbookpro/.rvm/gems/ruby-1.9.3-p392@flash/bin/rackup
#\ -s puma 
# $LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bundler/setup'
require './cueboy_test'

run Rack::Lint.new(CueboyTest.new)
