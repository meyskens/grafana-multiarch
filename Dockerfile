ARG arch
FROM multiarch/debian-debootstrap:${arch}-stretch
ARG arch

ARG DOWNLOAD_URL

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig wget curl ca-certificates && \
    apt-get clean && \
    wget -O /tmp/grafana.deb "${DOWNLOAD_URL}" && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.10/gosu-${arch} > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]