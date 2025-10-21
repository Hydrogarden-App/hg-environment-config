FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y logrotate cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY logrotate /etc/logrotate.d/logrotate

RUN chmod 644 /etc/logrotate.d/logrotate

CMD ["cron", "-f"]
