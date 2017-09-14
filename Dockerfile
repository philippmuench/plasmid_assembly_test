# DOCKER-VERSION 0.3.4
FROM        perl:latest
MAINTAINER  Philipp Muench (philipp.muench@helmholtz-hzi.de)

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm Bio::Phylo

RUN cpanm -v \
  https://github.com/bioperl/bioperl-live/archive/master.tar.gz

RUN cpanm \
  Bio::ASN1::EntrezGene \
  Bio::SeqIO \
  Time::HiRes

RUN apt-get -qq update && \
  apt-get install -qq -y \
  wget \
  gcc \
  mono-mcs \
  nano \
  git \
  perl \
  curl \
  cmake \
  seqtk \
  zlib1g-dev \
  libboost-all-dev \   
  pkg-config \
  python-setuptools \
  libfreetype6-dev \
  samtools \
  libpng-dev \
  python-matplotlib \
  && rm -rf /var/lib/apt/lists/*

# download SRA toolkit
RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar xvzf sratoolkit.current-ubuntu64.tar.gz
ENV PATH="/root/sratoolkit.2.8.2-1-ubuntu64/bin:$PATH"

# download QUAST
RUN git clone https://github.com/ablab/quast.git && \
cd quast && \
./setup.py install

WORKDIR /root
# download blast
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-x64-linux.tar.gz && \
tar xzf ncbi-blast-2.6.0+-x64-linux.tar.gz
ENV PATH="/root/ncbi-blast-2.6.0+/bin:${PATH}"

# download bwa 
RUN git clone https://github.com/lh3/bwa
WORKDIR bwa
RUN make
ENV PATH="/root/bwa/:${PATH}"

WORKDIR /root
COPY src scr
COPY start.sh start.sh