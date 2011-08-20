Gem::Specification.new do |spec|
  spec.name        = 'simple_youtube'
  spec.version     = '2.0.2'
  spec.authors     = ['James Shipton']
  spec.email       = ['ionysis@gmail.com']
  spec.homepage    = 'https://github.com/jamesshipton/simple_youtube'
  spec.summary     = 'ActiveResource extension to Gdata Youtube API.'
  spec.description = 'ActiveResource extension to Gdata Youtube API, anonymous Reads, Updates using your API key and OAuth, no Create or Delete access.'
     
  spec.add_dependency 'activeresource', '~> 3.0.5'
  spec.add_dependency 'oauth', '~> 0.4.4'
  spec.add_development_dependency 'fakeweb', '~> 1.2.8'  
  spec.add_development_dependency 'rspec', '~> 2.5'
 
  spec.files        = Dir.glob('lib/**/*')
  spec.test_files   = Dir.glob('spec/**/*')
  spec.require_path = 'lib'
end