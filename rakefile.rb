#encoding=UTF-8 
require 'rubygems'
require 'bundler'
Bundler.require

library :robotlegs, :swc

##############################
# Configure

def configure_mxmlc t
    # need by as not flex with static link runtime shared lib
  t.static_link_runtime_shared_libraries = true
 # t.advanced_telemetry = true
  t.source_path << 'src/as/'
  t.library_path << 'lib/jwplayer-5-lib.swc'
  t.library_path << 'lib/as3corelib.swc'
  t.library_path << 'lib/as3-signals-v0.9-BETA.swc'
  t.library_path << 'lib/tweener.swc'
  t.library_path << 'lib/aswing.swc'
end

##############################
# Test

# Compile the debug swf
mxmlc "test/cueboy.swf" do |t|
  configure_mxmlc t
  t.input = "src/as/us/wcweb/Cueboy/Cueboy.as"
  t.debug = true
  t.library_path << 'lib/MonsterDebugger.swc'
end

desc "Compile and run the swf"
flashplayer :test => "test/cueboy.swf"




##############################
# Bulid

# Compile the debug swf
mxmlc "bin/cueboy.swf" do |t|
  configure_mxmlc t
  t.input = "src/as/us/wcweb/Cueboy/Cueboy.as"

end

desc "Compile  swf"
flashplayer :build => "bin/cueboy.swf"


##############################
# DOC

desc "Generate documentation at doc/"
asdoc 'doc' do |t|
  t.doc_sources << "src"
  t.exclude_sources << "src/as/us/wcweb/Cueboy/Cueboy.as"
end


desc "server"
task :server  do
  
  # puts Sinatra::Application.environment
end

task :default => :build




