class DockerEventStream
  @read_timeout = 60 * 60 * 24 * 24 #24 days, largest Net::HTTP allows

  def self.stream_events
    uri = URI('http://localhost/docker/events')

    Net::HTTP.start(uri.host, uri.port, read_timeout: @read_timeout) do |http|
      request = Net::HTTP::Get.new uri.request_uri

      http.request request do |response|
        response.read_body do |event|
          event = JSON.parse(event)
          WebsocketRails[:docker_events].trigger('new', event)
        end
      end
    end
  end
end
