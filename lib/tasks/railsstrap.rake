require 'fileutils'

desc "Create nondigest versions of bootstrap + fontawesome font digest assets"
task "assets:precompile" do
  fingerprint = /\-[0-9a-f]{32}\./
  
  files = Dir["public/assets/bootstrap/**/*"] + Dir["public/assets/fontawesome/**/*"]
  
  for file in files
    next unless file =~ fingerprint
    nondigest = file.sub fingerprint, '.'
      if !File.exist?(nondigest) or File.mtime(file) > File.mtime(nondigest)
        FileUtils.cp file, nondigest, verbose: true, preserve: true
      end
  end
  
end