FROM gogost/gost

# Install openssh-client and then clean up
RUN apk update && \
    apk add --no-cache openssh-client supervisor && \
    # Clean up the apk cache to reduce image size
    rm -rf /var/cache/apk/* && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Set up SSH configuration for better security
RUN echo "Host *\n\tStrictHostKeyChecking accept-new\n\tHashKnownHosts yes" > /root/.ssh/config && \
    chmod 600 /root/.ssh/config

RUN mkdir -p /etc/supervisor/conf.d
COPY ./supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]