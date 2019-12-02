# ビジュアルリグレッションテストやってみる
# 参考 https://lifedevops.com/?p=173
# https://qiita.com/dd511805/items/dfe03c5486bf1421875a
FROM python:3.7-slim

RUN mkdir -p /app/dist
WORKDIR /app
RUN apt-get update && \
    apt-get install -y  make automake gcc g++ python3-dev wget gnupg zip libgconf-2-4 iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pip install selenium numpy opencv-python scikit-image imutils

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable   && \
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* && \
    cd /opt && \
    wget https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin


# install font
RUN mkdir /noto
WORKDIR /noto
RUN wget https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
    unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/noto && \
    cp *.otf /usr/share/fonts/noto && \
    chmod 644 -R /usr/share/fonts/noto/ && \
    fc-cache -fv && \
    rm -r /noto

ENV WINDOW_SIZE "1024,768"
ENV BASE_URL ""
ENV DIFF_URL ""

WORKDIR /app



