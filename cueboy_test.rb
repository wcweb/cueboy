# encoding: utf-8
require 'uri'
require 'sinatra/base'
require 'slim'

class CueboyTest < Sinatra::Base
  configure do
    enable :static
    enable :sessions
    
    configure { set :server, :puma }

    # set :views, File.join(File.dirname(__FILE__), 'views')
    set :public_folder, File.join(File.dirname(__FILE__), '')
    set :files, File.join(settings.public_folder, '')
    set :unallowed_paths, ['.', '..']
  end

  helpers do
    def flash(message = '')
      session[:flash] = message
    end
  end

  before do
    @flash = session.delete(:flash)
  end

  not_found do
    slim 'h1 404'
  end

  error do
    slim "Error (#{request.env['sinatra.error']})"
  end

  get '/' do
    @files = Dir.entries(settings.files) - settings.unallowed_paths
  # 
  #   send_file 'test/index.html'
  slim :index
  end
  
  get '/list' do
    content_type 'text/xml'
    "<rss version=\"2.0\" xmlns:media=\"http://search.yahoo.com/mrss/\">
    	<channel>
    		<item>
    			<title>Big B∏˜÷÷Œ </title>
    			<link>http://content.bitsontherun.com/previews/ntPYsD4L-ALJ3XQCI</link>
    			<seekTime>10000</seekTime>
    		</item>
    		<item>
    			<title>Elephants Dream</title>
    			<link>http://content.bitsontherun.com/previews/LJSVMnCF-ALJ3XQCI</link>
    			<seekTime>50000</seekTime>
    		</item>
    		<item>
    			<title>Sintel</title>
    			<link>http://content.bitsontherun.com/previews/r3ABWwdO-ALJ3XQCI</link>
    			<seekTime>100000</seekTime>
    		</item>
    		<item>
    			<title>Big Buck Bunny2</title>
    			<link>http://content.bitsontherun.com/previews/ntPYsD4L-ALJ3XQCI</link>
    			<seekTime>10000</seekTime>
    		</item>
    		<item>
    			<title>Elephants Dream3</title>
    			<link>http://content.bitsontherun.com/previews/LJSVMnCF-ALJ3XQCI</link>
    			<seekTime>50000</seekTime>
    		</item>
    		<item>
    			<title>Sintel1</title>
    			<link>http://content.bitsontherun.com/previews/r3ABWwdO-ALJ3XQCI</link>
    			<seekTime>100000</seekTime>
    		</item>
    		<item>
    			<title>Big Buck Bunny2</title>
    			<link>http://content.bitsontherun.com/previews/ntPYsD4L-ALJ3XQCI</link>
    			<seekTime>10000</seekTime>
    		</item>
    		<item>
    			<title>Elephants Dream3</title>
    			<link>http://content.bitsontherun.com/previews/LJSVMnCF-ALJ3XQCI</link>
    			<seekTime>50000</seekTime>
    		</item>
    		<item>
    			<title>Sintel1</title>
    			<link>http://content.bitsontherun.com/previews/r3ABWwdO-ALJ3XQCI</link>
    			<seekTime>100000</seekTime>
    		</item>
    		<item>
    			<title>Big Buck Bunny2</title>
    			<link>http://content.bitsontherun.com/previews/ntPYsD4L-ALJ3XQCI</link>
    			<seekTime>10000</seekTime>
    		</item>
    		<item>
    			<title>Elephants Dream3</title>
    			<link>http://content.bitsontherun.com/previews/LJSVMnCF-ALJ3XQCI</link>
    			<seekTime>50000</seekTime>
    		</item>
    		<item>
    			<title>Sintel1</title>
    			<link>http://content.bitsontherun.com/previews/r3ABWwdO-ALJ3XQCI</link>
    			<seekTime>100000</seekTime>
    		</item>
    	</channel>
    </rss>
    "
  end
  
end
