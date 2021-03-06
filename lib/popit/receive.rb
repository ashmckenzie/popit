module PopIt
  class Receive

    def initialize server
      @server = server
      @key = get_new_key
      puts "Your key is #{@key}"
    end

    def receive
      EM.run do
        faye = Faye::Client.new(url)

        faye.subscribe channel do |message|
          puts '-' * 80
          puts message
          puts '-' * 80
        end
      end
    end

    private

    def get_new_key
      HTTParty.post new_key_url, :body => { uuid: UUID.generate }
    end

    def new_key_url
      "#{@server}/key/new"
    end

    def url
      "#{@server}/messages"
    end

    def channel
      "/messages/#{@key}"
    end
  end
end
