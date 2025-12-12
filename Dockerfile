FROM klutchell/unbound:latest
LABEL maintainer="sinfallas@gmail.com"
LABEL build_date="2025-12-11"
COPY unbound.conf /etc/unbound/unbound.conf
