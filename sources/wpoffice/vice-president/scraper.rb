#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  def table_number
    1
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name _ party dates].freeze
    end

    def raw_combo_date
      super.split('(').first
    end

    def empty?
      (tds[2].text == tds[3].text) || too_early?
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
