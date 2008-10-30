def replace_template_vars(s)
  res = s.dup
  s.gsub!('PLURAL_RESOURCE_NAME', ResourceName.pluralize)
  s.gsub!('RESOURCE_NAME', ResourceName)
  s.gsub!('BASE_URL', BaseUrl)
  s.gsub!('USERNAME', ENV['USER'])
  s
end

def process_template_item(file)
  target = File.join(ResultPath, replace_template_vars(file.sub(/^template/, '')))
  if File.directory?(file)
    Dir.mkdir(target)
    Dir.glob(File.join(file, '*')).each {|f| process_template_item(f) }
  else
    File.open(target, 'w') do |f|
      f << replace_template_vars(File.read(file))
    end
  end
end

desc "Generate an app to access the service at BASEURL through the model MODEL"
task :generate do
  abort "No BASEURL provided"  unless base_url      = ENV['BASEURL']
  abort "No RESOURCE provided" unless resource_name = ENV['RESOURCE']

  require "activesupport"
  require "ftools"

  ResourceName = resource_name.camelize
  ResultPath   = "out/#{ResourceName.pluralize}"
  BaseUrl      = base_url.sub(%r{/+$}, "") # Remove trailing slash(es)
  
  if File.exists?(ResultPath)
    Dir.glob(File.join(ResultPath, '*')).each {|f| File.delete(f) }
  else
    FileUtils.mkdir_p ResultPath
  end
  Dir.glob('template/*').each do|source|
    process_template_item(source)
  end
end
