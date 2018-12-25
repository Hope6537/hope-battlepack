#!/bin/sh

#���ص�����

remoteHost=$1
if [ -z  ${remoteHost} ]
then
   remoteHost="http://hk.hope6537.org:81"
fi

#��VPS���г�ʼ������

#����֧������
echo 'LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en"' >> /etc/environment;

echo '
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_CN.GBK GBK
zh_CN GB2312
' >>  /var/lib/locales/supported.d/local;

sudo locale-gen;

rm -rf /etc/default/locale;

echo 'LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en"' >> /etc/default/locale;

#SSH��Կ
ssh-keygen -t rsa;
touch ~/.ssh/authorized_keys;
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDX+m4Rut1d+yrSvdu/JdlOwTp+aHebUQI9VanBMaDJeJnNsuR7amFc2BQ/jc2NAH7ecbEq3lV4dfW5xTjlid2dJ5aUtQ86BvTl3Cufi2uqjMcTsEn3a8gsW+cxoccKP3bzfKCjqyhbE0tBJrlj0Zw1iFo5nIaHKnfvaS+Gv1tJq7VOMtvVQ0G1tvMY9StgaqCvK4iSvZxz4t5tWD8XshkGnYZ+43A2yOdqy4xk0NDdvkHsxxMWlJPv/q4S9nN4bypAC6ufVLVIhusq4x/g52TvxVkuGA0ZGylJD6eqEnscZRVQvZAnXTl8fvIZ+j3XeWLT4ymJ5koJDenUcKQPZSiB wuyang@wuyang-MBP.local
' >> ~/.ssh/authorized_keys;

#������Ҫ��apt��Դ����������
sudo apt-get update -y;
sudo apt-get upgrade -y;
sudo apt-get install gcc git zsh python expect curl libdnet openssl wget gcc python-dev python-pypcap autoconf automake python3-dev python-gevent python-pip python-m2crypto libxml2-dev libxslt1-dev zlib1g-dev libmysqlclient-dev libxml2-dev libxslt1-dev libssl-dev libffi-dev -y;

#�л��ն�Ϊzsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh;
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc;
chsh -s /bin/zsh;

#��װ��ѧ�����ͻ���
echo '[+] ���ڰ�װpython������'
echo '[+] ��װ��ѧ����'
sudo pip install shadowsocks
sudo touch /etc/shadowsocks.json
sudo echo '{ "server":"0.0.0.0", "server_port":8388, "local_port":1080,"password":"gintama123", "timeout":600, "method":"aes-256-cfb" }' >> /etc/shadowsocks.json;
echo "alias ss.start='ssserver -c /etc/shadowsocks.json -d start'" >> ~/custom_alias;
echo "alias ss.stop='ssserver -c /etc/shadowsocks.json -d stop'" >> ~/custom_alias;

echo '[+] ��װ��ѧ���� v2'
wget --no-check-certificate -O shadowsocks-libev-debian.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-libev-debian.sh
chmod +x shadowsocks-libev-debian.sh
./shadowsocks-libev-debian.sh 2>&1 | tee shadowsocks-libev-debian.log

nohup /usr/local/bin/ss-server -u -c /etc/shadowsocks-libev/config.json &


#������Դ
if [ ! -f ocservauto.sh ]; then
  wget 'http://hk.hope6537.org/ocservauto.sh'
fi
if [ ! -f openvpn-install.sh ]; then
  wget 'https://raw.githubusercontent.com/Hope6537/openvpn-install/master/openvpn-install.sh'
fi
if [ ! -f setup.sh ]; then
  curl -L -O https://raw.github.com/philplckthun/setup-strong-strongswan/master/setup.sh
fi
echo '[+] ���VPN����ű�����'

#��װ����Python������
#pip uninstall mysql-python
#pip uninstall PyQuery
#pip uninstall requests
#pip uninstall scapy
echo '[+] ��װ����Python������ mysql-python PyQuery requests scapy pcapy pypcap numpy scipy opencv'

#sudo pip uninstall mysql-python
#sudo pip uninstall PyQuery
#sudo pip uninstall requests
#sudo pip uninstall scapy

sudo pip install mysql-python
sudo pip install PyQuery
sudo pip install requests
sudo pip install scapy
#pip install numpy
#pip install scipy
#pip install opencv

#��ȡ�������߰�
#����Java
echo '[+] ��������JDK��'
if [ ! -f jdk.tar.gz ]; then
  curl 'http://hk.hope6537.org:81/jdk.tar.gz' >> jdk.tar.gz
fi
echo '[+] ���JDK����,���ڽ�ѹ��shareĿ¼'
tar -xzf jdk.tar.gz -C /usr/local/share/;
echo '[+] ��������������'
echo 'export JAVA_HOME=/usr/local/share/jdk1.8.0_65' >> ~/custom_profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/custom_profile

