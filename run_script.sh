#!/bin/bash
JAVA_HOME=$(find /usr/lib/jvm -maxdepth 1 -name "java-*x86_64")
export JAVA_HOME=${JAVA_HOME}
echo "-----------------------------"
echo "STAR_HOME=${STAR_HOME}"
echo "StarRocks Version: ${STAR_VERSION}"
echo "JAVA_HOME=${JAVA_HOME}"
echo "MODE=${MODE}"
echo "-----------------------------"
function start_fe(){
    echo "Start FE On [8030/9010/9020/9030]" 
    ${STAR_HOME}/StarRocks/fe/bin/start_fe.sh --daemon
}
function start_be(){
    echo "Start BE On [8040/8060/9050/9060]" 
    ${STAR_HOME}/StarRocks/be/bin/start_be.sh --daemon 
}
# 同时启动fe/be时
function add_backend(){
    echo "Sleep 30s Wait for startup to complete"
    sleep 30;
    echo "Set BE server IP" 
    IP=$(ifconfig eth0 | grep 'inet' | cut -d: -f2 | awk '{print $2}') 
    mysql -uroot -h${IP} -P 9030 -e "alter system add backend '${IP}:9050';" 
}
function show_ports(){
    sleep 15;
    echo "Show listen ports"  
    echo "$(netstat -lntp)"
}
if [  "${MODE}" == "fe" ];then
    start_fe
    show_ports
elif [ "${MODE}" == "be" ];then
    start_be
    show_ports
else
    start_fe
    start_be
    add_backend
    show_ports
fi

echo "Loop to detect the process"  
while sleep 60; do 
  PID=$(ps -ef|grep starrocks |grep -v grep|awk '{printf $2}')
  if [ "x$PID" == "x" ]; then
    echo "starrocks process already exit."
    exit 1;
  fi
done 