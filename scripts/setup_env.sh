#!/bin/bash

# TBD: honor system pre-defined property/variable files from 
# /etc/hadoop/ and other /etc config for spark, hdfs, hadoop, etc

if [ "x${JAVA_HOME}" = "x" ] ; then
  export JAVA_HOME=/usr/java/default
fi
if [ "x${ANT_HOME}" = "x" ] ; then
  export ANT_HOME=/opt/apache-ant
fi
if [ "x${MAVEN_HOME}" = "x" ] ; then
  export MAVEN_HOME=/opt/apache-maven
fi
if [ "x${M2_HOME}" = "x" ] ; then
  export M2_HOME=/opt/apache-maven
fi
if [ "x${M2}" = "x" ] ; then
  export M2=${M2_HOME}/bin
fi
if [ "x${MAVEN_OPTS}" = "x" ] ; then
  export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=1024m"
fi
if [ "x${SCALA_HOME}" = "x" ] ; then
  export SCALA_HOME=/opt/scala
fi
if [ "x${HADOOP_HOME}" = "x" ] ; then
  export HADOOP_HOME=/opt/hadoop
fi
if [ "x${HADOOP_CONF_DIR}" = "x" ] ; then
  export HADOOP_CONF_DIR=/etc/hadoop
fi

export PATH=$PATH:$M2_HOME/bin:$SCALA_HOME/bin:$ANT_HOME/bin:$JAVA_HOME/bin

# Define defau;t spark uid:gid and build version
# WARNING: the YOURCOMPONENT_VERSION branch name does not align with the Git branch name branch-0.8 / trunk
if [ "x${YOURCOMPONENT}" = "x" ] ; then
  export YOURCOMPONENT=boost
fi

if [ "x${YOURCOMPONENT_USER}" = "x" ] ; then
  export YOURCOMPONENT_USER=$YOURCOMPONENT
fi
if [ "x${YOURCOMPONENT_VERSION}" = "x" ] ; then
  export YOURCOMPONENT_VERSION=1.46.1
fi
if [ "x${ALTISCALE_RELEASE}" = "x" ] ; then
  export ALTISCALE_RELEASE=2.0.0
fi

# The build time here is par tof the release number
# It is monotonic increasing
BUILD_TIME=$(date +%Y%m%d%H%M)
export BUILD_TIME

# Customize build OPTS for MVN
export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=1024m"




