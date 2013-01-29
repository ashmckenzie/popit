require 'json'

module PopIt
  class Send

    def initialize server, key, data
      @server = server
      @key = key
      @data = data
    end

    def send
      headers = { 'Content-Type' => 'application/json' }
      HTTParty.post url, :body => { channel: channel, data: @data }.to_json, :headers => headers
    end

    private

    def url
      "#{@server}/messages"
    end

    def channel
      "/messages/#{@key}"
    end
  end
end
