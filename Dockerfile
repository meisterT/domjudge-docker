FROM debian:stable
MAINTAINER Tobias Werth <tobias.werth@fau.de>

# make apt aware that we are running it unattended
ENV DEBIAN_FRONTEND noninteractive

# install necessary packages
RUN apt-get update
RUN apt-get install -y git vim

# install domserver packages
RUN apt-get install -y gcc g++ make zip unzip mysql-server \
        apache2 php php-cli libapache2-mod-php \
        php-gd php-curl php-mysql php-json \
        php-mcrypt php-gmp php-xml php-mbstring \
        bsdmainutils ntp phpmyadmin \
        linuxdoc-tools linuxdoc-tools-text \
        groff texlive-latex-recommended texlive-latex-extra \
        texlive-fonts-recommended texlive-lang-european
RUN a2enmod rewrite

# install packages for submit client
RUN apt-get install -y libcurl4-gnutls-dev libjsoncpp-dev libmagic-dev

# install additional packages for bootstrapping
RUN apt-get install -y autoconf automake git composer

# install judgehost packages
RUN apt-get install -y make sudo debootstrap libcgroup-dev \
        php-cli php-curl php-json procps \
        gcc g++ openjdk-8-jre-headless \
        openjdk-8-jdk ghc fp-compiler

# add and fix chroot
ADD djchroot.tar /
RUN mkdir /chroot && mv /djchroot /chroot/domjudge && chown -R root /chroot

# add repo and install script
ADD domjudge.git.tar /
ADD install.sh /install.sh
RUN /install.sh

# add test and run scripts
ADD run.sh /run.sh
ADD test.sh /test.sh

# forward port to the outside world and set entrypoint
EXPOSE 80
ENTRYPOINT ["/run.sh"]
