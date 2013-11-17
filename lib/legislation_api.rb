# encoding: utf-8
require 'net/http'
require 'nokogiri'
require 'open-uri'
#require 'action_view/helpers/text_helper'

module LegislationApi
	#include ActionView::Helpers::TextHelper

	def getLegislationParsedForTitle(title='Marriage (Same Sex Couples) Act 2013')
	    
	    title = URI.escape(title)

	  	url = URI.parse('http://www.legislation.gov.uk/id?title='+title)
		req = Net::HTTP::Get.new(url)
		res = Net::HTTP.start(url.host, 80) {|http|
	  		http.request(req)
		}

		uri = res.header["location"].gsub('/id','')

		doc = Nokogiri::HTML(open('http://legislation.data.gov.uk'+uri+'/data.htm'))

	    clauses = []
	    clauses_doc = doc.css('.LegBlockNotYetInForce')
	    clauses_doc.each do |clause_doc|
	    	clause = { contents: [] }
	    	clause_doc.children.css('.LegP1ContainerFirst','.LegP1Container, .LegP2Container, .LegP3Container').each do |p|

	    		content = {}

	    		classes = p.attr(:class).split(" ")
	    		puts classes.inspect
	    		if classes.include?("LegP1Container") or classes.include?("LegP1ContainerFirst")
	    			content[:type] = :title
	    			content[:text] = p.css('.LegP1GroupTitleFirst').text
	    			content[:no] = p.css('.LegP1No').text
	    		elsif classes.include?("LegP2Container") or classes.include?("LegP3Container")
	    			content[:type] = :paragraph
	    			content[:text] = p.css('.LegRHS').text
	    			content[:no] = p.children.first.text
	    		end

	    		clause[:contents] << content

	    	end
	    	clauses << clause
	    end

	    return clauses
	    # doc = ReverseMarkdown.parse doc 
	    # doc = doc.split(%r{^#### })
	    
	    #simple_format(doc)

	    #markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true, :tables => true)
	    #@mdoc = markdown.render(doc.to_s).html_safe
	end

end