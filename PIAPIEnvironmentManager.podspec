
Pod::Spec.new do |s|
  s.name             = "PIAPIEnvironmentManager"
  s.version          = "0.3.0"
  s.summary          = "PiOS PIAPIEnvironmentManager pod to help Prolific iOS Engineers manage API Environments."
  s.description      = <<-DESC
                       PiOS PIAPIEnvironmentManager pod to help Prolific iOS Engineers manage API Environments.
             
                       DESC
  s.homepage         = "https://bitbucket.org/prolificinteractive/piapienvironmentmanager"
  s.license          = 'MIT'
  s.author           = { "Julio Rivera" => "julio@prolificinteractive.com" }
  s.source           = { :git => "git@bitbucket.org:prolificinteractive/piapienvironmentmanager.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'PIAPIEnvironmentManager' => ['Pod/Views/*.xib']
  }
end
