# Use a multi-stage build with platform specification
FROM --platform=${BUILDPLATFORM} alpine:3.18 AS base

# Best Practice: Set labels for metadata
LABEL maintainer="Your Name <youremail@example.com>" \
      description="Basic web server using BusyBox" \
      version="1.0"

# Best Practice: Use a specific, stable Alpine version
# Install only the necessary packages
RUN apk --no-cache add busybox && \
    # Create the directory for web files and set appropriate permissions
    mkdir -p /var/www/html && \
    chmod -R 755 /var/www/html

# Add a simple HTML file
RUN echo "<html><body><h1>Welcome to the basic web server!</h1></body></html>" > /var/www/html/index.html

# Best Practice: Use a non-root user for running the application
# Create a user for running the web server
RUN addgroup -S webgroup && adduser -S webuser -G webgroup && \
    chown -R webuser:webgroup /var/www/html

# Switch to the non-root user
USER webuser

# Expose the web server port
EXPOSE 80

# Best Practice: Set a HEALTHCHECK to monitor container health
HEALTHCHECK CMD wget --spider --quiet http://localhost || exit 1

# Set the default command to run the web server in the foreground
CMD ["busybox", "httpd", "-f", "-v", "-h", "/var/www/html"]
