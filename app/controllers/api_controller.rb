class ApiController < ApplicationController
  respond_to :json

  @@docker_client = DockerClient::Socket.new

  def index
    respond_with @@docker_client.get("/#{self.controller_name}/json")
  end
end
