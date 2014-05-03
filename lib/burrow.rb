require 'json'
require 'bunny'

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/burrow/*', &method(:require))
