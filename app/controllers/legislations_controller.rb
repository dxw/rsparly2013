#It defines the getLegislationParsedForTitle(title) method
require 'legislation_api'
include LegislationApi
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
    # bill_url = 'http://services.parliament.uk/bills/2013-14/marriagesamesexcouplesbill/documents.html'
    legislation_title = 'Marriage (Same Sex Couples) Act 2013'

    house = :lords
    debate_url = "http://www.publications.parliament.uk/pa/ld201314/ldhansrd/text/130624-0001.htm#13062413000429"

    @clauses = getLegislationParsedForTitle(legislation_title)

    # Add in the amendments for each clause
    amendments = Debates.new.amendment_debates_from_url(house, debate_url)
    @clauses.each do |l|
      l[:amendments] = amendments
    end
  end

end
