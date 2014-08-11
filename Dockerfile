###### Jenkins image
# runs jenkins instance within a container
FROM centos:centos6
MAINTAINER "Christian Kniep <christian@qnib.org>"

# Solution for 'ping: icmp open socket: Operation not permitted'
RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime 

RUN yum clean all
RUN yum install -y java-1.7.0-openjdk
RUN curl -s -o /usr/share/jenkins.war  http://ftp.nluug.nl/programming/jenkins/war/1.574/jenkins.war

RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install supervisor
ADD etc/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor
RUN sed -i -e 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf

# SSH keys to log into git-server without a password
ADD root/ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
ADD root/ssh/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 644 /root/.ssh/id_rsa.pub
ADD root/ssh/known_hosts /root/.ssh/known_hosts
RUN chmod 644 /root/.ssh/known_hosts

##### Provide tools to do stuff
# grok testing
RUN yum install -y python-docopt python-simplejson python-envoy rubygems
### WORKAROUND
RUN yum install -y ruby-devel make gcc
#RUN gem install jls-grok
# fpm and git
RUN yum install -y git-core rpm-build createrepo bc
RUN gem install fpm

### Jenkins HOME
RUN mkdir -p /opt/jenkins
ADD etc/supervisord.d /etc/supervisord.d

# QNIB-Build
RUN yum install -y http://mirror.de.leaseweb.net/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum install -y docker-io

# grok-patterns
#RUN pip install docopt envoy

CMD /usr/bin/supervisord -c /etc/supervisord.conf
