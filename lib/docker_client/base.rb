module DockerClient
  class Base
    include HTTParty
    format :json

    def get(*args)
      return self.class.get(*args)
    end
  end
end
