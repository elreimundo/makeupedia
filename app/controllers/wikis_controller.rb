class WikisController < ApplicationController

  def new
    uri = URI.parse(params[:url])
    search_text = Regexp.new(params[:search], Regexp::IGNORECASE)
    replace_text = params[:replace]

    ## hard-code
    uri = URI.parse("http://en.wikipedia.org/wiki/Internet")
    search_text = Regexp.new("the",Regexp::IGNORECASE)
    replace_text = "and"


    content = Net::HTTP.get_response(uri).body
    content.force_encoding("UTF-8")

    puts content.class
    puts search_text
    puts replace_text
    content_replaced = content.gsub(search_text, replace_text)

    data = { content: content_replaced }
    render json: data.to_json
  end

end
