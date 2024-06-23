#########################
# Build Servatrice
#########################
FROM debian:bookworm-slim
MAINTAINER PapaBearDoes <papabeardoes@gmail.com>

#########################
# Update / Install Filesystem
#########################
RUN apt -y update
RUN apt -y upgrade
RUN apt -y install build-essential\
 cmake\
 git\
 libprotobuf-dev\
 libqt6sql6-mysql\
 libmariadb-dev\
 libqt6websockets6-dev\
 protobuf-compiler\
 qt6-base-dev\
 qt6-tools-dev

#########################
# Copy / Prep Backend
#########################
COPY . /home/servatrice/code/
WORKDIR /home/servatrice/code

#########################
# Build Software
#########################
WORKDIR build
RUN cmake .. -DWITH_SERVER=1\
 -DWITH_CLIENT=0\
 -DWITH_ORACLE=0\
 -DWITH_DBCONVERTER=0
RUN make
RUN make install

WORKDIR /home/servatrice

EXPOSE 4747

ENTRYPOINT ["servatrice --log-to-console"]