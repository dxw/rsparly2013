#It defines the getLegislationParsedForTitle(title) method
require 'legislation_api'
include LegislationApi
require 'diff_bill'
include DiffBill
require 'debates'

#This is just for the simple_format...
#require 'action_view/helpers/text_helper'

class LegislationsController < ApplicationController
  #This is just for the simple_format...
  #include ActionView::Helpers::TextHelper

  def index
    @legislations = Legislation.all
  	@mdoc = getLegislationParsedForTitle
  end

  def show
    legislation_title = 'Marriage (Same Sex Couples) Act 2013'
    house = :lords
    debate_url = "http://www.publications.parliament.uk/pa/ld201314/ldhansrd/text/130624-0001.htm#13062413000429"
    bill_url = 'http://services.parliament.uk/bills/2013-14/marriagesamesexcouplesbill/documents.html'


    # @clauses = getLegislationParsedForTitle(params[:id])


    previous_versions = getVersionsOfBillFromUrl(bill_url)

    # skip the first for the moment:
    previous_versions.shift

    previous_clauses = previous_versions.map do |bill_version|
      clauses = getClausesFromBillVersion(bill_version)
    end

    # # Add in the amendments for each clause
    @amendments = Debates.new.amendment_debates_from_url(house, debate_url)
    # @clauses.each do |l|
    #   l[:amendments] = amendments
    # end
  end
end
