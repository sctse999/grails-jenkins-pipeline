FROM tomcat:8-jre8
ARG COMMIT_ID='WRONG_COMMIT_ID'

ENV COMMIT_ID ${COMMIT_ID}

RUN ["rm", "-fr", "/usr/local/tomcat/webapps/ROOT"]
COPY ./build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]