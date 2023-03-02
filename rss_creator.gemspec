Gem::Specification.new do |s|
  s.name = 'rss_creator'
  s.version = '0.6.1'
  s.summary = 'A gem for creating RSS feeds'
  s.authors = ['James Robertson']
  s.files = Dir['lib/rss_creator.rb']
  s.add_runtime_dependency('rss_to_dynarex', '~> 0.2', '>=0.2.1')
  s.add_runtime_dependency('rss_sliml', '~> 0.2', '>=0.2.0')
  s.signing_key = '../privatekeys/rss_creator.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/rss_creator'
end
