require 'net/http'
require 'nokogiri'
module WikisHelper
  extend self

  def make_uri(ending)
    base_uri = mobile_device? ? "http://en.m.wikipedia.org/wiki" : "http://en.wikipedia.org/wiki"
    page_name = ending.gsub(" ","_").capitalize
    ending.empty? ? "#{base_uri}/Internet" : "#{base_uri}/#{page_name}"
  end


  def make_necessary_text_replacements(node)
    return node.content = node.content.to_s.gsub(@data[:search_text],@data[:replace_text]) if node.children.empty? && node.text?
    node.children.each{ |e| make_necessary_text_replacements(e) } unless node.children.empty?
  end

  def parse_the_page(page)
    nokogiri_object = Nokogiri::HTML(Net::HTTP.get_response(page).body.force_encoding('UTF-8'))
    nokogiri_object.css('head').add_child('title') if nokogiri_object.css('title').empty?
    nokogiri_object.css('title')[0].content = nokogiri_object.css('title')[0].content.gsub('Wikipedia, the free encyclopedia', 'Makeupedia, the fake encyclopedia')
    nokogiri_object
  end

  def just_display_the_stuff(ending)
    nokogiri_object = parse_the_page(URI.parse(make_uri(ending)))
    {content: nokogiri_object.css('body')[0].serialize(:encoding => 'UTF-8'), title: nokogiri_object.css('title')[0].serialize(:encoding => 'UTF-8')}
  end

  def display_the_stuff_with_changes(ending, user_id)
    nokogiri_object = parse_the_page(URI.parse(make_uri(ending)))
    page = Page.where('ending=?',ending.split('_').join(' '))
    page = (page.empty? ? nil : page.first)
    user = User.find(user_id.to_i) if user_id
    user = current_user unless user
    if page && user
      page_user = PageUser.where('page_id=?', page.id).where('user_id=?',user.id)
      unless page_user.empty?
        page_user = page_user.first
        page_user.changes.each do |change|
          @data = {search_text: ignorecase_regex(change.find_text), replace_text: change.replace_text}
          make_necessary_text_replacements(nokogiri_object)
        end
        return {content: nokogiri_object.css('body')[0].serialize(:encoding => 'UTF-8'), title: nokogiri_object.css('title')[0].serialize(:encoding => 'UTF-8') }
      end
    else
      return just_display_the_stuff(params[:page])
    end
  end

  def ignorecase_regex(word)
    Regexp.new(word, Regexp::IGNORECASE)
  end
end

if $0 == __FILE__
  p WikisHelper.just_display_the_stuff("Internet")
end