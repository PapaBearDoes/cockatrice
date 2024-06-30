#########################
# Build Servatrice
#########################
FROM debian:bookworm-slim
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV HOME=/home/servatrice

#########################
# Update / Install Filesystem
#########################
RUN apt -y update
RUN apt -y upgrade
RUN apt -y --no-install-recommends install build-essential\
 ccache\
 clang-format\
 cmake\
 file\
 g++\
 git\
 libgl-dev\
 liblzma-dev\
 libmariadb-dev-compat\
 libprotobuf-dev\
 libqt6multimedia6\
 libqt6sql6-mysql\
 qt6-svg-dev\
 qt6-websockets-dev\
 protobuf-compiler\
 qt6-l10n-tools\
 qt6-multimedia-dev\
 qt6-tools-dev\
 qt6-tools-dev-tools

#########################
# Copy / Prep Backend
#########################
RUN mkdir -p ${HOME}/code/build
COPY . ${HOME}/code/
WORKDIR ${HOME}/code

#########################
# Build Software
#########################
WORKDIR ${HOME}/code/build
RUN cmake .. -DWITH_SERVER=1\
 -DWITH_CLIENT=0\
 -DWITH_ORACLE=0\
 -DWITH_DBCONVERTER=0
RUN cmake --build .
RUN make package
RUN dpkg -i ./Cockatrice*.deb

WORKDIR ${HOME}

EXPOSE 4747

ENTRYPOINT ["servatrice --log-to-console"]