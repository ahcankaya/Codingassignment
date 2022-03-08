#founded docker file from https://hub.docker.com/r/wnameless/oracle-xe-11g-r2/dockerfile
FROM wnameless/oracle-xe-11g-r2
EXPOSE 1521
EXPOSE 8080
EXPOSE 22
# Add createuser.sql to create initial db for the application.
ADD resource/database/sql/* /dockerinitdb.d/
