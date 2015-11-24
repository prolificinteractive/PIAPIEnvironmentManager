
Pod::Spec.new do |s|
  s.name             = "PIAPIEnvironmentManager"
  s.version          = “0.4.1”
  s.summary          = "PiOS PIAPIEnvironmentManager pod to help iOS Engineers manage API Environments."
  s.description      = <<-DESC
                       PiOS PIAPIEnvironmentManager pod to help iOS Engineers manage API Environments in a simple way,
					   providing a default User Interface and cache functionality to make it simple to change environments
					   easily.
             
                       DESC
  s.homepage         = "https://github.com/prolificinteractive/PIAPIEnvironmentManager.git"
  s.license          = 'MIT'
  s.author           = { "Julio Rivera" => "julio@prolificinteractive.com" }
  s.source           = { :git => "https://github.com/prolificinteractive/PIAPIEnvironmentManager.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'PIAPIEnvironmentManager' => ['Pod/Views/*.xib']
  }
end
