# encoding: utf-8
require 'nokogiri'
require 'open-uri'

module DiffBill
	#usage getVersionsOfBillFromUrl('http://services.parliament.uk/bills/2013-14/marriagesamesexcouplesbill/documents.html')
	def getVersionsOfBillFromUrl(url)
		# Add error control
		doc = Nokogiri::HTML(open(url))

		vBills = []

		items = doc.search('.bill-items')[0 .. 1]
		items.each do |table|

			table.children.css('.tr1','.tr2').each do |bill|
				vBill = {}

				vBill[:date] = bill.css('.bill-item-date').text

				bill.children.css('.bill-item-description').each do |info|
					info.css('.application-pdf').remove
					vBill[:url] = info.children.search('a')[0]['href']
					vBill[:title] = info.text.gsub(%r/\r\n/,'').gsub(" | ",'')
				end

				vBills << vBill unless vBill[:title].include? 'mendments'

	    	end
		end

		return vBills
	end

	def getClausesFromBillVersion(bill)
		if url.include? 'legislation.gov.uk'
			puts 'This is the final bill'
		else
			doc = Nokogiri::HTML(open(bill[:url]))
			urlbase = url[/.*\/([\w-]+)\d+.htm/,1]
			doc.search('.LegContentsPart').children.search('a').each do |clauseAnchor|
				puts  clauseAnchor
			end
		end
	end
end