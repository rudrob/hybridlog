# Hybridlog
#### Security log storage analysis for hybrid arch from on-prem system

### Decision log
* At first considered VPC setup with VPN, unfortunately this would mean importing private certificate into AMC
  which costs 400$/monthly or configuration of Microsoft AD. 
  Because of that will have to use internet facing cluster.

---
### Deployment Notes
* Place any secrets in "secrets.auto.tfvars", other tfvars are not gitignored

---
Useful links
https://www.elastic.co/guide/en/logstash/current/pipeline-to-pipeline.html#distributor-pattern
https://logz.io/blog/managing-elasticsearch-indices/
https://github.com/phillbaker/terraform-provider-elasticsearch
https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains-snapshots.html




