module WikisHelper
    def build_the_json(params)
    uri = (params[:url].empty? ? URI.parse("http://en.wikipedia.org/wiki/Internet") : URI.parse(params[:url]))
    search_text = (params[:search].empty? ? Regexp.new("internet", Regexp::IGNORECASE) : Regexp.new(params[:search], Regexp::IGNORECASE))
    replace_text = (params[:replace].empty? ? "Al Gore" : params[:replace])

    content = Net::HTTP.get_response(uri).body.force_encoding("UTF-8")
    { content: content.gsub(search_text, replace_text) }
  end
end
