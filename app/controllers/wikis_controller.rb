class WikisController < ApplicationController

  def new
    uri = params[:url]
    puts "params *********************************"
    puts params ## {"utf8"=>"✓", "url"=>"", "search"=>"", "replace"=>"", "commit"=>"Submit", "action"=>"new", "controller"=>"wikis"}
    puts params["url"]
    uri = URI.parse("http://en.wikipedia.org/wiki/Internet")

    content = Net::HTTP.get_response(uri).body
    content.force_encoding("UTF-8")

    data = { content: content }
    #p data
    #Hash[data].each {|k,v| puts "#{k}: #{v[0..100]}"}
    render json: data.to_json
    #render :json => "we good!", :status => :ok
  end


end
