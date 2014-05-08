#!/Users/macbookpro/.rvm/rubies/ruby-1.9.3-p392/bin/ruby
require 'rubygems'
require 'rack'

fastcgi_log = File.open("fastcgi.log", "a")
STDOUT.reopen fastcgi_log
STDERR.reopen fastcgi_log
STDOUT.sync = true

module Rack
  class Request
    def path_info
      @env.delete('SCRIPT_NAME')
      parts = @env['REQUEST_URI'].split('?')
      @env["QUERY_STRING"]= parts[1].to_s
      @env["REDIRECT_URL"].to_s
      @env["PATH_INFO"] = parts[0]
    end
    def path_info=(s)
      @env["REDIRECT_URL"] = s.to_s
    end
  end
end

require './cueboy_test'

builder = Rack::Builder.new do
  map '/' do
    run CueboyTest.new
  end
end

Rack::Handler::FastCGI.run(builder)