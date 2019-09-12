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
    @titles = doc.css('article').css('h3').css('a').css('span').text
    @links = doc.css('article').css('h3').css('a').attribute('href').value
    @images = doc.css('article').css('h3').css('a').a


  end
end
