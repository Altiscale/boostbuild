%define major_ver %(echo ${YOURCOMPONENT_VERSION})
%define service_name boost
%define build_release %(echo ${BUILD_TIME})

Name: %{service_name}
Version: %{major_ver}
Release: %{build_release}%{?dist}
Summary: BOOST (An Optimizing Compiler Infrastructure)
License: http://www.boost.org/users/license.html
Vendor: None (open source)
Group: Development/Compilers
URL: http://boost.org/
Source: %{_sourcedir}/%{service_name}
BuildRoot: %{_tmppath}/%{name}-root
Requires: /sbin/ldconfig
BuildRequires: gcc >= 3.4

%description
BOOST is a compiler infrastructure designed for compile-time, link-time, runtime,
and idle-time optimization of programs from arbitrary programming languages.
BOOST is written in C++ and has been developed since 2000 at the University of
Illinois and Apple. It currently supports compilation of C and C++ programs, 
using front-ends derived from GCC 4.0.1. A new front-end for the C family of
languages is in development. The compiler infrastructure
includes mirror sets of programming tools as well as libraries with equivalent
functionality.

%prep
# copying files into BUILD/impala/ e.g. BUILD/impala/* 
echo "ok - copying files from %{_sourcedir} to folder  %{_builddir}/%{service_name}"
cp -r %{_sourcedir}/%{service_name} %{_builddir}/

#%setup -q -n BOOST-3.3

%build
pushd `pwd`
cd %{_builddir}/%{service_name}/
./bootstrap.sh --prefix=%{buildroot}/usr/local --exec-prefix=%{buildroot}/usr/local

popd

%install
rm -rf %{buildroot}
cd %{_builddir}/%{service_name}/
./bjam --layout=tagged install

#ln -s /usr/local/lib/libboost_date_time-mt.a /usr/local/lib/libboost_date_time.a
#ln -s /usr/local/lib/libboost_date_time-mt.so /usr/local/lib/libboost_date_time.so

%clean
rm -rf %{buildroot}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%defattr(-, root, root)
/usr/local/lib/*
/usr/local/include/boost

%changelog
* Wed Apr 09 2015 Andrew Lee
- Initial working version of RPM spec file. Tweaked from original RPM, and added --with-pic for Impala

