require 'slop'
require 'popit/send'
require 'popit/receive'

module PopIt
  class CLI

    def self.start

      Slop.parse do

        command 'receive' do
          run do |o, args|
            PopIt::Receive.new.receive
          end
        end

        command 'send' do
          on :key=, 'Key to send to'

          run do |o, args|

            opts = o.to_hash

            unless data = STDIN.read
              puts "Enter in your content and hit CTRL-D to finish"
            end

            PopIt::Send.new(opts[:key], data).send
          end
        end
      end
    end
  end
end
