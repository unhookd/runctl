# config.ru (run with rackup)

project = File.dirname(File.realpath(__FILE__))
lib = File.join(project, "lib")
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'runctl'

run Runctl::Application
