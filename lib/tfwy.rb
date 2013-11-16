require 'twfy'

class Tfwy
  # Example:
  # Tfwy.new.debates_from_url(:commons, "http://www.publications.parliament.uk/pa/cm201314/cmhansrd/cm130521/debtext/130521-0002.htm")

  def client
    @client ||= Twfy::Client.new(Figaro.env.theyworkforyou_api_key)
  end

  def debates_from_url(type, url)
    raise %{Type must be either "commons" or "lords"} unless ["commons", "lords"]

    url = client.convert_url(url: url)
    gid = url.id

    client.debates(type: type.to_s, gid: gid)
    # API Definition
    # getDebates: {
    #     require: :type,
    #     require_one_of: [:date, :person, :search, :gid],
    #     allow_dependencies: {
    #       search: [:order, :page, :num],
    #       person: [:order, :page, :num]
    #     }
    #   },

  end

  private

  class URI::HTTP
    def id
      CGI::parse(query)["id"].first
    end
  end

end

