module.exports = function () {
  return `SELECT ?province ?provinceLabel ?governor ?name ?position ?positionLabel ?start ?end ?sourceDate
               (STRAFTER(STR(?ps), '/statement/') AS ?psid)
  WHERE {
    ?position wdt:P279 wd:Q28806166.
    ?governor p:P39 ?ps .
    ?ps ps:P39 ?position ; pq:P580 ?start .
    OPTIONAL { ?ps pq:P582 ?end }
    OPTIONAL { ?position wdt:P1001 ?province }
    FILTER (!BOUND(?end) || (?end >= NOW()))

    OPTIONAL {
      ?ps prov:wasDerivedFrom ?ref .
      ?ref pr:P4656 ?source FILTER CONTAINS(STR(?source), 'List_of_current_Philippine_provincial_governors') .
      OPTIONAL { ?ref pr:P1810 ?sourceName }
      OPTIONAL { ?ref pr:P813  ?sourceDate }
    }
    OPTIONAL { ?governor rdfs:label ?wdLabel FILTER(LANG(?wdLabel) = "en") }
    BIND(COALESCE(?sourceName, ?wdLabel) AS ?name)

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  }
  # ${new Date().toISOString()}
  ORDER BY ?sourceDate ?provinceLabel ?start`
}
