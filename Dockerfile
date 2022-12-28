FROM postgres:14-alpine
# Copy in the load-extensions script
COPY load-extensions.sh /docker-entrypoint-initdb.d/
# https://gist.github.com/leopoldodonnell/b0b7e06943bd389560184d948bdc2d5b