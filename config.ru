# config.ru (run with rackup)

project = File.dirname(File.realpath(__FILE__))
lib = File.join(project, "lib")
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'runctl'

use Rack::Static, { :urls => ["/index.js", "/vanilla.css", "/morphdom-umd-2.5.10.js"], :root => 'public' }

run Runctl::Application
