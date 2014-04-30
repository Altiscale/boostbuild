#!/bin/bash

curr_dir=`dirname $0`
curr_dir=`cd $curr_dir; pwd`

setup_host="$curr_dir/setup_host.sh"
# Define your application/component name here.
# Define the version of your component in setup_env.sh
yourcomponent=boost
yourcomponent_spec="$curr_dir/${yourcomponent}.spec"

boost_zip_file="$WORKSPACE/boost.tar.gz"
boost_url="http://downloads.sourceforge.net/project/boost/boost/1.46.1/boost_1_46_1.tar.gz"

if [ -f "$curr_dir/setup_env.sh" ]; then
  source "$curr_dir/setup_env.sh"
fi

if [ "x${YOURCOMPONENT}" = "x" ] ; then
  yourcomponent=example
  echo "ok - you may want to define your component name in setup_env.sh with YOUCOMPONENT variable, and set it global during the build process"
else
  yourcomponent="$YOURCOMPONENT"
fi

echo "ok - building component $yourcomponent"

if [ "x${WORKSPACE}" = "x" ] ; then
  WORKSPACE="$curr_dir/../"
  boost_zip_file="$WORKSPACE/boost.tar.gz"
fi

# Perform sanity check
if [ ! -f "$curr_dir/setup_host.sh" ]; then
  echo "warn - $setup_host does not exist, we may not need this if all the libs and RPMs are pre-installed in your build environment"
fi

if [ ! -e "$yourcomponent_spec" ] ; then
  echo "fail - missing $yourcomponent_spec file, can't continue, exiting"
  exit -9
fi

env | sort
# should switch to WORKSPACE, current folder will be in WORKSPACE/yourcomponent due to 
# hadoop_ecosystem_component_build.rb => this script will change directory into your submodule dir
# WORKSPACE is the default path when jenkin launches e.g. /mnt/ebs1/jenkins/workspace/yourcomponent_build_test-alee
# If not, you will be in the $WORKSPACE/yourcomponent folder already, just go ahead and work on the submodule
# The path in the following is all relative, if the parent jenkin config is changed, things may break here.
pushd `pwd`
cd $WORKSPACE

if [ -f "$boost_zip_file" ] ; then
  fhash=$(md5sum "$boost_zip_file" | cut -d" " -f1)
  if [ "x${fhash}" = "x341e5d993b19d099bf1a548495ea91ec" ] ; then
    echo "ok - found prev downloaded file, hash looks good, use it directly"
  else
    echo "warn - boost.tar.gz corrupted with $fhash <> 341e5d993b19d099bf1a548495ea91ec, re-downloading"
    wget --output-document=$(basename $boost_zip_file) "$boost_url"
  fi
else
  echo "ok - downloading boost.tar.gz"
  wget --output-document=$(basename $boost_zip_file) "$boost_url"
fi
# Only applies to Boost installation, delete previous installationif exist.
# This machine shouldn't have existing boost instllation.
if [ -d $WORKSPACE/boost ] ; then
  echo "warn - uninstalling previous version of Boost"
  rm -rf boost
  rm -rf /usr/local/lib/libboost_*
  if [ -d /usr/local/include/boost/ ] ; then
    rm -rf /usr/local/include/boost/
  fi
fi
tar -xvzf boost.tar.gz
mv boost_* boost

echo "ok - switching to component=$yourcomponent and checking out the files"
if [ ! -d "$WORKSPACE/$yourcomponent" ] ; then
  echo "error - can't locate source code $WORKSPACE/$yourcomponent"
  echo "error - did you forgot to check out your source code to $WORKSPACE/$yourcomponent ?"
  echo "error - if you are running the example tutorial, we expect a folder with libs and conf in $WORKSPACE/example/, feel free to customize it."
  exit -9
fi
popd

echo "ok - tar zip source file, preparing for build/compile by rpmbuild"
pushd `pwd`
# yourcomponent is located at $WORKSPACE/$yourcomponent
cd $WORKSPACE

# If you are using the %setup stage, you may need to tarzip your source code here and copy it to the $WORKSPACE/rpmbuild/SOURCES folder later.
# Renaming the folder with prefix alti- here as well.
# cp -r "$yourcomponent" "alti-${yourcomponent}"
# tar cvzf $WORKSPACE/alti-${yourcomponent}.tar.gz "alti-${yourcomponent}"

mkdir -p $WORKSPACE/rpmbuild/{BUILD,BUILDROOT,RPMS,SPECS,SOURCES,SRPMS}/
cp "$yourcomponent_spec" $WORKSPACE/rpmbuild/SPECS/$yourcomponent.spec

# If you are only applying the %prep stage, you can manually copy the folders you need.
cp -r $WORKSPACE/$yourcomponent $WORKSPACE/rpmbuild/SOURCES/$yourcomponent

# Otherwise, if you are using %setup, you may want to copy the tar.gz created before
# cp -r $WORKSPACE/alti-${yourcomponent}.tar.gz $WORKSPACE/rpmbuild/SOURCES/

if [ "$(ls -A $WORKSPACE/patches/)" ]; then
  cp $WORKSPACE/patches/* $WORKSPACE/rpmbuild/SOURCES/
fi
# Explicitly define IMPALA_HOME here for build purpose
rpmbuild -vv -ba $WORKSPACE/rpmbuild/SPECS/$yourcomponent.spec --define "_topdir $WORKSPACE/rpmbuild" --buildroot $WORKSPACE/rpmbuild/BUILDROOT/

if [ $? -ne "0" ] ; then
  echo "fail - RPM build for $yourcomponent failed"
fi

popd

echo "ok - build Completed successfully!"

exit 0












