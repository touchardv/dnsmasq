FROM arm32v7/alpine:3.13.2

RUN apk add --no-cache dnsmasq

ARG webproc=webproc_0.4.0_linux_armv7

RUN cd /tmp && \
  wget https://github.com/jpillora/webproc/releases/download/v0.4.0/${webproc}.gz && \
  gunzip ${webproc}.gz && \
  chmod +x ${webproc} && \
  mv ${webproc} /usr/bin && \
  ln -s /usr/bin/${webproc} /usr/bin/webproc

ADD etc /etc/

EXPOSE 53/tcp 53/udp

EXPOSE 8080

VOLUME ["/etc/dnsmasq.d", "/var/lib/dnsmasq"]

ENTRYPOINT ["/usr/bin/webproc"]

CMD ["/etc/webproc.toml"]
