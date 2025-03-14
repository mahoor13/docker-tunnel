FROM gogost/gost

COPY ./supervisord.conf /etc/supervisord.conf
COPY ./entrypoint.sh /entrypoint.sh

# Install openssh-client and then clean up
RUN apk update && \
    apk add --no-cache openssh-client curl && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    chmod a+x /entrypoint.sh 

# golang alternative for supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

COPY --from=cloudflare/cloudflared:latest /usr/local/bin/cloudflared /usr/local/bin/cloudflared

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/local/bin/supervisord"]