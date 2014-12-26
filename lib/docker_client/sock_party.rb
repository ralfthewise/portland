#taken from https://gist.github.com/tylergannon/7690997

require 'net/http'
require 'socket'

module Net
  #  Overrides the connect method to simply connect to a unix domain socket.
  class SocketHttp < HTTP
    attr_reader :socket_path

    #  URI should be a relative URI giving the path on the HTTP server.
    #  socket_path is the filesystem path to the socket the server is listening to.
    def initialize(uri, socket_path)
      @socket_path = socket_path
      super(uri)
    end

    #  Create the socket object.
    def connect
      @socket = Net::BufferedIO.new UNIXSocket.new socket_path
      on_connect
    end

    #  Override to prevent errors concatenating relative URI objects.
    def addr_port
      File.basename(socket_path)
    end
  end
end

module DockerClient
  class SockParty < HTTParty::ConnectionAdapter
    #  Override the base class connection method.
    #  Only difference is that we'll create a Net::SocketHttp rather than a Net::HTTP.
    #  Relies on :socket_path in the options
    def connection
      http = Net::SocketHttp.new(uri, options[:socket_path])

      if options[:timeout] && (options[:timeout].is_a?(Integer) || options[:timeout].is_a?(Float))
        http.open_timeout = options[:timeout]
        http.read_timeout = options[:timeout]
      end

      if options[:debug_output]
        http.set_debug_output(options[:debug_output])
      end

      if options[:ciphers]
        http.ciphers = options[:ciphers]
      end

      return http
    end
  end
end
