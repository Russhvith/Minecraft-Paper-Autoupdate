#!/bin/bash

MINECRAFT_VERSION=1.19.3
PROJECT=paper
AUTO_UPDATE_JAR=true

echo -e ""
echo -e "Using Russ Auto Updater Skript"
echo -e ""
echo -e "Minecraft Version: ${MINECRAFT_VERSION}"
echo -e "Project: ${PROJECT}"
echo -e "Auto Update: ${AUTO_UPDATE_JAR}"


if [ "${AUTO_UPDATE_JAR}" == "true" ]; then
        echo -e "Checking For Minecraft Jar Updates"
        VER_EXISTS=`curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep -m1 true`
        LATEST_VERSION=`curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]'`
        if [ "${VER_EXISTS}" == "true" ]; then
                echo -e "Version is valid. Using version ${MINECRAFT_VERSION}"
        else
                echo -e "Specified version not found. Defaulting to the latest ${PROJECT} version"
                MINECRAFT_VERSION=${LATEST_VERSION}
        fi
        LATEST_BUILD=`curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]'`
        echo -e "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
        BUILD_NUMBER=${LATEST_BUILD}
        JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar
        DOWNLOAD_URL=https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}
        curl -o ${JAR_NAME} ${DOWNLOAD_URL} 
fi

./mcstart.sh
