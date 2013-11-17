require 'debates'

class DebatesController < ApplicationController

  def show
    # How to get these for reals???
    # Hardcoded for the time being:
    house = :lords
    parly_url = "http://www.publications.parliament.uk/pa/ld201314/ldhansrd/text/130624-0001.htm#13062413000429"

    amendments = Debates.new.amendment_debates_from_url(house, parly_url)

    amendment = amendments.find{|a| a[:amendment_number] == params[:id]}

    @debate = amendment[:debate] # Get at the html
    @amendment_number = amendment[:amendment_number]

  end

end