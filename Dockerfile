FROM openjdk:8

RUN URL='https://github.com/krallin/tini/releases/download/v0.18.0/tini_0.18.0-amd64.deb'; FILE=$(mktemp); curl -L "$URL" -o $FILE && dpkg -i $FILE; rm $FILE
ENTRYPOINT ["tini", "--"]

RUN useradd -ms /bin/bash runner
USER runner

ENV HOME=/home/runner
ENV LANG=C.UTF-8
ENV APP_HOME=$HOME/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ENV GRADLE_USER_HOME=$HOME/.gradle
RUN mkdir -p $GRADLE_USER_HOME
COPY --chown=runner:runner ./gradle ./gradle
COPY --chown=runner:runner ./gradlew* ./*.gradle ./
RUN ./gradlew --no-daemon build
ADD --chown=runner:runner . .

EXPOSE 8761
CMD ["./gradlew", "bootRun"]
