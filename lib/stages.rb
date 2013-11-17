require 'nokogiri'
require 'open-uri'

class Stages
  # "Marriage (Same Sex Couples) Act 2013"
  def stages_for_act(act_name)
    doc = Nokogiri.XML(open("data/20131114120038_2013-14.xml"))

    bill = doc.css('bill[shorttitle="Marriage (Same Sex Couples) Act 2013"]')

    stages = bill.css('stage publication').map do |p|
      d = p["date"]
      date = Date.parse("20#{d[6..7]}-#{d[3..4]}-#{d[0..1]}")

      {
        stage: p["teaser"],
        house: p["house"],
        date:  date,
        url:   p.css('url').text
      }
    end

    stages.select{|s| !s[:stage].empty? }.sort{|a,b| a[:date] <=> b[:date]}
  end
end