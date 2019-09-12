class Ps1Controller < ApplicationController
  def index
  end

  def divide_by_zero
    logger.debug('about to divide by zero')
    a=1/0
  end

  def scrapper
    require 'open-uri'
    doc = Nokogiri::HTML(open('http://ait.ac.th'))
    @articles = doc.css('article')
    @titles = doc.css('article').css('h3').css('span')
    @links = doc.css('article').css('h3').css('a')
    @images = doc.css('article').css('figure').css('a').css('img')
  end
end
