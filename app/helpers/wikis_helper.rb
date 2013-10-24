require 'net/http'
require 'nokogiri'

module TextReplacer
  def search_and_replace(node, search, replace)
    node.content = node.content.to_s.gsub(search,replace)
  end

  def text_node?(node)
    node.children.empty? && node.text?
  end

  def deep_text_replace(node, search, replace)
    if text_node?(node)
      search_and_replace(node, search, replace)
    else
      node.children.each do |child|
        deep_text_replace(child, search, replace)
      end
    end
  end
end

module WikisHelper
  extend self
  include TextReplacer

  def make_uri(ending)
    base_uri = mobile_device? ? "http://en.m.wikipedia.org/wiki" : "http://en.wikipedia.org/wiki"
    page_name = ending.gsub(" ","_").capitalize
    url = ending.empty? ? "#{base_uri}/Internet" : "#{base_uri}/#{page_name}"
  end

  def standardize(ending)
    ending.split('_').join(' ').capitalize
  end

  def parse_the_page(page)
    Nokogiri::HTML(page)
  end

  def get_the_html(ending)
    page = Page.find_or_create_by(ending: ending)
    page.update_attribute('cached',HTTParty.get(make_uri(ending)).body) unless page.recently_cached?
    page.cached
  end

  def replace_wikipedia_title(noko_obj)
    noko_obj.css('title')[0].content = noko_obj.css('title')[0].content.gsub('Wikipedia, the free encyclopedia', 'Makeupedia, the fake encyclopedia')
  end

  def get_modified_wikipedia_body(ending, changes)

    nokogiri_object = parse_the_page(get_the_html(ending))
    replace_wikipedia_title(nokogiri_object)

    changes.each do |change|
      search_text = ignorecase_regex(change.find_text)
      replace_text = change.replace_text
      deep_text_replace(nokogiri_object, search_text, replace_text)
    end

    {content: nokogiri_object.css('body')[0].serialize(:encoding => 'UTF-8'), title: nokogiri_object.css('title')[0].serialize(:encoding => 'UTF-8')}
  end

  def ignorecase_regex(word)
    Regexp.new(word, Regexp::IGNORECASE)
  end
end


if $0 == __FILE__
  p WikisHelper.get_modified_wikipedia_body("Internet")
end