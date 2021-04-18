FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

#RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\n' > /etc/apt/sources.list


RUN apt-get upgrade
RUN set -ex; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        dbus-x11 \
        nautilus \
        gedit \
        expect \
        sudo \
        bash \
        net-tools \
        novnc \
        xfce4 \
	socat \
	unzip \
        x11vnc \
	xvfb \
        supervisor \
        curl \
        git \
        wget \
        g++ \
	unzip \
        ssh \
	chromium-browser \
	firefox \
        terminator \
        htop \
        gnupg2 \
	locales \
	xfonts-intl-chinese \
	fonts-wqy-microhei \  
	ibus-pinyin \
	ibus \
	ibus-clutter \
	ibus-gtk \
	ibus-gtk3 \
	ibus-qt4 \
	python3-pip \
	python-pip \
	python3-setuptools \
	python-setuptools \
	
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
RUN dpkg-reconfigure locales

# RUN git clone https://github.com/nahamsec/bbht.git
# RUN chmod +x bbht/install.sh
# RUN ./bbht/install.sh

# RUN wget --no-check-certificate -c https://github.com/projectdiscovery/nuclei/releases/download/v2.3.4/nuclei_2.3.4_linux_amd64.tar.gz
# RUN tar -xzvf nuclei_*.tar.gz
# RUN mv nuclei /usr/local/bin/nuclei
# RUN rm nuclei_2.3.4_linux_amd64.tar.gz

# RUN wget --no-check-certificate -c https://github.com/projectdiscovery/httpx/releases/download/v1.0.5/httpx_1.0.5_linux_amd64.tar.gz
# RUN tar -xvf httpx_*.tar.gz
# RUN mv httpx /usr/local/bin/httpx
# RUN rm httpx_1.0.5_linux_amd64.tar.gz
# RUN rm README.md
# RUN pip3 install waybackpy
# RUN git clone https://github.com/projectdiscovery/nuclei-templates.git

# RUN wget --no-check-certificate -c https://github.com/Findomain/Findomain/releases/download/4.0.1/findomain-linux
# RUN chmod +x findomain-linux

# RUN wget --no-check-certificate -c https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
# RUN unzip aquatone_*.zip
# RUN rm aquatone_*.zip
# RUN rm README.md

# RUN wget --no-check-certificate -c https://github.com/ffuf/ffuf/releases/download/v1.2.1/ffuf_1.2.1_linux_amd64.tar.gz
# RUN tar -xzvf ffuf_*.tar.gz
# RUN rm ffuf_*.tar.gz


# RUN git clone https://github.com/devanshbatham/ParamSpider
# RUN pip3 install -r ParamSpider/requirements.txt

COPY . /app
RUN chmod +x /app/conf.d/websockify.sh
RUN chmod +x /app/run.sh
RUN chmod +x /app/expect_vnc.sh
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
RUN echo "deb http://deb.anydesk.com/ all main"  >> /etc/apt/sources.list
RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub -P /app
RUN wget --no-check-certificate -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY -O /app/anydesk.key
RUN apt-key add /app/anydesk.key
RUN apt-key add /app/linux_signing_key.pub
RUN set -ex; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        google-chrome-stable \
	anydesk


ENV UNAME pacat

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes pulseaudio-utils


RUN wget -q -O - https://git.io/vQhTU | bash
RUN /root/.bashrc

# Set up the user
RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio

RUN echo xfce4-session >~/.xsession
RUN echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" 

CMD ["/app/run.sh"]
