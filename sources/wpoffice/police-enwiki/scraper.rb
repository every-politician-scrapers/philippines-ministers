#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Term'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name dates].freeze
    end

    def name_node
      name_cell.css('a[href*=Officer]').remove
      super
    end

    def itemLabel
      super.split('(').first.tidy
    end

    def raw_combo_date
      super.gsub(/\(.*?\)/, '').tidy.gsub(/(\w+ \d+) – (\w+ \d+), (\d+)/, '\1, \3 - \2, \3')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
