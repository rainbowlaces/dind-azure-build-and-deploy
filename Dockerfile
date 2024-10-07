# Base image with Docker installed (docker-in-docker)
FROM docker:20.10-dind

# Install necessary tools: git, bash, jq (for parsing JSON)
RUN apk add --no-cache git bash jq

# Set working directory
WORKDIR /app

# Copy the startup script into the container
COPY start.sh /app/start.sh

# Make the script executable
RUN chmod +x /app/start.sh

# Define the startup script as the default command (it will handle everything)
CMD ["/bin/bash", "/app/start.sh"]