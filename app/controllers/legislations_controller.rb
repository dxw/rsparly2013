#It defines the getLegislationParsedForTitle(title) method
require 'legislation_api'
include LegislationApi

#This is just for the simple format...
require 'action_view/helpers/text_helper'

class LegislationsController < ApplicationController
  #This is just for the simple format...
  include ActionView::Helpers::TextHelper

  def index
    @legislations = Legislation.all
  	@mdoc = simple_format(getLegislationParsedForTitle)
  end

  def show
    @legislation = Legislation.find(params[:id])
  end

end
