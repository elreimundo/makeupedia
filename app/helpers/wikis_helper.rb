require 'net/http'

module WikisHelper
  def build_the_json(params)
    @data = {uri: (params[:url].empty? ? URI.parse("http://en.wikipedia.org/wiki/Internet") : URI.parse(params[:url])),
    search_text: (params[:search].empty? ? Regexp.new("internet", Regexp::IGNORECASE) : Regexp.new(params[:search], Regexp::IGNORECASE)),
    replace_text: (params[:replace].empty? ? "Al Gore" : params[:replace])}

    build_the_page
  end

  def build_the_page
    object_to_break = parse_the_page(@data[:uri])
    break_the_object(object_to_break)
    wrap(object_to_break)
  end

  def break_the_object(node)
    return node.content = node.content.to_s.gsub(@data[:search_text],@data[:replace_text]) if node.children.empty? && node.text?
    node.children.each{ |e| break_the_object(e) } unless node.children.empty?
  end

  def parse_the_page(page)
    Nokogiri::HTML(Net::HTTP.get_response(page).body.force_encoding('UTF-8'))
  end

  def apply_lots_of_changes(params)
    page = Page.find(params[:id])
    page_user = PageUser.where('page_id=?', page.id).where('user_id=?',params[:user_id].to_i).first
    nokogiri_object = parse_the_page(URI.parse(page.url))
    page_user.changes.each do |change|
      @data = {search_text: Regexp.new(change.find_text, Regexp::IGNORECASE), replace_text: change.replace_text}
      break_the_object(nokogiri_object)
    end
    wrap(nokogiri_object)
  end

  def wrap(object)
    {content: object.serialize(:encoding => 'UTF-8')}
  end
end
