require 'net/http'

module WikisHelper
  def build_the_search(params)
    params[:search_page].gsub(" ","_")
  end

  def build_the_json(params)
    title_uri = "http://en.wikipedia.org/" + build_the_search(params)
    @data = {
              uri: (params[:search_page].empty? ? URI.parse("http://en.wikipedia.org/wiki/Internet") : URI.parse(title_uri)),
              search_text: (params[:search].nil? ? "" : Regexp.new(params[:search], Regexp::IGNORECASE)),
              replace_text: (params[:replace].nil? ? "" : params[:replace])
            }
    build_the_page
  end

  def build_the_page
    content = Net::HTTP.get_response(@data[:uri]).body.force_encoding('UTF-8')
    object_to_break = Nokogiri::HTML(content)
    break_the_object(object_to_break)
    { content: object_to_break.serialize(:encoding => 'UTF-8') }
  end

  def break_the_object(node)
    return node.content = node.content.to_s.gsub(@data[:search_text],@data[:replace_text]) if node.children.empty? && node.text?
    node.children.each{|e| break_the_object(e)} unless node.children.empty?
  end
end
