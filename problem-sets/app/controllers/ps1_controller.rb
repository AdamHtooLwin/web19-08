class Ps1Controller < ApplicationController
  rescue_from ZeroDivisionError do |exception|
    puts exception.backtrace

    @error = exception

    render "ps1/divide_by_zero"

  end

  def index
  end

  # def divide_by_zero
  #   logger.debug('about to divide by zero')
  #   a=1/0
  # end

  def scrapper
    require 'open-uri'
    doc = Nokogiri::HTML(open('http://ait.ac.th'))
    @articles = doc.css('article')
    @titles = doc.css('article').css('h3').css('span')
    @links = doc.css('article').css('h3').css('a')
    @images = doc.css('article').css('figure').css('a').css('img')
  end
end
