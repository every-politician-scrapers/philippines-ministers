#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class MinistersList < Scraped::HTML
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  field :governors do
    member_entries.map { |ul| fragment(ul => Officeholder).to_h }
  end

  private

  def member_entries
    table.flat_map { |table| table.xpath('.//tr[td]') }
  end

  def table
    noko.xpath('//table[.//th[contains(.,"Governor")]]')
  end
end

class Officeholder < Scraped::HTML
  field :provinceLabel do
    tds[0].text.tidy
  end

  field :governor do
    tds[2].css('a/@wikidata').text
  end

  field :governorLabel do
    tds[2].text.tidy
  end

  field :start do
    Date.parse(tds[7].text).to_s
  end

  private

  def tds
    noko.css('td')
  end
end

url = 'https://en.wikipedia.org/wiki/List_of_current_Philippine_provincial_governors'
data = MinistersList.new(response: Scraped::Request.new(url: url).response).governors

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
