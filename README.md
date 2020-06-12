boost
=====

Build specific boost version 1.46.1 RPM for Impala build process.

NOTICE
======

Some minor tweak was made, so the script actually deviates from the Foundry build process and template.


How to Build
============

We need to setup the environment first, login as root, and checkout the code:
,,,
useradd -b /home buildrpm
su - buildrpm
cd /home/buildrpm/
git clone https://github.com/Altiscale/boostbuild.git boostbuild
export WORKSPACE=/home/buildrpm/boostbuild
cd boostbuild/scripts/
./setup_host.sh
./build.sh
,,,

After the build completes, the RPM can be found in this folder.
,,,
/home/buildrpm/rpmbuild/RPMS/
,,,
