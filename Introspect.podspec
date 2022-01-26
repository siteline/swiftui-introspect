Pod::Spec.new do |spec|
  spec.name = 'Introspect'
  spec.version = '0.1.4'
  spec.license = { type: 'MIT' }
  spec.homepage = 'https://github.com/siteline/SwiftUI-Introspect.git'
  spec.authors = { 'Lois Di Qual' => 'lois@siteline.com' }
  spec.summary = 'Introspect the underlying UIKit element of a SwiftUI view.'
  spec.source = {
    git: 'https://github.com/siteline/SwiftUI-Introspect.git',
    tag: spec.version
  }

  spec.source_files = 'Introspect/*.swift'

  spec.swift_version = '5.1'
  spec.ios.deployment_target = '11.0'
  spec.tvos.deployment_target = '11.0'
  spec.osx.deployment_target = '10.13'
end
