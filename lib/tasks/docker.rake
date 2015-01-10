# -*- mode: ruby -*-
# vi: set ft=ruby :

namespace :docker do
  desc 'Stream docker events to clients via websockets - ex: rake docker:stream_events'
  task stream_events: :environment do
    DockerEventStream.stream_events
  end
end
