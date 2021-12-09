#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('strong').text.tidy
    end

    def position
      noko.xpath('.//text()').last.text.tidy
    end
  end

  class Members
    def member_container
      noko.xpath('//h3[contains(., "CABINET OFFICIALS")]/following-sibling::table[1]//td[strong]')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
