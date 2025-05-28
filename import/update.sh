# SPDX-FileCopyrightText: 2025 2025 Idiap Research Institute <contact@idiap.ch>
# SPDX-FileContributor: Delmas Maxime maxime.delmas@idiap.ch
# SPDX-License-Identifier: gpl-3.0-or-later.txt

echo "Add quick auto inference for entity types on abroad:taxonProduces\n";

SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/abroad-infered-types>  {

		?subject_chem rdf:type chebi:23367 .
		?taxon rdf:type dwc:Taxon .
	}
}
WHERE {
	?subject_chem abroad:isProducedByTaxon ?taxon .
};

echo "Add cito:discusses link between GBIF - PubMed and Chem (Wikidata) - PubMed from LOTUSNPR";

SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/supplementary-cito-discusses-Tiab>  {

		?gbif cito:isDiscussedBy ?pubmed .
		?chem cito:isDiscussedBy ?pubmed
	}
}
WHERE {
	?gbif a dwc:Taxon .
	?chem a chebi:23367 .
	?ref sio:SIO_000628 ?gbif, ?chem ;
		rdf:type abroad:LotusNPR ;
		cito:citesAsEvidence/p:P698 ?pubmed .
	?pubmed rdf:type fabio:JournalArticle .
};

echo "Add cito:discusses link between GBIF - PubMed and Chem (Wikidata) - PubMed from TiabNPR";

SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/supplementary-cito-discusses-Tiab>  {

		?gbif cito:isDiscussedBy ?pubmed .
		?chem cito:isDiscussedBy ?pubmed
	}
}
WHERE {
	?gbif a dwc:Taxon .
	?chem a chebi:23367 .
	?ref sio:SIO_000628 ?gbif, ?chem ;
		rdf:type abroad:TiabNPR ;
		cito:citesAsEvidence/pattern:isContainedBy ?pubmed .
	?pubmed rdf:type fabio:JournalArticle .
};


echo "Add cito:discusses link between GBIF - PubMed and Chem (Wikidata) - PubMed from ChunkNPR";

SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/supplementary-cito-discusses-PMC>  {

		?gbif cito:isDiscussedBy ?pubmed .
		?chem cito:isDiscussedBy ?pubmed
	}
}
WHERE {
	?gbif a dwc:Taxon .
	?chem a chebi:23367 .
	?ref sio:SIO_000628 ?gbif, ?chem ;
		rdf:type abroad:ChunkNPR ;
		cito:citesAsEvidence/pattern:isContainedBy ?pubmed .
	?pubmed rdf:type fabio:JournalArticle .
};


echo "Add shortcuts between chem refs connected via cito:discusses and chem refs related to activity evidences.";

SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/shortcuts-links-to-activity-chunk-evidences>  {
		?activity_chunk_evidence sio:SIO_000628 ?chem_1 .
	}
}
WHERE {

	?chem_1 a chebi:23367 ;
        rdfs:label ?chem_label .
	
	?activity_chunk_evidence rdf:type abroad:ActivityEvidence ;
		sio:SIO_000628 [ a chebi:23367 ;
        rdfs:label ?chem_label ] .
	
};



