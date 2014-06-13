FROM debian:stable
MAINTAINER Tobias Werth <tobias.werth@fau.de>

# make apt aware that we are running it unattended
ENV DEBIAN_FRONTEND noninteractive

# install necessary packages
RUN apt-get update
RUN apt-get install -y git

# install domserver packages
RUN apt-get install -y gcc g++ make zip unzip mysql-server \
	    apache2 php5 php5-cli libapache2-mod-php5 php5-mysql php5-json \
	    bsdmainutils phpmyadmin ntp \
	    libboost-regex-dev libgmp3-dev linuxdoc-tools linuxdoc-tools-text \
	    groff texlive-latex-recommended texlive-latex-extra \
	    texlive-fonts-recommended texlive-lang-dutch

# install packages for submit client
RUN apt-get install -y libcurl4-gnutls-dev libjsoncpp-dev libmagic-dev

# install additional packages for bootstrapping
RUN apt-get install -y autoconf automake flexc++ bisonc++

# install deboostrap+wget for chroot building # FIXME
RUN apt-get install -y debootstrap wget

# install judgehost packages
RUN apt-get install -y make sudo php5-cli php5-curl php5-json procps \
        gcc g++ gcj-jre-headless gcj-jdk openjdk-7-jre-headless openjdk-7-jdk \
        ghc fp-compiler

# install cgroups packages
RUN apt-get install -y libcgroup-dev cgroup-bin

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
