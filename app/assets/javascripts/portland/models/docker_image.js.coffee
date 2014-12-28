class Portland.Models.DockerImage extends Portland.Models.Base
  idAttribute: 'Id'
  url: -> "/docker/images/#{@get('Id')}/json"

class Portland.Collections.DockerImage extends Portland.Collections.Base
  model: Portland.Models.DockerImage
  url:"/docker/images/json"
