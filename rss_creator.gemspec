Gem::Specification.new do |s|
  s.name = 'rss_creator'
  s.version = '0.1.0'
  s.summary = 'A gem for creating RSS feeds'
  s.authors = ['James Robertson']
  s.files = Dir['lib/rss_creator.rb']
  s.add_runtime_dependency('dynarex', '~> 1.5', '>=1.5.38')
  s.signing_key = '../privatekeys/rss_creator.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rss_creator'
end