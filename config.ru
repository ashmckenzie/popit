require 'bundler'
Bundler.setup

require 'sinatra/base'
require 'faye'
require 'uuid'

require File.expand_path(File.join('..', 'app'), __FILE__)

# class ServerAuth
#   def incoming(message, callback)
#     # if message['channel'] !~ %r{^/meta/}
#     #   if message['ext']['auth_token'] != 'bleep'
#     #     message['error'] = 'Invalid authentication token'
#     #   end
#     # end
#     callback.call(message)
#   end
# end

Faye::WebSocket.load_adapter('thin')
use Faye::RackAdapter, :mount      => '/messages',
                       :timeout    => 45
                       # :extensions => [ ServerAuth.new ]

run App
