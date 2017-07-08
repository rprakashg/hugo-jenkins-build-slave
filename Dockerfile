FROM golang:1.8.3-alpine

MAINTAINER Ramprakash.Gopinathan@t-mobile.com

ENV HUGO_VERSION 0.25
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit

RUN set -x \
    && apk --no-cache update \
    && apk --no-cache upgrade \
    && apk --no-cache add git bash curl openssh python python-dev py-pip py-pygments openjdk8 wget\
    && ssh-keygen -A \
    && rm -rf /var/cache/apk/* \
    && adduser -D jenkins \
    && echo "jenkins:jenkins" | chpasswd \
    && mkdir -p /var/run/sshd \
    && mkdir /usr/local/hugo \
    && wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz -O /usr/local/hugo/${HUGO_BINARY}.tar.gz \
    && tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
	&& ln -s /usr/local/hugo/hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/local/bin/hugo \
	&& rm /usr/local/hugo/${HUGO_BINARY}.tar.gz \
    && pip install --upgrade pip \
    && pip install awscli \
    && git clone https://github.com/s3tools/s3cmd.git /opt/s3cmd \
    && ln -s /opt/s3cmd/s3cmd /usr/bin/s3cmd 

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