#����Maven
if [ ! -f maven.tar.gz ]; then
  curl 'http://hk.hope6537.org:81/apache-maven-3.3.3-bin.tar.gz' >> maven.tar.gz;
fi
wget http://hk.hope6537.org:81/settings.xml;
echo '[+] ���Maven����,���m2�ֿ����������ļ�����,�����ƶ���'
tar -xzf maven.tar.gz -C /usr/local/share/;
mkdir ~/.m2/
cp settings.xml ~/.m2/
echo '[+] ��������������'
echo 'export M2_HOME=/usr/local/share/apache-maven-3.3.3' >> ~/custom_profile
echo 'export PATH=$PATH:$M2_HOME/bin' >> ~/custom_profile

#����Tomcat
if [ ! -f tomcat.tar.gz ]; then
  curl 'http://hk.hope6537.org:81/apache-tomcat-8.0.29.tar.gz' >> tomcat.tar.gz;
fi
echo '[+] ���Tomcat����'
tar -xzf tomcat.tar.gz -C /usr/local/share/;
echo '[+] ��������������'
echo 'export CATALINA_HOME=/usr/local/share/apache-tomcat-8.0.29' >> ~/custom_profile
echo 'export PATH=$PATH:$CATALINA_HOME/bin' >> ~/custom_profile

#����Zookeeper
if [ ! -f zookeeper.tar.gz ]; then
  curl 'http://hk.hope6537.org:81/zookeeper.tar.gz' >> zookeeper.tar.gz;
fi
echo '[+] ���Zookeeper����'
tar -xzf zookeeper.tar.gz -C /usr/local/share/;
echo '[+] ����ZookeeperĬ��������'
mkdir ~/zk;
mkdir ~/zk/data;
rm -rf ~/zk/data/myid
touch ~/zk/data/myid
echo '10' >> ~/zk/data/myid
echo '[.] ���zkId����,�����޸������ļ�'
touch /usr/local/share/zookeeper-3.4.7/conf/zoo.cfg
echo 'tickTime=2000
initLimit=10
syncLimit=5
dataDir=/root/zk/data
clientPort=2181
server.1=www.hope6537.com:2555:3555
server.2=ding.hope6537.com:2555:3555
server.10=jp.hope6537.com:2555:3555' >> /usr/local/share/zookeeper-3.4.7/conf/zoo.cfg
echo '[.] ���zk�����ļ���ʼ��'
echo '[+] ��������������'
echo 'export ZK_HOME=/usr/local/share/zookeeper-3.4.7' >> ~/custom_profile
echo 'export PATH=$PATH:$ZK_HOME/bin' >> ~/custom_profile

#����Node
if [ ! -f node.tar.gz ]; then
  curl 'http://hk.hope6537.org:81/node-v5.1.1-linux-x64.tar.gz' >> node.tar.gz;
fi
echo '[+] ���node����'
tar -xzf node.tar.gz -C /usr/local/share/;
echo '[+] ��������������'
echo 'export NODE_HOME=/usr/local/share/node-v5.1.1-linux-x64' >> ~/custom_profile
echo 'export PATH=$PATH:$NODE_HOME/bin' >> ~/custom_profile
echo '[+] ����npm��cnpm'
/usr/local/share/node-v5.1.1-linux-x64/bin/npm install -g cnpm --registry=https://registry.npm.taobao.org


#����Nginx
echo '[-] ��ʼ����Nginx���빹��'
if [ ! -f nginx.tar.gz ]; then
  curl 'http://hk.hope6537.org:81/nginx-1.8.0.tar.gz' >> nginx.tar.gz;
fi
echo '[+] ���nginx����'
if [ ! -f zlib-1.2.8.tar.gz ]; then
wget 'http://hk.hope6537.org:81/zlib-1.2.8.tar.gz'
fi
echo '[+] ���zlib����'

if [ ! -f pcre-8.38.tar.gz ]; then
wget 'http://hk.hope6537.org:81/pcre-8.38.tar.gz'
fi
echo '[+] ���pcre����'
if [ ! -f ngx_cache_purge-2.3.tar.gz ]; then
wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz
fi
echo '[+] ���nginx ��������������'
echo '[+] ���ڽ�ѹһ��nginx�������'
tar -xzf nginx.tar.gz -C /usr/local/share/;
tar -xzf zlib-1.2.8.tar.gz -C /usr/local/share/;

tar -xzf pcre-8.38.tar.gz  -C /usr/local/share/;
tar -xzf solr-5.4.0.tgz -C /usr/local/share;
tar -xzf ngx_cache_purge-2.3.tar.gz -C /usr/local/share;

echo '[+] ���ȱ���pcre'
cd /usr/local/share/pcre-8.38
./configure;
make;
make install;

echo '[+] Ȼ�����zlib'
cd /usr/local/share/zlib-1.2.8
./configure;
make;
make install;

