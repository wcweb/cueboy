#!/usr/bin/env ruby
# -*- ruby -*-

#\ -s puma 
# $LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bundler/setup'
require './cueboy_test'
require 'rack'

Rack::Handler::FastCGI.run(Rack::Lint.new(CueboyTest.new))

