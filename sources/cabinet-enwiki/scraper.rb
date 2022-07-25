#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.css('img').remove
      noko.css('i').remove
      noko.xpath("//table[.//th[contains(.,'Acronym')]][1]//tr[td]")
    end
  end

  class Member
    field :id do
      name_node.css('a/@wikidata').first
    end

    field :name do
      name_node.text.tidy
    end

    field :positionID do
    end

    field :position do
      tds[2].text.tidy
    end

    field :startDate do
      WikipediaDate.new(raw_start).to_s
    end

    field :endDate do
    end

    private

    def tds
      noko.css('td')
    end

    def name_node
      tds[3]
    end

    def raw_start
      tds[4].text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
