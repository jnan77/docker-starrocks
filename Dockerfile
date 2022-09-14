FROM centos:7
LABEL author="jnan77" github="https://github.com/jnan77"
ENV LANG=zh_CN.UTF-8
ENV TZ="Asia/Shanghai"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& yum install -y curl \
&& mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
&& curl -s https://mirrors.aliyun.com/repo/Centos-7.repo -o /etc/yum.repos.d/CentOS-Base.repo \
&& yum clean all && yum makecache && yum -y install net-tools telnet mysql java-1.8.0-openjdk-devel.x86_64
#
ENV STAR_VERSION=2.3.0
ENV STAR_HOME=/data/deploy
#ARG STAR_ROCKS_URL=http://10.0.1.21:89/StarRocks-${STAR_VERSION}.tar.gz
ARG STAR_ROCKS_URL=https://download.starrocks.com/zh-CN/download/request-download/42/StarRocks-${STAR_VERSION}.tar.gz

COPY run_script.sh /data/deploy/run_script.sh
WORKDIR ${STAR_HOME}
RUN mkdir -p ${STAR_HOME} \
&& curl -s ${STAR_ROCKS_URL} -o StarRocks-${STAR_VERSION}.tar.gz \
&& tar zxvf StarRocks-${STAR_VERSION}.tar.gz && rm -rf StarRocks-${STAR_VERSION}.tar.gz \
&& mv StarRocks-${STAR_VERSION} StarRocks \
&& echo "StarRocks VERSION ${STAR_VERSION}">VERSION \
&& chmod +x /data/deploy/run_script.sh

CMD /data/deploy/run_script.sh
EXPOSE 8030 8040 9030 9050
VOLUME [ "/data/deploy/StarRocks/fe/meta","/data/deploy/StarRocks/be/storage" ]


