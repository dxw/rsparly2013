# encoding: utf-8
require 'nokogiri'
require 'open-uri'

require 'legislation_api'
include LegislationApi

module DiffBill

	def getDiffsFromUrl(url)
		bills_clauses = previous_versions.map do |bill_version|
      getClausesFromBillVersion(bill_version)
    end

    diffs =[]
    for i in 0..(bills_clauses-2)

    	diffs_for_bill_version = bills_clauses[i].select do |clause|
    		previous_version_of_clause = bills_clauses[i+1].find{ |c| c[:title] == clause[:title] }
    		return true if (previous_version_of_clause).nil?

    		# Select the elements where the diff isn't nil:
    		!diff(clause[:text], previous_version_of_clause[:text])
    	end

    	diffs << diffs_for_bill_version

    end

  end



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

			title=bill[:title][/(.*\d\d\d\d)\s.*/,1]
			title = URI.escape(title)

			url = URI.parse('http://www.legislation.gov.uk/id?title='+title)

			req = Net::HTTP::Get.new(url)
			res = Net::HTTP.start(url.host, 80) {|http|
				http.request(req)
			}

			uri = res.header["location"].gsub('/id','')

			doc = Nokogiri::HTML(open('http://legislation.data.gov.uk'+uri+'/data.htm'))

			doc.css('.LegExtentRestriction, .LegPrelim, .LegBlockNotYetInForceHeading, h1, h2, h3').remove
			doc = ReverseMarkdown.parse doc
			doc = doc.split(%r{^#### })

		else

			doc = Nokogiri::HTML(open(url))
			#urlbase = url[/.*\/([\w-]+)\d+.htm/,1]

			pag = []

			doc.search('.LegContentsPart').children.search('a').each do |clauseAnchor|
				val = clauseAnchor['href'][/[\w-]+(\d+).htm\#?.*/,1]
				pag << val unless pag.include? val
			end

			fullBill = ""

			pag.each do |nr|
				url = url.gsub(/(.*\/[\w-]+)\d+.htm/,'\1')+nr+'.htm'
				doc = Nokogiri::HTML(open(url))
				doc = doc.search('.LegContent')[0]
				doc.search('.newPage').remove
				doc.search('.chunkPage').remove
				doc.search('.noteLink').remove
				doc.search('.LegClearPart').remove
				doc.search('.LegPrelims').remove
				doc.search('h2').remove
				doc.search('h3.LegPblock').remove
				doc.search('.linenumber').remove
				fullBill += doc.to_s
			end

			doc = Nokogiri::HTML(fullBill)
			doc = ReverseMarkdown.parse doc 
			doc = doc.split(%r{^\#?\#\#\# })

			#doc.search('.LegP1ContainerFirst').each do |clause|
			#end


			# # while doc.at('h1:last') and doc.at('h1:last').text.include? 'SCHEDULE'
			# # 	#this should remove the schedules...
			# # 	while node = doc.at('h1:last').next
			# #  	  node.remove
			# # 	end
			# # 	doc.at('h1:last').remove
			# # end
		end

		clauses = []

		if doc 
			doc.each do |clauseunedited|
				clause={}
				clause[:no] = clauseunedited[/\A(\d+)\s/,1]
				clause[:title] = clauseunedited[/\A\d+\s([\w\s\-:;\."“”]+)\n\n/,1]
				clause[:text] = clauseunedited.gsub(/\A\d+\s[\w\s\-:;\."“”]+\n\n/,'')
				clauses << clause
			end
		end

		return clauses
	end
end