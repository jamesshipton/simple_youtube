module SimpleYoutube
  ROOT = File.dirname(__FILE__) + '/..'
end

Dir[SimpleYoutube::ROOT + '/lib/simple_youtube/**/*.rb'].each { |file| require file }
