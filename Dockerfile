FROM openjdk:21-jdk-slim

WORKDIR /minecraft

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

ENV PAPER_VERSION=1.20.6 \
    PAPER_BUILD=147 \
    MEMORY_SIZE=4G \
    EULA=false

# Create the start script
RUN echo '#!/bin/bash\n\
    # Check if eula.txt exists\n\
    if [ ! -f /minecraft/eula.txt ]; then\n\
    # Check EULA environment variable and create eula.txt accordingly\n\
    if [ "$EULA" = "true" ]; then\n\
    echo "eula=true" > /minecraft/eula.txt\n\
    else\n\
    echo "eula=false" > /minecraft/eula.txt\n\
    fi\n\
    fi\n\
    \n\
    # Download Paper jar if it does not exist\n\
    if [ ! -f /minecraft/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar ]; then\n\
    wget -O /minecraft/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar "https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar";\n\
    fi\n\
    \n\
    # Start the Minecraft server\n\
    java -Xms${MEMORY_SIZE} -Xmx${MEMORY_SIZE} -jar /minecraft/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar nogui' > start.sh && \
    chmod +x start.sh

EXPOSE 25565

ENTRYPOINT ["/minecraft/start.sh"]
