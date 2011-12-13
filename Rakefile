# begin
  require 'nanoc3/tasks'
  require 'fileutils'
# rescue LoadError
  require 'rubygems'
  require 'nanoc3/tasks'
# end

require 'rake'
require 'rdoc'
require 'date'

#edk - s3 bucket variable
s3_bucket = "www.edkhou.com"

desc "Deploy website via s3cmd"
task :s3 do
  puts "## Deploying website via s3cmd"
  ok_failed system("s3cmd sync --acl-public --reduced-redundancy output/* s3://#{s3_bucket}/")
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

footer: <div><span  class='st_twitter_hcount' displayText='Tweet'></span><span  class='st_facebook_hcount' displayText='Facebook'></span><span  class='st_fblike_hcount' ></span><span  class='st_plusone_hcount' ></span></div>
---
<%= item[:excerpt] %>

INSERT CONTENT IN EXCERPT AS WELL HERE

<%= item[:footer] %>
<div id="disqus_thread"></div>
<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'edkphotography'; // required: replace example with your forum shortname

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>
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

def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end

