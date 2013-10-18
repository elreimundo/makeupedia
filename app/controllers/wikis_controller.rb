require 'net/http'

class WikisController < ApplicationController

  def new
    data = build_the_json(params)
    render json: data.to_json
  end

end
