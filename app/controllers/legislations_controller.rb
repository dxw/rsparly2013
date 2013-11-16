require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'action_view/helpers/text_helper'

class LegislationsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
  	title = URI.escape('Marriage (Same Sex Couples) Act 2013')
  	url = URI.parse('http://www.legislation.gov.uk/id?title='+title)
	req = Net::HTTP::Get.new(url)
	res = Net::HTTP.start(url.host, 80) {|http|
  		http.request(req)
	}

	uri = res.header["location"].gsub('/id','')

	doc = Nokogiri::HTML(open('http://legislation.data.gov.uk'+uri+'/data.htm'))
    doc.search('.LegExtentRestriction').remove
    @mdoc = ReverseMarkdown.parse doc 
    @mdoc = simple_format(@mdoc)

    #markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true, :tables => true)
    #@mdoc = markdown.render(doc.to_s).html_safe
  end

  def show
  end

end
