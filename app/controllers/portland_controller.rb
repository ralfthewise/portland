class PortlandController < ApplicationController
  def app
    render 'app', layout: 'marionette_app'
  end
end
