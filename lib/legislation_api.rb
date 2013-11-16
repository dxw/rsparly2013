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
	    doc.search('.LegExtentRestriction','.LegPrelim','.LegBlockNotYetInForceHeading','h1','h2','h3').remove
	    doc = ReverseMarkdown.parse doc 
	    doc = doc.split(%r{^#### })
	    
	    #simple_format(doc)

	    #markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true, :tables => true)
	    #@mdoc = markdown.render(doc.to_s).html_safe
	end

end