Pod::Spec.new do |spec|
  spec.name = 'Introspect'
  spec.version = ENV['LIB_VERSION']
  spec.license = { type: 'MIT' }
  spec.homepage = 'https://github.com/siteline/SwiftUI-Introspect.git'
  spec.authors = { 'Lois Di Qual' => 'lois@siteline.com' }
  spec.summary = 'Introspect the underlying UIKit element of a SwiftUI view.'
  spec.source = {
    git: 'https://github.com/siteline/SwiftUI-Introspect.git',
    tag: spec.version
  }

  spec.source_files = 'Introspect/*.swift'

  spec.swift_version = '5.5'
  spec.ios.deployment_target = '13.0'
  spec.tvos.deployment_target = '13.0'
  spec.osx.deployment_target = '10.15'
end
