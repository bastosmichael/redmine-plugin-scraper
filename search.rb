#!/usr/bin/env ruby
require 'mechanize'
require 'nokogiri'
require 'uri'
require 'ap'

class Mechanize::Page
  def resolve_url(url)
    if url.nil?
      url = []
    end
    mech.agent.resolve(url,self).to_s
  end
end

module Scrape
	class Scrape
		def initialize
			@agent = new_agent_with_default_attributes
			@site = "http://www.redmine.org/plugins"
			1.upto(40) do |number|
     			page = @agent.get("#{@site}?page=#{number}")
     			page.search('a.plugin').map do |link|
					url = page.resolve_url(link[:href])
					plugin = @agent.get(url)
					puts "#{link.text}	#{url}	#{plugin.search('//*[@id="content"]/div[2]/div[1]/p/text()').first}	#{plugin.search('//em/text()').first}"
				end
   			end
		end

		def new_agent_with_default_attributes
		    agent = Mechanize.new
		    agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.43 Safari/536.11'
		    agent.open_timeout = 300
		    agent.read_timeout = 300
		    agent.html_parser = Nokogiri::HTML
		    agent.ssl_version = 'SSLv3'
		    agent.keep_alive = true
		    agent.idle_timeout = 300
		    agent.max_history = 10
		    return agent
		  end
	end
end

Scrape::Scrape.new

