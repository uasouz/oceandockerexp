FROM node:10.15.0-stretch-slim

RUN apt-get update && \
apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && \
wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb && \
dpkg -i dumb-init_*.deb && rm -f dumb-init_*.deb && \
apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN yarn global add puppeteer@1.11.0 && yarn cache clean

ENV NODE_PATH="/usr/local/share/.config/yarn/global/node_modules:${NODE_PATH}"

ENV PATH="/tools:${PATH}"

RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser


# Install Python and sudo.
RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv procps python-openssl libnss3-tools zenity sudo && \
  rm -rf /var/lib/apt/lists/*
RUN wget "http://ftp.se.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.2l-1~bpo8+1_amd64.deb"
RUN dpkg -i libssl1.0.0_1.0.2l-1~bpo8+1_amd64.deb

# Set language to UTF8
ENV LANG="C.UTF-8"

ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
  && apt install -qqy \
  x11-utils \
  x11-apps \
  openssl \
  libcurl3 \
  libnss3-tools \
  apt-transport-https \
  ca-certificates \
  sudo \
  gnupg \
  hicolor-icon-theme \
  libgl1-mesa-dri \
  libgl1-mesa-glx \
  libpango1.0-0 \
  libpulse0 \
  libv4l-0 \
  fonts-symbola \
  xauth \
  --no-install-recommends \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /home/pptruser/Downloads \
  && chown -R pptruser:pptruser /home/pptruser \
  && echo "pptruser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chmod 0440 /etc/sudoers \
  && passwd -d root


COPY --chown=pptruser:pptruser ./tools /tools

WORKDIR /app

# Add user so we don't need --no-sandbox.
RUN mkdir /screenshots \
	&& mkdir -p /home/pptruser/Downloads \
	&& mkdir -p ./Bradesco \
	&& mkdir -p ./Caixa \
	&& mkdir -p ./Itau \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /usr/local/share/.config/yarn/global/node_modules \
    && chown -R pptruser:pptruser /screenshots \
    && chown -R pptruser:pptruser /app \
    && chown -R pptruser:pptruser /tools \
    # && echo 'pptruser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
	  # && echo 'Defaults !requiretty' >> /etc/sudoers \
  	&& echo root:pptruser | chpasswd

RUN echo exit 0 > /usr/sbin/policy-rc.d

RUN apt-get update && apt-get install -qqy locales locales-all firefox-esr
ENV LC_ALL pt_BR.UTF-8
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8

RUN pip install ofxparse requests

ADD https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup64.deb /warsaw_setup64.deb
# ADD https://guardiao.itau.com.br/warsaw/warsaw_setup_64.deb /warsaw_setup64_itau.deb
# COPY wsold.deb /warsaw_setup64.deb
COPY start.sh start.sh
# COPY index.js index.js
RUN chmod 755 start.sh \
  && ln -s start.sh /usr/local/bin/start.sh
  # Run everything after as non-privileged user.
# RUN dpkg -i /warsaw_setup64.deb && su -c "/etc/init.d/warsaw start" && /usr/local/bin/warsaw/core


USER pptruser

ENV HOME /home/pptruser

ENTRYPOINT ["./start.sh"]


# CMD ["/usr/local/share/.config/yarn/global/node_modules/puppeteer/.local-chromium/linux-526987/chrome-linux/chrome"]

# CMD ["node", "index.js"]
