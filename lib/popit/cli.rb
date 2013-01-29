# require 'subcommand'
require 'ap'
require 'pry'
require 'popit/send'
require 'popit/receive'

require_relative '../subby/subby'

module PopIt
  class CLI

    def start

      # ap ARGV

      subby = Subby.setup do
        # switch :verbose, 'Verbose mode'
        # switch :dry_run, 'Dry run mode'
        parameter :count, 'Count times', format: /\d+/, required: true

        command :receive do
          description 'Receive bumps'
          parameter :server, 'Server to connect to', format: /^http/, required: true
        end

        command :send do
          description 'Send bumps'
          parameter :server, 'Server to connect to', format: /^http/, required: true
          parameter :key, 'Key to use', format: /^\w+-\w+-\w+-\w+-\w+$/, required: true
        end
      end

      case subby.command.name
        when :receive
          ap subby
          # PopIt::Receive.new(subby.command.options[:server].value).receive

        when :send
          data = STDIN.read

          PopIt::Send.new(
            subby.command.options[:server].value,
            subby.command.options[:key].value,
            data
          ).send

      end
    end
  end
end
