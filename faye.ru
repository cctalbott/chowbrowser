require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)

Faye::WebSocket.load_adapter('thin')

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token.'
      end
    end
    callback.call(message)
  end
end

faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
faye_server.add_extension(ServerAuth.new)
faye_server.listen(9292,
  :key  => '/etc/ssl/localcerts/chowbrowser-comodo.key',
  :cert => '/etc/ssl/localcerts/comodo-ssl-bundle.crt'
)
run faye_server
