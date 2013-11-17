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
		url = bill[:url]

		if url.include? 'legislation.gov.uk'
			
			puts 'This is the final bill, use LegislationAPI'

		else
			
			doc = Nokogiri::HTML(open(url))
			#urlbase = url[/.*\/([\w-]+)\d+.htm/,1]

			pag = []

			doc.search('.LegContentsPart').children.search('a').each do |clauseAnchor|
				val = clauseAnchor['href'][/[\w-]+(\d+).htm\#?.*/,1]
				pag << val unless pag.include? val
			end

			clauses = []

			pag.each do |nr|
				url = url.gsub(/(.*\/[\w-]+)\d+.htm/,'\1')+nr+'.htm'
				doc = Nokogiri::HTML(open(url))
				doc = doc.search('.LegContent')[0]
				doc.search('.newPage').remove
				doc.search('.chunkPage').remove
				doc.search('h2','h3').remove

				while doc.at('h1:last') and doc.at('h1:last').text.include? 'SCHEDULE'
					#this should remove the schedules...
					while node = doc.at('h1:last').next
				 	  node.remove
					end
					doc.at('h1:last').remove
				end

				doc.search('h1').remove


				doc = ReverseMarkdown.parse doc 
	    		doc = doc.split(%r{^#### })
	    		doc.each do |clauseunedited|
	    			clause={}
	    			clause[:no] = clauseunedited[/\A(\d+\w+)\s/,1]
	    			clause[:text] = clauseunedited.gsub(%r/\A\d+\w+\s/,'')
	    			clauses << clause unless !clause[:no]
	    		end
			end

			return clauses
		end
	end
end