echo '[+]������nginx�Լ�'
cd /usr/local/share/nginx-1.8.0;
 ./configure --add-module=/usr/local/share/ngx_cache_purge-2.3;
make;
make install

echo '[+] ���������ļ���'
cd /usr/local/nginx/conf
wget https://raw.githubusercontent.com/Hope6537/hope-tactical-equipment/master/hope-note-module/hope-config-note/nginx_default_tomcat.conf
wget https://raw.githubusercontent.com/Hope6537/hope-tactical-equipment/master/hope-note-module/hope-config-note/nginx_image_server.conf

cd ~
echo '[+] ��������������'
echo 'export NGINX_HOME=/usr/local/nginx/sbin' >> ~/custom_profile
echo 'export PATH=$PATH:$NGINX_HOME/bin' >> ~/custom_profile
echo "alias nginx.start='/usr/local/nginx/sbin/nginx'" >> ~/custom_alias
echo "alias nginx.stop='/usr/local/nginx/sbin/nginx -s stop'" >> ~/custom_alias


#��װ���ݿ���������

#REDIS ���Ӻͼ�Ⱥ
if [ ! -f redis.tar.gz ]; then
  curl 'http://hk.hope6537.org:81/redis-3.0.5.tar.gz' >> redis.tar.gz;
fi
echo '[+] ���redis����'
tar -xzf redis.tar.gz -C /usr/local/share/;
cd /usr/local/share/redis-3.0.4
echo '[+] ����Redis��'
./configure;
make & make install;
echo '[+] ��ɱ���,������������,����sentinel��������'
echo 'slaveof www.hope6537.com 6379
masterauth redispass
requirepass redispass' >> /etc/redis_slave.conf
echo 'masterauth redispass
requirepass redispass' >> /etc/redis_master.conf
echo '[+] master�����ļ�Ϊ/etc/redis_master.conf,slave�����ļ�Ϊ/etc/redis_slave.conf'
echo '[+] ����sentinel��������'
echo 'port 26379
 sentinel monitor mymaster 172.17.16.7 6379 2
 sentinel auth-pass mymaster redispass
 sentinel down-after-milliseconds mymaster 30000
 sentinel failover-timeout mymaster 900000
 sentinel can-failover mymaster yes
 sentinel parallel-syncs mymaster 1
' >> /etc/sentinel.conf

cd ~
echo "alias redis.start='redis-server /etc/sentinel.conf --sentinel'"

echo '[+] ��������������'
echo 'export REDIS_HOME=/usr/local/share/redis-3.0.4' >> ~/custom_profile
echo 'export PATH=$PATH:$REDIS_HOME/bin' >> ~/custom_profile
echo "alias redis.start='/usr/local/share/redis-3.0.4/src/redis-server /etc/sentinel.conf --sentinel'" >> ~/custom_alias
echo "alias redis.stop='/usr/local/share/redis-3.0.4/src/redis-server stop'" >> ~/custom_alias

#MYSQL��д����

#ElasticSearch

if [ ! -f elasticsearch.tar.gz ]; then
    curl 'http://hk.hope6537.org:81/elasticsearch.tar.gz' >> elasticsearch.tar.gz
fi
echo '[+] ���elasticsearch����'
tar -xzf elasticsearch.tar.gz -C /usr/local/share/;
#Ȼ����Ҫ���һ��elasticsearch�û�
rm -rf /home/elatsicsearch
expect  -c  '
        set timeout 3600;
        spawn adduser elatsicsearch;
        expect "password:"
        send "espasswd\n";
        expect "password:"
        send "espasswd\n";
        expect "Full Name";
        send "es\n";
        expect "Room Number";
        send "es\n";
        expect "Work Phone";
        send "es\n";
        expect "Home Phone";
        send "es\n";
        expect "Other";
        send "es\n";
        expect "correct";
        send Y\n;
        interact;';


#��esĿ¼������Ȩ
#expect  -c 'set timeout 3600; spawn su elatsicsearch expect "password:"; send "espasswd\n"; interact;';
cd /usr/local/share/elasticsearch-rtf/config
rm /usr/local/share/elasticsearch-rtf/config/elasticsearch.yml
wget https://raw.githubusercontent.com/Hope6537/hope-tactical-equipment/master/hope-note-module/hope-config-note/elasticsearch.conf
sudo chown -R elatsicsearch:admin /usr/local/share/elasticsearch-rtf/

echo '[+] ��������������'
echo 'export ES_HOME=/usr/local/share/redis-3.0.4' >> ~/custom_profile
echo 'export PATH=$PATH:$ES_HOME/bin' >> ~/custom_profile
echo "alias es.start='/usr/local/share/elasticsearch-rtf/bin/elasticsearch'" >> ~/custom_alias
echo "alias es.stop='/usr/local/share/elasticsearch-rtf/bin/elasticsearch stop'" >> ~/custom_alias

#����

#����
