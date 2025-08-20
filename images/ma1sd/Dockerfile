FROM hairyhenderson/gomplate:stable-alpine as gomplate

FROM openjdk:8-jre-alpine

ARG APP_VERSION

RUN apk update && apk upgrade --available && apk add bash && rm -rf /var/lib/apk/* /var/cache/apk/*
COPY --from=gomplate /bin/gomplate /usr/bin/gomplate

COPY ./images/ma1sd/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 8090

ENV JAVA_OPTS=""
ENV CONF_FILE_PATH="/etc/ma1sd/ma1sd.yaml"
ENV SIGN_KEY_PATH="/var/ma1sd/sign.key"
ENV SQLITE_DATABASE_PATH="/var/ma1sd/ma1sd.db"

RUN mkdir /app \
 && wget https://raw.githubusercontent.com/ma1uta/ma1sd/refs/tags/${APP_VERSION}/src/script/ma1sd -O /app/ma1sd \
 && wget https://github.com/ma1uta/ma1sd/releases/download/${APP_VERSION}/ma1sd-shadow.zip -O /tmp/ma1sd-shadow.zip \
 && unzip /tmp/ma1sd-shadow.zip -d /tmp \
 && mv /tmp/ma1sd-shadow/lib/ma1sd.jar /app/ma1sd.jar \
 && rm -rf /tmp/ma1sd-shadow.zip /tmp/ma1sd-shadow

CMD [ "/usr/local/bin/entrypoint.sh" ]