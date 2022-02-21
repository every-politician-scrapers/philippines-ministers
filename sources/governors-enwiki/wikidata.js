module.exports = function () {
  return `SELECT ?province ?provinceLabel ?governor ?governorLabel ?position ?positionLabel ?start ?end
  WHERE {
    ?position wdt:P279 wd:Q28806166.
    ?governor p:P39 ?ps .
    ?ps ps:P39 ?position ; pq:P580 ?start .
    OPTIONAL { ?ps pq:P582 ?end }
    OPTIONAL { ?position wdt:P1001 ?province }
    FILTER (!BOUND(?end) || (?end >= NOW()))
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  }
  # ${new Date().toISOString()}
  ORDER BY ?provinceLabel ?start`
}
