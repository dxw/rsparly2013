require 'twfy'

class Debates
  # Example:
  # Debates.new.debate_from_url(:lords, "http://www.publications.parliament.uk/pa/ld201314/ldhansrd/text/130624-0001.htm#13062413000429")

  def client
    @client ||= Twfy::Client.new(Figaro.env.theyworkforyou_api_key)
  end

  def debate_from_url(type, url)
    raise %{Type must be either :commons or :lords} unless [:commons, :lords].include?(type)

    url = client.convert_url(url: url)
    gid = url.id

    # Until we work out how to do this properly, assume it's just
    #  'replace the last digit chunks with a 2'
    whole_debate_gid = gid.sub(/\.\d+$/,".2")

    begin
      client.debates(type: type.to_s, gid: whole_debate_gid)
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
-- gid:  #{whole_debate_gid}
-- type: #{type.to_s}

}
    end
  end

  private

  class URI::HTTP
    def id
      CGI::parse(query)["id"].first
    end
  end

end

