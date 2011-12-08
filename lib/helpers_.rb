# include custom helpers
include RandomTextHelper

# define customer helpers
module Nanoc3::Helpers::BloggingEdK
	def latest_articles(max=nil)
		total = @site.items.select{|p| p.attributes[:type] == 'article'}.sort{|a, b| a.attributes[:date] <=> b.attributes[:date]}.reverse 
		max ||= total.length
		total[0..max-1]
	end

	def popular_articles(max=nil)
		total = @site.items.select{|p| p.attributes[:date] && p.attributes[:type] == 'article' && p.attributes[:popular]}.sort{|a, b| a.attributes[:date] <=> b.attributes[:date]}.reverse
		max ||= total.length
		total[0..max-1]
	end

	def by_permalink(articles, permalink)
		articles.select{|a| a[:permalink] == permalink}[0] rescue nil
	end
	
	def articles_by_month
		articles = latest_articles
		m_articles = []
		index = -1
		current_month = ""
		articles.each do |a|
			next unless a.atrributes[:date].strftime("%B %Y")
			if current_month != month then
				# new month
				m_articles << [month, [a]]
				index = index + 1
				current_month = month
			else
				# same month
				m_articles[index][1] << a
			end
		end
		m_articles
	end

end

# include default nanoc and additional helpers
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Blogging

include Nanoc3::Helpers::BloggingEdK

# require modules
require 'builder'
require 'fileutils'
require 'time'

# def route_path(item)
#   # in-memory items have not file
#   return item.identifier + "index.html" if item[:content_filename].nil?
  
#   url = item[:content_filename].gsub(/^content/, '')
 
#   # determine output extension
#   extname = '.' + item[:extension].split('.').last
#   outext = '.haml'
#   if url.match(/(\.[a-zA-Z0-9]+){2}$/) # => *.html.erb, *.html.md ...
#     outext = '' # remove 2nd extension
#   elsif extname == ".sass"
#     outext = '.css'
#   else
#     outext = '.html'
#   end
#   url.gsub!(extname, outext)
  
#   if url.include?('-')
#     url = url.split('-').join('/')  # /2010/01/01-some_title.html -> /2010/01/01/some_title.html
#   end

#   url
# end

def pretty_time(time)
	Time.parse(time).strftime("%b %d, %Y") if !time.nil?
end

def articles_by_year(year)
	@pages.select { |page| page.kind == 'article'}
	
	select { |page| page.created_at.year == year}
	sort_by { |page| page.created_at}
	reverse
end

def articles_by_year_month
  result = {}
  current_year = current_month = year_h = month_a = nil

  sorted_articles.each do |item|
    d = Date.parse(item[:created_at])
    if current_year != d.year
      current_month = nil
      current_year = d.year
      year_h = result[current_year] = {}
    end

    if current_month != d.month
      current_month = d.month
      month_a = year_h[current_month] = [] 
    end

    month_a << item
  end

  result
end

def is_front_page?
    @item.identifier == '/'
end
