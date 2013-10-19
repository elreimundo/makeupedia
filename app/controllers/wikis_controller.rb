require 'net/http'

class WikisController < ApplicationController

  def create
    ## hard-code
    uri = URI.parse("http://en.wikipedia.org/wiki/Internet")
    search_text = Regexp.new("the",Regexp::IGNORECASE)
    replace_text = "and"

    @page = Page.create(:url => params[:url])
    @change = Change.create(:find_text => params[:search], :replace_text => params[:replace])

    content = Net::HTTP.get_response(uri).body
    content.force_encoding("UTF-8")

    content_replaced = content.gsub(search_text, replace_text)

    data = { content: content_replaced }
    render json: data.to_json
  end

end
