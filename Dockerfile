#FROM grafana/grafana-oss:9.5.2
FROM grafana/grafana-oss:12.2.0-17142428006-ubuntu
USER root

# SHELL ["/bin/bash", "--login", "-i", "-c"]

# -- install basics
# RUN apk add --update ca-certificates tzdata curl jq
RUN apt-get -y update
RUN apt-get -y install ca-certificates tzdata curl jq

# -- other configs
COPY dashboards /var/lib/grafana/dashboards/
COPY provisioning  /etc/grafana/provisioning/
COPY grafana.ini /etc/grafana/

# -- install image panel and HTML plugins
# RUN grafana-cli plugins install dalvany-image-panel
# RUN grafana-cli plugins install aidanmountford-html-panel
# RUN grafana-cli plugins install marcusolsson-csv-datasource
# RUN grafana-cli plugins install marcusolsson-json-datasource
RUN grafana-cli plugins install yesoreyeram-infinity-datasource

# -- finally, extra scripts
COPY post-init.sh /
COPY entrypoint.sh /

RUN chmod +x /post-init.sh && \
    chmod +x /entrypoint.sh 
  
