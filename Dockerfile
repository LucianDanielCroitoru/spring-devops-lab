FROM ubuntu:latest
LABEL authors="lucia"

ENTRYPOINT ["top", "-b"]