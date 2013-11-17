# encoding: utf-8
require 'nokogiri'
require 'open-uri'

module DiffBill
	#usage getVersionsOfBillFromUrl('http://services.parliament.uk/bills/2013-14/marriagesamesexcouplesbill/documents.html')
	def getVersionsOfBillFromUrl(url)
		# Add error control
		doc = Nokogiri::HTML(open(url))

		vBills = []

		items = doc.search('.bill-items')[0 .. 2]
		items.each do |table|

			table.children.css('.tr1','.tr2').each do |bill|
				vBill = {}

				vBill[:date] = bill.css('.bill-item-date').text

				bill.children.css('.bill-item-description').each do |info|
					info.css('.application-pdf').remove
					vBill[:url] = info.children.search('a')[0]['href']
					vBill[:title] = info.text.gsub(%r/\r\n/,'').gsub(" | ",'')
				end

				vBills << vBill
	    	end
		end

		return vBills
	end
end