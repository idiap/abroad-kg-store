# SPDX-FileCopyrightText: 2025 2025 Idiap Research Institute <contact@idiap.ch>
# SPDX-FileContributor: Delmas Maxime maxime.delmas@idiap.ch
# SPDX-License-Identifier: gpl-3.0-or-later.txt

GRANT SELECT ON "DB"."DBA"."SPARQL_SINV_2" TO "SPARQL";
GRANT EXECUTE ON "DB"."DBA"."SPARQL_SINV_IMP" TO "SPARQL";
DB.DBA.XML_REMOVE_NS_BY_PREFIX ('obo', 2);
DB.DBA.XML_REMOVE_NS_BY_PREFIX ('mesh', 2);
DB.DBA.XML_SET_NS_DECL ('rdf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 2);
DB.DBA.XML_SET_NS_DECL ('rdfs', 'http://www.w3.org/2000/01/rdf-schema#', 2);
DB.DBA.XML_SET_NS_DECL ('xsd', 'http://www.w3.org/2001/XMLSchema#', 2);
DB.DBA.XML_SET_NS_DECL ('owl', 'http://www.w3.org/2002/07/owl#', 2);
DB.DBA.XML_SET_NS_DECL ('meshv', 'http://id.nlm.nih.gov/mesh/vocab#', 2);
DB.DBA.XML_SET_NS_DECL ('mesh', 'http://id.nlm.nih.gov/mesh/', 2);
DB.DBA.XML_SET_NS_DECL ('compound', 'http://rdf.ncbi.nlm.nih.gov/pubchem/compound/', 2);
DB.DBA.XML_SET_NS_DECL ('substance', 'http://rdf.ncbi.nlm.nih.gov/pubchem/substance/', 2);
DB.DBA.XML_SET_NS_DECL ('descriptor', 'http://rdf.ncbi.nlm.nih.gov/pubchem/descriptor/', 2);
DB.DBA.XML_SET_NS_DECL ('synonym', 'http://rdf.ncbi.nlm.nih.gov/pubchem/synonym/', 2);
DB.DBA.XML_SET_NS_DECL ('inchikey', 'http://rdf.ncbi.nlm.nih.gov/pubchem/inchikey/', 2);
DB.DBA.XML_SET_NS_DECL ('bioassay', 'http://rdf.ncbi.nlm.nih.gov/pubchem/bioassay/', 2);
DB.DBA.XML_SET_NS_DECL ('measuregroup', 'http://rdf.ncbi.nlm.nih.gov/pubchem/measuregroup/', 2);
DB.DBA.XML_SET_NS_DECL ('endpoint', 'http://rdf.ncbi.nlm.nih.gov/pubchem/endpoint/', 2);
DB.DBA.XML_SET_NS_DECL ('reference', 'http://rdf.ncbi.nlm.nih.gov/pubchem/reference/', 2);
DB.DBA.XML_SET_NS_DECL ('protein', 'http://rdf.ncbi.nlm.nih.gov/pubchem/protein/', 2);
DB.DBA.XML_SET_NS_DECL ('conserveddomain', 'http://rdf.ncbi.nlm.nih.gov/pubchem/conserveddomain/', 2);
DB.DBA.XML_SET_NS_DECL ('gene', 'http://rdf.ncbi.nlm.nih.gov/pubchem/gene/', 2);
DB.DBA.XML_SET_NS_DECL ('pathway', 'http://rdf.ncbi.nlm.nih.gov/pubchem/pathway/', 2);
DB.DBA.XML_SET_NS_DECL ('source', 'http://rdf.ncbi.nlm.nih.gov/pubchem/source/', 2);
DB.DBA.XML_SET_NS_DECL ('concept', 'http://rdf.ncbi.nlm.nih.gov/pubchem/concept/', 2);
DB.DBA.XML_SET_NS_DECL ('vocab', 'http://rdf.ncbi.nlm.nih.gov/pubchem/vocabulary#', 2);
DB.DBA.XML_SET_NS_DECL ('obo', 'http://purl.obolibrary.org/obo/', 2);
DB.DBA.XML_SET_NS_DECL ('sio', 'http://semanticscience.org/resource/', 2);
DB.DBA.XML_SET_NS_DECL ('skos', 'http://www.w3.org/2004/02/skos/core#', 2);
DB.DBA.XML_SET_NS_DECL ('ndfrt', 'http://evs.nci.nih.gov/ftp1/NDF-RT/NDF-RT.owl#', 2);
DB.DBA.XML_SET_NS_DECL ('ncit', 'http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#', 2);
DB.DBA.XML_SET_NS_DECL ('wikidata', 'http://www.wikidata.org/entity/', 2);
DB.DBA.XML_SET_NS_DECL ('void', 'http://rdfs.org/ns/void#', 2);
DB.DBA.XML_SET_NS_DECL ('dcterms', 'http://purl.org/dc/terms/', 2);
DB.DBA.XML_SET_NS_DECL ('chebi', 'http://purl.obolibrary.org/obo/CHEBI_', 2);
DB.DBA.XML_SET_NS_DECL ('dwc', 'http://rs.tdwg.org/dwc/terms/', 2);
DB.DBA.XML_SET_NS_DECL ('dwciri', 'http://rs.tdwg.org/dwc/iri/', 2);
DB.DBA.XML_SET_NS_DECL ('gbifspecies', 'https://www.gbif.org/species/', 2);
DB.DBA.XML_SET_NS_DECL ('gbifdataset', 'https://www.gbif.org/dataset/', 2);
DB.DBA.XML_SET_NS_DECL ('doi', 'https://www.doi.org/', 2);
DB.DBA.XML_SET_NS_DECL ('p', 'http://www.wikidata.org/prop/', 2);
DB.DBA.XML_SET_NS_DECL ('pr', 'http://www.wikidata.org/prop/reference/', 2);
DB.DBA.XML_SET_NS_DECL ('abroad', 'http://www.abroad-ontology#', 2);
DB.DBA.XML_SET_NS_DECL ('abroadEntities', 'http://www.abroad-entities/', 2);
DB.DBA.XML_SET_NS_DECL ('mycobank', 'https://www.mycobank.org/page/Name%20details%20page/field/Mycobank%20%23/', 2);
DB.DBA.XML_SET_NS_DECL ('pubmed', 'https://pubmed.ncbi.nlm.nih.gov/', 2);
DB.DBA.XML_SET_NS_DECL ('pattern', 'http://www.essepuntato.it/2008/12/pattern#', 2);
DB.DBA.XML_SET_NS_DECL ('doco', 'http://purl.org/spar/doco/', 2);
DB.DBA.XML_SET_NS_DECL ('c4o', 'http://purl.org/spar/c4o/', 2);
DB.DBA.XML_SET_NS_DECL ('cito', 'http://purl.org/spar/cito/', 2);
DB.DBA.XML_SET_NS_DECL ('fabio', 'http://purl.org/spar/fabio/', 2);
DB.DBA.XML_SET_NS_DECL ('prisms', 'http://prismstandard.org/namespaces/basic/2.0/', 2);
DB.DBA.XML_SET_NS_DECL ('mesh2023', 'http://id.nlm.nih.gov/mesh/2023/', 2)
