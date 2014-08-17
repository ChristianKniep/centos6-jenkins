docker-jenkins
==============

Box to run an jenkins instance.


```
mkdir -p -v ${HOME}/jenkins
# this will persit all jenkins data (restart the container does not change a thing)
export DEV_MOUNTS="-v ${HOME}/jenkins:/opt/jenkins/"
# this enables the jenkins instance to start docker-container on the host
# using the unix-socket
export DEV_MOUNTS="${DEV_MOUNTS} -v /var/run/:/run/"
docker run -d -h ${USER}_jenkins --name=${USER}_jenkins \
    ${DEV_MOUNTS} \
    -p 8080:8080 centos6/jenkins
```
