require 'json'

module PopIt
  class Send

    def initialize key, data
      @key = key
      @data = data
    end

    def send
      headers = { 'Content-Type' => 'application/json' }
      HTTParty.post url, :body => { channel: channel, data: @data }.to_json, :headers => headers
    end

    private

    def url
      "#{PopIt::BASE_URL}/messages"
    end

    def channel
      "/messages/#{@key}"
    end
  end
end
