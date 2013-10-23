require 'net/http'
require 'nokogiri'
include StyleHelper
module WikisHelper
  extend self

  def make_uri(ending)
    base_uri = mobile_device? ? "http://en.m.wikipedia.org/wiki" : "http://en.wikipedia.org/wiki"
    page_name = ending.gsub(" ","_").capitalize
    ending.empty? ? "#{base_uri}/Internet" : "#{base_uri}/#{page_name}"
  end

  def build_regex(word)
    Regexp.new(word, Regexp::IGNORECASE)
  end

  def build_the_json(params)
    the_parsed_uri = URI.parse(make_uri(params[:ending]))
    @data = {uri: the_parsed_uri,
            search_text: (params[:search].nil? ? build_regex("Internet") : build_regex(params[:search])),
            replace_text: (params[:replace].nil? ? "Al Gore" : params[:replace]),
            ending: params[:ending]}

    build_the_page
  end

  def build_the_page
    nokogiri_object = parse_the_page(@data[:uri])
    make_necessary_text_replacements(nokogiri_object)
    add_our_stuff_to(nokogiri_object)
    wrap(nokogiri_object)
  end

  def add_our_stuff_to(nokogiri_object)
    # body
    body = nokogiri_object.at_css("body")
    form_div = Nokogiri::XML::Node.new "div", nokogiri_object
    form_div['id'] = "bottom-menu"
    style = StyleHelper::form_style
    form_div['style'] = style

    # # form
    wiki_form = Nokogiri::XML::Node.new "form", nokogiri_object
    wiki_form['accept-charset'] = "UTF-8"
    wiki_form['action'] = "/wikis"
    wiki_form['class'] = "second-form"
    wiki_form['method'] = "post"

    # first form div
    div_one = Nokogiri::XML::Node.new "div", nokogiri_object

    # input_one on div_one
    input_one = Nokogiri::XML::Node.new "input", nokogiri_object
    input_one['name'] = "utf8"
    input_one['type'] = "hidden"
    input_one['value'] = "U+2714"

    # input_two on div_one
    input_two = Nokogiri::XML::Node.new "input", nokogiri_object
    input_two['name'] = "authenticity_token"
    input_two['type'] = "hidden"
    input_two['value'] = form_authenticity_token

    # input_three on div_one
    input_three = Nokogiri::XML::Node.new "input", nokogiri_object
    input_three['name'] = "ending"
    input_three['type'] = "hidden"
    input_three['value'] = @data[:ending]

    # first jquery div on form div
    textarea_style = StyleHelper::text_area_style
    div_jq = Nokogiri::XML::Node.new "div", nokogiri_object
    textarea_select = Nokogiri::XML::Node.new "textarea", nokogiri_object
    textarea_select['type'] = "textarea"
    textarea_select['id'] = "find_text"
    textarea_select['name'] = "search"
    textarea_select['placeholder'] = "Select or type some text to replace"
    textarea_select['style'] = textarea_style

    textarea_replace = Nokogiri::XML::Node.new "textarea", nokogiri_object
    textarea_replace['type'] = "textarea"
    textarea_replace['id'] = "replace_text"
    textarea_replace['name'] = "replace"
    textarea_replace['placeholder'] = "Replace with"
    textarea_replace['style'] = textarea_style + "margin-bottom:1em;"

    button = Nokogiri::XML::Node.new "input", nokogiri_object
    button['type'] = "submit"
    button['value'] = "Submit"
    button['id'] = "killer-awesome-submit-button"
    button['style'] = StyleHelper::button_style_blue

    div_jq.add_child(textarea_select)
    div_jq.add_child(textarea_replace)
    div_jq.add_child(button)

    div_one.add_child(input_one)
    div_one.add_child(input_two)
    div_one.add_child(input_three)

    wiki_form.add_child(div_one)
    wiki_form.add_child(div_jq)
    form_div.add_child(wiki_form)

    body.children.last.add_next_sibling(form_div)
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
          @data = {search_text: Regexp.new(change.find_text, Regexp::IGNORECASE), replace_text: change.replace_text}
          make_necessary_text_replacements(nokogiri_object)
        end
        return {content: nokogiri_object.css('body')[0].serialize(:encoding => 'UTF-8'), title: nokogiri_object.css('title')[0].serialize(:encoding => 'UTF-8') }
      end
    else
      return just_display_the_stuff(params[:page])
    end
  end
end

if $0 == __FILE__
  p WikisHelper.just_display_the_stuff("Internet")
end