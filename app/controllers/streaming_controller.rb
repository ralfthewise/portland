require 'pty'

class StreamingController < ApplicationController
  include Tubesock::Hijack

  #be very careful of turning this on and then attaching/tailing the logs from a web browser, it creates infinite logging
  @@verbose_logging = false

  def attach
    hijack do |tubesock|
      pty_read = pty_write = pid = pty_reader = nil

      tubesock.onopen do
        log('terminal opened')
        pty_read, pty_write, pid = PTY.spawn("docker attach #{params[:container_id]}")
        #pty_read, pty_write, pid = PTY.spawn("bash -l")

        pty_reader = Thread.new do
          Thread.current.abort_on_exception = true
          while data = read_data(pty_read) do
            log("sending data: #{data}")
            tubesock.send_data(data)
          end
        end
      end

      tubesock.onmessage do |data|
        log("received data: #{data}")
        pty_write.write(data)
      end

      tubesock.onclose do
        log('terminal closed')
        pty_reader.kill
        Process.kill('KILL', pid)
      end
    end
  end

  protected
  def read_data(io)
    ready = IO.select([io])
    ready[0][0].read_nonblock(1048576)
  rescue Exception => e
    Rails.logger.error("Error: #{e}")
    nil
  end

  def log(message)
    Rails.logger.info(message) if @@verbose_logging
  end
end
