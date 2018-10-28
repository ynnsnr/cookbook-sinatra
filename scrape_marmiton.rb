require 'open-uri'
require 'nokogiri'
require_relative 'recipe'

class ScrapeMarmiton
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{@keyword}"
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    results = []
    doc.search('.recipe-card').each do |element|
      name = element.search('.recipe-card__title').text
      description = element.search('.recipe-card__description').text.strip
      prep_time = element.search('.recipe-card__duration__value').text
      difficulty = get_difficulty(element.xpath('a/@href').text)
      results << Recipe.new(name, description, prep_time, difficulty)
    end
    results
  end

  def get_difficulty(href)
    url = "https://www.marmiton.org#{href}"
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    doc.search('.recipe-infos__item-title')[2].text
  end
end
