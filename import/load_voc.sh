# SPDX-FileCopyrightText: 2025 2025 Idiap Research Institute <contact@idiap.ch>
# SPDX-FileContributor: Delmas Maxime maxime.delmas@idiap.ch
# SPDX-License-Identifier: gpl-3.0-or-later.txt

# vocabularies
ld_dir_all ('/import/vocabularies/', 'abroad.owl', 'https://abroad/inference-rules');
ld_dir_all ('/import/vocabularies/', 'cheminf.owl', 'https://abroad/inference-rules');
ld_dir_all ('/import/vocabularies/', 'biro.ttl', 'https://abroad/inference-rules');
ld_dir_all ('/import/vocabularies/', 'c4o.ttl', 'https://abroad/inference-rules');
ld_dir_all ('/import/vocabularies/', 'cito.ttl', 'https://abroad/inference-rules');
ld_dir_all ('/import/vocabularies/', 'doco.ttl', 'https://abroad/inference-rules');
ld_dir_all ('/import/vocabularies/', 'fabio.ttl', 'https://abroad/inference-rules');
ld_dir_all ('/import/vocabularies/', 'chebi_lite.owl', 'https://abroad/chebi');
select * from DB.DBA.load_list;
rdf_loader_run();
checkpoint;
select * from DB.DBA.LOAD_LIST where ll_error IS NOT NULL;
RDFS_RULE_SET ('schema-inference-rules', 'https://abroad/inference-rules');
RDFS_RULE_SET ('schema-inference-rules', 'https://abroad/chebi');
checkpoint;