echo "Add number of STRONG alerts via chemical literature";
SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/identification-alerts>  {
		?identification sio:SIO_000008 [ a abroad:NumberOfChemicalLiteratureAlerts ;
            sio:SIO_000008 "Strong" ;
			sio:SIO_000300 ?n_chemical_alerts ] .
		}
}
WHERE
{
	{
	SELECT ?identification (COUNT(DISTINCT ?label) AS ?n_chemical_alerts)
	WHERE
	{
		{
			SELECT ?identification ?gbif
			WHERE {
				?identification a dwc:Identification ;
					dwc:verbatimIdentification ?verbatim_identification ;
					dwciri:toTaxon/abroad:hasChildTaxon?/abroad:hasSynonymTaxon?  ?gbif .
			}
		}
        
        VALUES ?g { <http://www.abroad-resources/TiabFetchedDocumentDiscusses/2.0> <http://www.abroad-resources/supplementary-cito-discusses-Tiab> }

		?gbif rdfs:label ?gbif_label ;
			abroad:taxonProduces ?chem .

		?chem rdfs:label ?chem_label .

		?alt_chem a chebi:23367 ;
			rdfs:label ?chem_label .
		
        GRAPH ?g {
            ?alt_chem cito:isDiscussedBy ?pmid .
        }

		?activity_chunk_evidence a abroad:StrongActivityEvidence ;
			sio:SIO_000628 ?alt_chem ;
            dcterms:source ?pmid
        BIND(CONCAT(STR( ?chem_label ), STR(?gbif_label) ) AS ?label )
	}
	GROUP BY ?identification
	}
};

echo "Add number of MEDIUM alerts via chemical literature";
SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/identification-alerts>  {
		?identification sio:SIO_000008 [ a abroad:NumberOfChemicalLiteratureAlerts ;
            sio:SIO_000008 "Medium" ;
			sio:SIO_000300 ?n_chemical_alerts ] .
		}
}
WHERE
{
	{
	SELECT ?identification (COUNT(DISTINCT ?label) AS ?n_chemical_alerts)
	WHERE
	{
		{
			SELECT ?identification ?gbif
			WHERE {
				?identification a dwc:Identification ;
					dwc:verbatimIdentification ?verbatim_identification ;
					dwciri:toTaxon/abroad:hasChildTaxon?/abroad:hasSynonymTaxon?  ?gbif .
			}
		}
        
        VALUES ?g { <http://www.abroad-resources/TiabFetchedDocumentDiscusses/2.0> <http://www.abroad-resources/supplementary-cito-discusses-Tiab> }

		?gbif rdfs:label ?gbif_label ;
			abroad:taxonProduces ?chem .

		?chem rdfs:label ?chem_label .

		?alt_chem a chebi:23367 ;
			rdfs:label ?chem_label .
		
        GRAPH ?g {
            ?alt_chem cito:isDiscussedBy ?pmid .
        }

		?activity_chunk_evidence a abroad:MediumActivityEvidence ;
			sio:SIO_000628 ?alt_chem ;
            dcterms:source ?pmid .
        FILTER NOT EXISTS {?alt_ev a abroad:StrongActivityEvidence ;
            sio:SIO_000628/rdfs:label ?chem_label  .
    }
        BIND(CONCAT(STR( ?chem_label ), STR(?gbif_label) ) AS ?label )
	}
	GROUP BY ?identification
	}
};


echo "Add number of WEAK alerts via chemical literature";
SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/identification-alerts>  {
		?identification sio:SIO_000008 [ a abroad:NumberOfChemicalLiteratureAlerts ;
            sio:SIO_000008 "Weak" ;
			sio:SIO_000300 ?n_chemical_alerts ] .
		}
}
WHERE
{
	{
	SELECT ?identification (COUNT(DISTINCT ?label) AS ?n_chemical_alerts)
	WHERE
	{
		{
			SELECT ?identification ?gbif
			WHERE {
				?identification a dwc:Identification ;
					dwc:verbatimIdentification ?verbatim_identification ;
					dwciri:toTaxon/abroad:hasChildTaxon?/abroad:hasSynonymTaxon?  ?gbif .
			}
		}
        
        VALUES ?g { <http://www.abroad-resources/TiabFetchedDocumentDiscusses/2.0> <http://www.abroad-resources/supplementary-cito-discusses-Tiab> }

		?gbif rdfs:label ?gbif_label ;
			abroad:taxonProduces ?chem .

		?chem rdfs:label ?chem_label .

		?alt_chem a chebi:23367 ;
			rdfs:label ?chem_label .
		
        GRAPH ?g {
            ?alt_chem cito:isDiscussedBy ?pmid .
        }

		?activity_chunk_evidence a abroad:WeakActivityEvidence ;
			sio:SIO_000628 ?alt_chem ;
            dcterms:source ?pmid .
        
        FILTER NOT EXISTS {
            VALUES (?no_ev_class) { (abroad:StrongActivityEvidence) (abroad:MediumActivityEvidence) }
            ?alt_ev a ?no_ev_class ;
                sio:SIO_000628/rdfs:label ?chem_label  .
        }
        BIND(CONCAT(STR( ?chem_label ), STR(?gbif_label) ) AS ?label )
	}
	GROUP BY ?identification
	}
};

echo "Add number of STRONG alerts via organism literature";
SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/identification-alerts>  {
		?identification sio:SIO_000008 [ a abroad:NumberOfOrganismLiteratureAlerts ;
            sio:SIO_000008 "Strong" ;
			sio:SIO_000300 ?n_organism_alerts ] .
		}
}
WHERE
{
	{
	SELECT ?identification (COUNT(DISTINCT ?pmid) AS ?n_organism_alerts)
	WHERE
	{
		{
			SELECT ?identification ?gbif
			WHERE {
				?identification a dwc:Identification ;
					dwc:verbatimIdentification ?verbatim_identification ;
					dwciri:toTaxon/abroad:hasChildTaxon?/abroad:hasSynonymTaxon? ?gbif .
			}
		}

		VALUES ?g { <http://www.abroad-resources/TiabFetchedDocumentDiscusses/2.0> <http://www.abroad-resources/supplementary-cito-discusses-Tiab> }

		GRAPH ?g {
            ?gbif  cito:isDiscussedBy ?pmid . 
		}
		
		?activity_chunk_evidence a abroad:StrongActivityEvidence ;
			sio:SIO_000628 ?gbif ;
            dcterms:source ?pmid
	}
	GROUP BY ?identification
	}
};

echo "Add number of MEDIUM alerts via organism literature";
SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/identification-alerts>  {
		?identification sio:SIO_000008 [ a abroad:NumberOfOrganismLiteratureAlerts ;
            sio:SIO_000008 "Medium" ;
			sio:SIO_000300 ?n_organism_alerts ] .
		}
}
WHERE
{
	{
	SELECT ?identification (COUNT(DISTINCT ?pmid) AS ?n_organism_alerts)
	WHERE
	{
		{
			SELECT ?identification ?gbif
			WHERE {
				?identification a dwc:Identification ;
					dwc:verbatimIdentification ?verbatim_identification ;
					dwciri:toTaxon/abroad:hasChildTaxon?/abroad:hasSynonymTaxon? ?gbif .
			}
		}

		VALUES ?g { <http://www.abroad-resources/TiabFetchedDocumentDiscusses/2.0> <http://www.abroad-resources/supplementary-cito-discusses-Tiab> }

		GRAPH ?g {
            ?gbif  cito:isDiscussedBy ?pmid . 
		}
		
		?activity_chunk_evidence a abroad:MediumActivityEvidence ;
			sio:SIO_000628 ?gbif ;
            dcterms:source ?pmid .
	}
	GROUP BY ?identification
	}
};

echo "Add number of WEAK alerts via organism literature";
SPARQL
DEFINE input:inference "schema-inference-rules"
INSERT { 
	GRAPH <http://www.abroad-resources/identification-alerts>  {
		?identification sio:SIO_000008 [ a abroad:NumberOfOrganismLiteratureAlerts ;
            sio:SIO_000008 "Weak" ;
			sio:SIO_000300 ?n_organism_alerts ] .
		}
}
WHERE
{
	{
	SELECT ?identification (COUNT(DISTINCT ?pmid) AS ?n_organism_alerts)
	WHERE
	{
		{
			SELECT ?identification ?gbif
			WHERE {
				?identification a dwc:Identification ;
					dwc:verbatimIdentification ?verbatim_identification ;
					dwciri:toTaxon/abroad:hasChildTaxon?/abroad:hasSynonymTaxon? ?gbif .
			}
		}

		VALUES ?g { <http://www.abroad-resources/TiabFetchedDocumentDiscusses/2.0> <http://www.abroad-resources/supplementary-cito-discusses-Tiab> }

		GRAPH ?g {
            ?gbif  cito:isDiscussedBy ?pmid . 
		}
		
		?activity_chunk_evidence a abroad:WeakActivityEvidence ;
			sio:SIO_000628 ?gbif ;
            dcterms:source ?pmid
	}
	GROUP BY ?identification
	}
};
