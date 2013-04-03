require 'rest-client'

module SimpleYoutube
  ROOT = File.dirname(__FILE__) + '/..'
end

require 'simple_youtube/version'
require 'simple_youtube/entry_interface_shim.rb'
require 'simple_youtube/active_youtube'
require 'simple_youtube/youtube'
