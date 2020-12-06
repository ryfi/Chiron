FROM ubuntu:18.04

#################
## SqueezeMeta ##
#################
# sudo docker build -f Dockerfile -t squeezemeta .
# sudo docker build --no-cache -f Dockerfile -t squeezemeta . &> build_status.txt &
# to remove all containers: sudo docker rm $(sudo docker ps -a -q)
#ENV PATH="/root/miniconda3/bin:${PATH}"
#ARG PATH="/root/miniconda3/bin:${PATH}"
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y
RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Install openjdk and Ruby
RUN apt-get update -y
RUN apt-get install openjdk-8-jdk -y
RUN apt-get install ruby -y

# Install R
RUN apt-get install r-base-core -y

# System libraries
RUN apt-get install git sqlite3 libxml2-dev libcurl4-openssl-dev tree -y

# Perl modules
RUN apt-get install libtie-ixhash-perl libclass-dbi-mysql-perl libxml-parser-perl libxml-libxml-perl libdbd-sqlite3-perl -y
RUN cpan Linux::MemInfo
RUN cpan Term::ANSIColor

# Python modules
RUN apt-get install python3-pip python3-dev python3-scipy python3-matplotlib python3-numpy python3-pandas -y
RUN python3 -m pip install future cython
RUN python3 -m pip install dendropy pysam

# R packages
RUN apt-get install libssl-dev
RUN apt-get install r-cran-openssl
RUN R -e "install.packages('doMC', dependencies=TRUE, repos='https://cloud.r-project.org')"
RUN R -e "install.packages('ggplot2', dependencies=TRUE, repos='https://cloud.r-project.org')"
RUN R -e "install.packages('data.table', dependencies=TRUE, repos='https://cloud.r-project.org')"
RUN R -e "install.packages('reshape2', dependencies=TRUE, repos='https://cloud.r-project.org')"
RUN R -e "install.packages('BiocManager', dependencies=TRUE, repos='https://cloud.r-project.org')"
RUN R -e "BiocManager::install('pathview')"
RUN R -e "quit(save='no')"

# Download SqueezeMeta v1.3.0 and unpack
# https://github.com/jtamames/SqueezeMeta/releases/tag/v1.3.0
RUN wget -c https://github.com/jtamames/SqueezeMeta/archive/v1.3.0.tar.gz && tar -xvzf v1.3.0.tar.gz
#ADD https://github.com/jtamames/SqueezeMeta/archive/v1.3.0.tar.gz / && tar -xvzf v1.3.0.tar.gz
RUN R CMD INSTALL SqueezeMeta-1.3.0/bin/DAS_Tool/package/DASTool_1.1.1.tar.gz
RUN R CMD INSTALL SqueezeMeta-1.3.0/lib/SQMtools

# Download test data
RUN mkdir -p /squeezemeta_db
RUN perl /SqueezeMeta-1.3.0/utils/install_utils/make_databases.pl /squeezemeta_db
#RUN perl /SqueezeMeta-1.3.0/utils/install_utils/download_databases.pl /squeezemeta_db
#VOLUME /squeezemeta_db

# Verify that all the dependencies can be located in this environment
RUN perl /SqueezeMeta-1.3.0/utils/install_utils/test_install.pl

# Run SqueezeMeta on test data.
#RUN cd squeezemeta_test_data/test
RUN perl /SqueezeMeta-1.3.0/scripts/SqueezeMeta.pl -m merged -p Hadza -s /squeezemeta_db/test/test.samples -f /squeezemeta_db/test/raw/

# To download and compile databases
#RUN perl /SqueezeMeta-1.3.0/utils/install_utils/make_databases.pl


#cython==0.29.21 future==0.18.2
#python3 -m pip install dendropy==4.5.1 pysam==0.16.0.1
# If intending to use Miniconda environment to install everything using the latest version
#ENV PATH="/root/miniconda3/bin:${PATH}"
#ARG PATH="/root/miniconda3/bin:${PATH}"
#RUN apt-get update
#
#RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*
#
#RUN wget \
#    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#    && mkdir /root/.conda \
#    && bash Miniconda3-latest-Linux-x86_64.sh -b \
#    && rm -f Miniconda3-latest-Linux-x86_64.sh
#RUN conda --version


# https://github.com/jtamames/SqueezeMeta/releases/tag/v1.3.0
