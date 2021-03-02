# Hybridlog
#### Security log storage analysis for hybrid arch from on-prem system

### Decision log
* At first considered VPC setup with VPN, unfortunately this would mean importing private certificate into AMC which costs 400$/monthly. Because of that will have to use internet facing cluster.

---
### Deployment Notes
* Place any secrets in "secrets.auto.tfvars", other tfvars are not gitignored


---
### Personal config notes

Suricata > Beats > Logstash configured locally on ubuntu VM

### Suricata
suricata -c /etc/suricata/suricata.yaml -i enp0s3

### Logstash
/etc/logstash/conf.d \
/var/log/logstash/logstash-plain.log \
/usr/share/logstash




