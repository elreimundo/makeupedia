require 'net/http'
require 'nokogiri'

module WikisHelper
  extend self
  def build_the_json(params)
    @data = {uri: (params[:ending].empty? ? URI.parse("http://en.wikipedia.org/wiki/Internet") : URI.parse("http://en.wikipedia.org/wiki/#{params[:ending].split(' ').join('_')}")),
    search_text: (params[:search].empty? ? Regexp.new("internet", Regexp::IGNORECASE) : Regexp.new(params[:search], Regexp::IGNORECASE)),
    replace_text: (params[:replace].empty? ? "Al Gore" : params[:replace])}

    build_the_page
  end

  def build_the_page
    object_to_break = parse_the_page(@data[:uri])
    make_necessary_text_replacements(object_to_break)
    wrap(object_to_break)
  end

  def make_necessary_text_replacements(node)
    return node.content = node.content.to_s.gsub(@data[:search_text],@data[:replace_text]) if node.children.empty? && node.text?
    node.children.each{ |e| make_necessary_text_replacements(e) } unless node.children.empty?
  end

  def parse_the_page(page)
    nokogiri_object = Nokogiri::HTML(Net::HTTP.get_response(page).body.force_encoding('UTF-8'))
    nokogiri_object.css('title')[0].content = nokogiri_object.css('title')[0].content.gsub('Wikipedia, the free encyclopedia', 'Makeupedia, the false encyclopedia')
    nokogiri_object
  end

  def apply_lots_of_changes(params)
    page = Page.find(params[:id])
    page_user = PageUser.where('page_id=?', page.id).where('user_id=?',params[:user_id].to_i).first
    nokogiri_object = parse_the_page(URI.parse(page.url))
    page_user.changes.each do |change|
      @data = {search_text: Regexp.new(change.find_text, Regexp::IGNORECASE), replace_text: change.replace_text}
      make_necessary_text_replacements(nokogiri_object)
    end
    wrap(nokogiri_object)
  end

  def wrap(object)
    {content: object.serialize(:encoding => 'UTF-8')}
  end

  def just_display_the_stuff(ending)
    nokogiri_object = parse_the_page(URI.parse("http://en.wikipedia.org/wiki/#{ending}"))
    {content: nokogiri_object.css('body')[0].serialize(:encoding => 'UTF-8'), title: nokogiri_object.css('title')[0].serialize(:encoding => 'UTF-8')}
  end

  def display_the_stuff_with_changes(params)
    nokogiri_object = parse_the_page(URI.parse("http://en.wikipedia.org/wiki/#{params[:page]}"))
    page = Page.where('ending=?',params[:page].split('_').join(' '))
    page = page.first if page
    user = User.find(params['user_id'].to_i) if params['user_id']
    user = current_user unless user
    if page && user
      page_user = PageUser.where('page_id=?', page.id).where('user_id=?',user.id)
      page_user = page_user.first if page_user
      page_user.changes.each do |change|
        @data = {search_text: Regexp.new(change.find_text, Regexp::IGNORECASE), replace_text: change.replace_text}
        make_necessary_text_replacements(nokogiri_object)
      end
      return {content: nokogiri_object.css('body')[0].serialize(:encoding => 'UTF-8'), title: nokogiri_object.css('title')[0].serialize(:encoding => 'UTF-8')}
    else
      return just_display_the_stuff(params[:page])
    end
  end
end
