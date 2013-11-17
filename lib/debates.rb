require 'twfy'

class Debates
  # Example:

  #Simple (replace last digit with 2)
  # Debates.new.debate_from_url(:lords, "http://www.publications.parliament.uk/pa/ld201314/ldhansrd/text/130624-0001.htm#13062413000429")
  # Debates.new.amendment_debates_from_url(:lords, "http://www.publications.parliament.uk/pa/ld201314/ldhansrd/text/130624-0001.htm#13062413000429")

  # List (select relevant thing from list)
  # Debates.new.debate_from_url(:commons, "http://www.publications.parliament.uk/pa/cm201314/cmhansrd/cm130520/debtext/130520-0002.htm#13052013000002")

  #
  # Debates.new.debate_from_url(:commons, "http://www.publications.parliament.uk/pa/cm201314/cmhansrd/cm130521/debtext/130521-0002.htm#13052156000001")
  # Debates.new.amendments_from_url_with_indexes(:commons, "http://www.publications.parliament.uk/pa/cm201314/cmhansrd/cm130521/debtext/130521-0002.htm#13052156000001")


  def client
    # @client ||= Twfy::Client.new(Figaro.env.theyworkforyou_api_key)
    Twfy::Client.new(Figaro.env.theyworkforyou_api_key)
  end

  def amendments_from_debate(debate_array)
    debate_array.map{|a| a.body.match(/<b>(\d+[A-Z]*):<\/b>+/)}.compact.map{|x| x[1]}
  end

  def amendments_from_debate_with_indexes(debate_hash)
    foo = []
    # debate_hash.map{|a| a.body}.each_with_index{|body, i| m = body.match(/<b>(\d+[A-Z]*):<\/b>+/);  foo << {amendment_number: m[1], index: i} if m }.compact
    debate_hash.map{|a| a.body}.each_with_index{|body, i| m = body.match(/<b>(\d+[A-Z]*):<\/b>([^,]+),+/);  foo << { amendment_number: m[1], referenced_part: m[2].gsub("After",'').strip, index: i } if m }.compact

    return foo
    # OUTPUT = e.g.
  end

  def amendments_from_url_with_indexes(type, url)
    debate_array = debate_from_url(type, url)
    amendments_from_debate_with_indexes(debate_array)
  end


  def amendment_debate(amendment, debate_array, amendments_from_debate_with_indexes)
    amendments_from_debate_with_indexes.each_with_index do |amendment_index_hash, n|
      if amendment == amendment_index_hash[:amendment_number]
        @start_index = amendment_index_hash[:index]
        @end_index = 10000000000 # can't be bothered to calculate the actual length
        next_element = amendments_from_debate_with_indexes[n+1]
        @end_index = next_element[:index] unless next_element.nil?
      end
    end

    raise "Start index is nil!" if @start_index.nil?
    raise "End index is nil!" if   @end_index.nil?
    debate_array[@start_index..@end_index]
  end

  def amendment_debates_from_url(type, url)
    debate_array = debate_from_url(type, url)
    afdwi = amendments_from_debate_with_indexes(debate_array)
    afdwi.collect {|amendment_hash| amendment_debate(amendment_hash[:amendment_number], debate_array, afdwi)}
  end

  def debate_from_url(type, url)
    raise %{Type must be either :commons or :lords} unless [:commons, :lords].include?(type)

    gid = gid_from_url(type, url)

    begin
      client.debates(type: type.to_s, gid: gid)
      # API Definition:
      # getDebates: {
      #   require: :type,
      #   require_one_of: [:date, :person, :search, :gid],
      #   allow_dependencies: {
      #     search: [:order, :page, :num],
      #     person: [:order, :page, :num]
      #   }
      # }
    rescue OpenURI::HTTPError => e
      raise %{OpenURI::HTTPError #{e.message}

You tried to get the following debate:
-- gid:  #{gid}
-- type: #{type.to_s}

}
    end
  end

  def gid_from_url(type, url)
    # converted_url = client.convert_url(url: url)
    # interim_gid = converted_url.id

    interim_gid = "2013-06-24a.507.2"

    # CASE 1 - simple
    if false
      # WHAT'S THE CONDITION HERE????


      # Until we work out how to do this properly, assume it's just
      #  'replace the last digit chunks with a 2'
      gid = interim_gid.sub(/\.\d+$/,".2") if convert

    # CASE 2 - Multiple bills on the page
    elsif false
      # WHAT'S THE CONDITION HERE????
      gid = client.debates(type: type.to_s, gid: interim_gid)
      # In this case, delete anything which isn't nil or a big number
    else
      gid = interim_gid
    end

    gid

  end


  # CASE1:
  # Content count + a load of nils = trash anything before it


  private

  class URI::HTTP
    def id
      CGI::parse(query)["id"].first
    end
  end

end

