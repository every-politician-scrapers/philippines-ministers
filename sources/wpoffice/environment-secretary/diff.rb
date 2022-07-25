#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# TODO: pass the list of decorators as an argument
diff = EveryPoliticianScraper::Comparison.new('wikidata.csv', 'scraped.csv').diff
diff = DaffDiff::Decorator.new(data: diff, cell_class: DaffDiff::Decorator::DatePrecision).decorated
diff = DaffDiff::Decorator.new(data: diff, cell_class: DaffDiff::Decorator::Nullless).decorated
diff = DaffDiff::Decorator.new(data: diff, cell_class: DaffDiff::Decorator::WithinWeek).decorated

puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
