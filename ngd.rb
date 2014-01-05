# -*- coding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

class Ngd_calculator
  def initialize()
    @agent = Mechanize.new
#    @agent.set_proxy("", )
    @all_score = get_google_all_score()
  end

  def google_distance(word1, word2)
    quoted_word1 = "\"%s\"" % word1
    quoted_word2 = "\"%s\"" % word2
    score1 = get_google_score(quoted_word1)
    score2 = get_google_score(quoted_word2)
    and_score = get_google_and_score(quoted_word1, quoted_word2)
    printf("score1 = %f, score2 = %f, and_score = %f, all_score = %f\n" %[score1, score2, and_score, @all_score])
    ret_val = ([score1, score2].max - and_score) / (@all_score - [score1, score2].min)
    return ret_val
  end

  def get_google_score(query)
    url = 'http://www.google.com'
    page = @agent.get(url)
    @agent.page.form_with(:name=> 'f'){|form|
      form.field_with(:name => 'q').value = query
      form.click_button
    }
    html = Nokogiri::HTML(open(@agent.page.uri.to_s))
    score = html.css('div#resultStats').inner_text.split(" ")[1].delete(",").to_f
    return Math.log(score)
  end

  def get_google_and_score(query1, query2)
    query = "%s AND %s" % [query1, query2]
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
