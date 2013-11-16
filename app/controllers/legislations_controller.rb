#It defines the getLegislationParsedForTitle(title) method
require 'legislation_api'
include LegislationApi

#This is just for the simple_format...
#require 'action_view/helpers/text_helper'

class LegislationsController < ApplicationController
  #This is just for the simple_format...
  #include ActionView::Helpers::TextHelper

  def index
  	@mdoc = getLegislationParsedForTitle
  end

  def show
  end

end
