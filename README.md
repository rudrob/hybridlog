# hybridlog
Project for my Msc on PUT

# suricata
Assuming Windows \
./suricata.exe -c suricata.yaml -i 192.168.1.2
Linux \
suricata -c /etc/suricata/suricata.yaml -i enp0s3

# local logstash

/etc/logstash/conf.d
/var/log/logstash/logstash-plain.log
/usr/share/logstash

# current setup

     192.168.1.2 -> local windows interface - suricata + beats
     192.168.1.9 -> local ubuntu vm - logstash + elasticsearch



