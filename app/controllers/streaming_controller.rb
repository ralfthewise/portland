require 'pty'

class StreamingController < ApplicationController
  include Tubesock::Hijack

  def attach
    hijack do |tubesock|
      #master = slave = read = write = pid = pty_reader = nil
      pty_read = pty_write = pid = pty_reader = nil

      tubesock.onopen do
        Rails.logger.info('terminal opened')
        #master, slave = PTY.open
        #read, write = IO.pipe
        #pid = spawn('bash -l', in: read, out: slave)
        #read.close
        #slave.close
        pty_read, pty_write, pid = PTY.spawn("docker attach #{params[:container_id]}")

        pty_reader = Thread.new do
          Thread.current.abort_on_exception = true
          while data = read_data(pty_read) do
            Rails.logger.info("sending data: #{data}")
            tubesock.send_data(data)
          end
        end
      end

      tubesock.onmessage do |data|
        Rails.logger.info("received data: #{data}")
        #write.puts(data)
        pty_write.write(data)
      end

      tubesock.onclose do
        Rails.logger.info('terminal closed')
        pty_reader.kill
        #write.close
        Process.kill('INT', pid)
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
end
