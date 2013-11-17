#It defines the getLegislationParsedForTitle(title) method
require 'legislation_api'
include LegislationApi

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
    @legislation = getLegislationParsedForTitle(legislation_title)
    # getClausesFromBillVersion(bill_url)
  end

end
