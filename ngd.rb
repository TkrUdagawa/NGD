# -*- coding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'open-uri'
#require 'mechanize'
class Ngd_calculator
  
  def initialize()
#    @agent = Mechanize.new
#    @agent.set_proxy("", )
    @all_score = get_google_all_score()
  end

  def google_distance(word1, word2)
    quoted_word1 = "%22" + word1 + "%22"
    quoted_word2 = "%22" + word2 + "%22"
    score1 = get_google_score(quoted_word1)
    score2 = get_google_score(quoted_word2)
    and_score = get_google_and_score(quoted_word1, quoted_word2)
    printf("score1 = %f, score2 = %f, and_score = %f, all_score = %f\n" %[score1, score2, and_score, @all_score])
    ret_val = ([score1, score2].max - and_score) / (@all_score - [score1, score2].min)
    return ret_val
  end

  def get_google_score(query)
    url = "http://www.google.com/search?ie=UTF-8&oe=UTF-8&q=" + query 
    html = Nokogiri::HTML(open(url))
    score = html.css('div#resultStats').inner_text.split(" ")[1].delete(",").to_f
    google_score = Math.log(score)
    if google_score == -Float::INFINITY or google_score == Float::INFINITY then
      google_score = 0
    end
    return google_score
  end

  def get_google_and_score(query1, query2)
    query = query1+"%20AND%20" + query2
    return get_google_score(query)
  end

  def get_google_all_score()
    #currently magic number 1 trillion is used
    # Total number of web pages is ideal.
    return Math.log(1000000000000)
#    return get_google_score("")
  end

end

g = Ngd_calculator.new()
score = g.google_distance(ARGV[0], ARGV[1])
p score
