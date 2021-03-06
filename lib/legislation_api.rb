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

    doc = Nokogiri::HTML(open(url))

    doc.css('.LegExtentRestriction, .LegPrelims, .LegBlockNotYetInForceHeading, h1, h2, h3').remove

    doc = ReverseMarkdown.parse doc
    doc = doc.gsub(/#{"^\n\n####"}/, "").split(%r{^#### })

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true, :tables => true)
    doc = doc.map do |clause|
      { text: markdown.render(clause.to_s).html_safe }
    end
    return doc
  end

end