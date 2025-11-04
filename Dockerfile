# Dockerfile
FROM cgr.dev/chainguard/wolfi-base:latest

# Install packages
RUN apk update && apk add --no-cache lighttpd python3 py3-pip wget

# Copy and install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Ensure lighttpd user/group exist (won't fail if already present)
RUN addgroup -S lighttpd || true \
 && adduser -S -G lighttpd lighttpd || true

# Create docroot + log dir, then set ownership
#RUN mkdir -p /var/www/htdocs/cgi-bin /var/log/lighttpd \
RUN mkdir -p /var/www/htdocs/cgi-bin \
 && chmod -R 755 /var/www/htdocs \
#  && chown -R lighttpd:lighttpd /var/www /var/log/lighttpd
 && chown -R lighttpd:lighttpd /var/www 

# Drop to non-root
USER lighttpd

# Foreground mode so docker logs work
CMD ["lighttpd","-D","-f","/etc/lighttpd/lighttpd.conf"]
