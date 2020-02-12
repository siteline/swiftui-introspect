Pod::Spec.new do |spec|
  spec.name = 'Introspect'
  spec.version = '0.0.6'
  spec.license = { type: 'MIT' }
  spec.homepage = 'https://github.com/siteline/SwiftUI-Introspect.git'
  spec.authors = { 'Lois Di Qual' => 'lois@siteline.com' }
  spec.summary = 'Introspect the underlying UIKit element of a SwiftUI view.'
  spec.source = {
    git: 'https://github.com/siteline/SwiftUI-Introspect.git',
    tag: spec.version
  }
  spec.swift_version = '5.1'
  spec.source_files = 'Introspect/Introspect.swift'

  # iOS
  spec.ios.deployment_target = '13.0'
  spec.ios.source_files = 'Introspect/UIKit/*.swift'

  # tvOS
  spec.tvos.deployment_target = '13.0'
  spec.tvos.source_files = 'Introspect/UIKit/*.swift'

  # macOS
  spec.osx.deployment_target = '10.15'
  spec.osx.source_files = 'Introspect/AppKit/*.swift'
end
