# Hybridlog
#### Security log storage analysis for hybrid arch from on-prem system

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




