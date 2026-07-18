FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy server config, world data, and plugins from the repo
COPY server/ ./server/

# Download the Purpur server jar (matches install.sh)
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fSL -o server/server.jar \
       https://api.purpurmc.org/v2/purpur/1.17.1/1428/download

# Accept the Minecraft EULA (server/eula.txt already sets eula=true, ensure it)
RUN echo "eula=true" > server/eula.txt

WORKDIR /app/server

# Adjust memory to fit your Railway plan (scripts requested 8 GB).
# Lower these if your plan has less RAM.
CMD ["java", "-Xms2048M", "-Xmx2048M", "-jar", "server.jar", "nogui"]
