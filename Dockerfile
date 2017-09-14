#################################################################
# Dockerfile
#
# Version:          0.0.1
# Software:         OPERA-MS
# Software Version: 0.0.2
# Description:      Long read metagenomic scaffolding pipline that takes in a set of contigs with a set of short and short long reads to output near-complete individual microbial genomes in your environmental sample.
# Website:          https://github.com/CSB5/OPERA-MS
# Tags:             Genomics;Metagenomics
# Provides:         BLASR, racon, OPERA-MS
# Base Image:       ubuntu
#################################################################

FROM muccg/blasr

#Dependencies############################
RUN apt-get update && \
    apt-get install -y build-essential \
        curl \
        make \
        git \
        zlib1g-dev \
        mummer \
        python-numpy \
        python-matplotlib \
        libz-dev \
        unzip \
        bzip2 \
        libncurses-dev \
        wget \
        libhdf5-dev

# Perl ######################################################
RUN curl -L https://cpanmin.us | perl - App::cpanminus && \
    cpanm Statistics::Basic Switch File::Which


# Racon ####################################################
RUN git clone https://github.com/isovic/racon.git /tmp/racon && \
    cd /tmp/racon && \
    make modules && make tools && make -j && \
    ln -s /tmp/racon/bin/racon /usr/local/bin/racon

#OPERA-MS
RUN git clone https://github.com/CSB5/OPERA-MS.git /tmp/OPERA-MS && \
    cd /tmp/OPERA-MS && \
    make

# EMBOSS
RUN apt-get install -y emboss emboss-lib

ENV LD_LIBRARY_PATH=/usr/local/pacbio/lib/:/usr/lib/emboss/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/pacbio/bin:$PATH

#################### INSTALLATION ENDS ##############################
MAINTAINER Wesley GOI <wesley@bic.nus.edu.sg>
