FROM ubuntu:18.04

#################
## SqueezeMeta ##
#################

# Adjust timezome as desired.
# It is necessary to declare this here to avoid errors in R package builds
# that require user input
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
RUN python3 -m pip install dendropy pysam pyyaml

# R packages
RUN apt-get install libssl-dev
RUN apt-get install r-cran-openssl
# Each package install is done separately to help isolate down to individual
# faults should one fail.
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
RUN R CMD INSTALL SqueezeMeta-1.3.0/bin/DAS_Tool/package/DASTool_1.1.1.tar.gz
RUN R CMD INSTALL SqueezeMeta-1.3.0/lib/SQMtools

# Create a directory where we expect to put the database - this can be
# changed, but make sure any calls to use this location are revised.
RUN mkdir -p /squeezemeta_db

# If you wish to download the most recently precompiled database at the
# outset, uncomment the following line:
# RUN perl /SqueezeMeta-1.3.0/utils/install_utils/download_databases.pl /squeezemeta_db

# To download and compile databases
#RUN perl /SqueezeMeta-1.3.0/utils/install_utils/make_databases.pl /squeezemeta_db

# If the SqueezeMeta databases are already built in another location in the
# system, a different copy of SqueezeMeta can be configured to use them with:
# perl /SqueezeMeta-1.3.0/utils/install_utils/configure_nodb.pl /path/to/db
# The above is intended to run along with a "docker -v my/path:/path/to/db" command

# Verify that all the dependencies can be located in this environment
# RUN perl /SqueezeMeta-1.3.0/utils/install_utils/test_install.pl

# Run SqueezeMeta on test data.
# RUN perl /SqueezeMeta-1.3.0/scripts/SqueezeMeta.pl -m merged -p Hadza -s /squeezemeta_db/test/test.samples -f /squeezemeta_db/test/raw/
