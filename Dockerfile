FROM alpine:latest

USER root
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk --no-cache add git bash openssh
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    echo "*" > /root/.ssh/config && \
    echo "    StrictHostKeyChecking no" >> /root/.ssh/config

WORKDIR /workdir
COPY ./update_index.sh ./
CMD [ "./update_index.sh" ]

