begin
  require 'nanoc3/tasks'
  require 'fileutils'
rescue LoadError
  require 'rubygems'
  require 'nanoc3/tasks'
end

#edk - s3 bucket variable
s3_bucket = "www.edkhou.com"

desc "Deploy website via s3cmd"
task :s3 do
  puts "## Deploying website via s3cmd"
  ok_failed system("s3cmd sync --acl-public --reduced-redundancy public/* s3://#{s3_bucket}/")
end


namespace :create do

  desc "Creates a new article"
  task :article do
    require 'active_support/core_ext'
    require 'active_support/multibyte'
    @ymd2 = Time.now.strftime("%Y/%m/%d")
    @ymd = Time.now.strftime("%F")
    if !ENV['title']
      $stderr.puts "\t[error] Missing title argument.\n\tusage: rake create:article title='article title'"
      exit 1
    end

    title = ENV['title'].capitalize
    path, filename, full_path = calc_path(title)

    if File.exists?(full_path)
      $stderr.puts "\t[error] Exists #{full_path}"
      exit 1
    end

    template = <<TEMPLATE
---
title: "#{title.titleize}"
author: "edk"
filter: erb
tags: [misc]
kind: article
created_at: #{@ymd2}

excerpt:
---
<%= item[:excerpt] %>

INSERT CONTENT IN EXCERPT AS WELL HERE

<p><a href="/">Return home...</a></p>

TEMPLATE

    FileUtils.mkdir_p(path) if !File.exists?(path)
    File.open(full_path, 'w') { |f| f.write(template) }
    $stdout.puts "\t[ok] Edit #{full_path}"
  end

  def calc_path(title)
    year, month_day = @ymd.split('-', 2)
    path = "content/" + year + "/" 
    filename = month_day + "-" + title.parameterize('-') + ".html"
    [path, filename, path + filename]
  end
end

