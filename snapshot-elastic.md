http://elasticsearch-5.6.marathon.services.newsriver.io:9200/_snapshot/_all

##Command to make manual snapshot
PUT /_snapshot/backup/snapshot-2017-10-07
{
  "indices": "newsriver-website,newsriver-source",
  "ignore_unavailable": true,
  "include_global_state": false
}


##Command to create repository
PUT /_snapshot/backup
{
  "type": "gcs",
  "settings": {
    "bucket": "backup-es-newsriver",
    "client":"newsriver",
    "compress": true
  }
}
