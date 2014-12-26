require 'docker_client/sock_party'

module DockerClient
  class Socket < Base
    self.default_options = {connection_adapter: SockParty, socket_path: PortlandConfig[:docker_client_socket]}
  end
end
