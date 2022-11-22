FROM ubuntu

RUN apt-get update && apt-get install -y softhsm git-core build-essential cmake libssl-dev libseccomp-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/SUNET/pkcs11-proxy && \
    cd pkcs11-proxy && \
    cmake . && make && make install


RUN echo "0:/var/lib/softhsm/slot0.db" > /etc/softhsm/softhsm.conf 

COPY init.sh /usr/bin

EXPOSE 5657
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:5657"
CMD ["init.sh"]
