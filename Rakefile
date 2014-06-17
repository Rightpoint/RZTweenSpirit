
PROJ_PATH="Example/RZTweenSpiritDemo.xcodeproj"
WORKSPACE_PATH="Example/RZTweenSpiritDemo.xcworkspace"
TEST_SCHEME="RZTweenSpiritDemo"

#
# Install
#

namespace :install do
  
  task :tools do
    # don't care if this fails on travis
    sh("brew update") rescue nil
    sh("brew upgrade xctool") rescue nil
    sh("gem install cocoapods --no-rdoc --no-ri --no-document --quiet") rescue nil
  end

  task :pods do
    sh("cd Example && pod install")
  end
  
end

task :install do
  Rake::Task['install:tools'].invoke
  Rake::Task['install:pods'].invoke
end

#
# Test
#

task :test do
  # NOTE: No tests yet. Just verifying build validity for now.
  sh("xctool -workspace '#{WORKSPACE_PATH}' -scheme '#{TEST_SCHEME}' -sdk iphonesimulator clean build") rescue nil
  exit $?.exitstatus
end

#
# Clean
#

namespace :clean do
  
  task :pods do
    sh("rm -f Example/Podfile.lock")
    sh "rm -rf Example/Pods"
    sh("rm -rf Example/*.xcworkspace")
  end
  
  task :example do
    sh("xctool -project '#{PROJ_PATH}' -scheme '#{TEST_SCHEME}' -sdk iphonesimulator clean") rescue nil
  end
    
end

task :clean do
  Rake::Task['clean:pods'].invoke
  Rake::Task['clean:example'].invoke
end


#
# Utils
#

task :usage do
  puts "Usage:"
  puts "  rake install       -- install all dependencies (xctool, cocoapods)"
  puts "  rake install:pods  -- install cocoapods for tests/example"
  puts "  rake install:tools -- install build tool dependencies"
  puts "  rake test          -- run unit tests"
  puts "  rake clean         -- clean everything"
  puts "  rake clean:example -- clean the example project build artifacts"
  puts "  rake clean:pods    -- clean up cocoapods artifacts"
  puts "  rake sync          -- synchronize project/directory hierarchy (dev only)"
  puts "  rake usage         -- print this message"
end

task :sync do
  sync_project(PROJ_PATH, '--exclusion /Classes')
end

#
# Default
#

task :default => 'usage'

#
# Private
#

private

def sync_project(path, flags)
  sh("synx #{flags} '#{path}'")
end