Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 727811A1DFA
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 14:21:06 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: spec updates for bash-completion + daxctl
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 May 2016 14:20:11 -0700
Message-ID: <146403841098.2905.13403687574617837565.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Install the new bash completion script and define new rpms for
libdaxctl.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am   |    4 ++++
 ndctl.spec.in |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index fee893ce3003..ce1032e3381d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,14 +17,18 @@ noinst_SCRIPTS = rhel/ndctl.spec sles/ndctl.spec
 CLEANFILES += $(noinst_SCRIPTS)
 
 do_rhel_subst = sed -e 's,VERSION,$(VERSION),g' \
+            -e 's,DAX_DNAME,daxctl-devel,g' \
             -e 's,DNAME,ndctl-devel,g' \
             -e '/^%defattr.*/d' \
+	    -e 's,DAX_LNAME,daxctl-libs,g' \
 	    -e 's,LNAME,ndctl-libs,g'
 
 do_sles_subst = sed -e 's,VERSION,$(VERSION),g' \
+            -e 's,DAX_DNAME,libdaxctl-devel,g' \
             -e 's,DNAME,libndctl-devel,g' \
             -e 's,%license,%doc,g' \
             -e 's,\(^License:.*GPL\)v2,\1-2.0,g' \
+            -e "s,DAX_LNAME,libdaxctl$$(($(LIBDAXCTL_CURRENT) - $(LIBDAXCTL_AGE))),g" \
             -e "s,LNAME,libndctl$$(($(LIBNDCTL_CURRENT) - $(LIBNDCTL_AGE))),g"
 
 rhel/ndctl.spec: ndctl.spec.in Makefile.am version.m4
diff --git a/ndctl.spec.in b/ndctl.spec.in
index b8129e533e13..4ed5e726ac75 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -17,6 +17,7 @@ BuildRequires:	pkgconfig(libkmod)
 BuildRequires:	pkgconfig(libudev)
 BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
+BuildRequires:	pkgconfig(bash-completion)
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -35,15 +36,40 @@ Requires:	LNAME%{?_isa} = %{version}-%{release}
 The %{name}-devel package contains libraries and header files for
 developing applications that use %{name}.
 
+%package -n DAX_DNAME
+Summary:	Development files for libdaxctl
+License:	LGPLv2
+Group:		Development/Libraries
+Requires:	LNAME%{?_isa} = %{version}-%{release}
+
+%description -n DAX_DNAME
+The %{name}-devel package contains libraries and header files for
+developing applications that use %{name}, a library for enumerating
+"Device DAX" devices.  Device DAX is a facility for establishing DAX
+mappings of performance / feature-differentiated memory.
+
 
 %package -n LNAME
 Summary:	Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
 License:	LGPLv2
 Group:		System Environment/Libraries
+Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
+
 
 %description -n LNAME
 Libraries for %{name}.
 
+%package -n DAX_LNAME
+Summary:	Management library for "Device DAX" devices
+License:	LGPLv2
+Group:		System Environment/Libraries
+
+%description -n DAX_LNAME
+Device DAX is a facility for establishing DAX mappings of performance /
+feature-differentiated memory. DAX_LNAME provides an enumeration /
+control api for these devices.
+
+
 %prep
 %setup -q ndctl-%{version}
 
@@ -64,11 +90,18 @@ make check
 
 %postun -n LNAME -p /sbin/ldconfig
 
+%post -n DAX_LNAME -p /sbin/ldconfig
+
+%postun -n DAX_LNAME -p /sbin/ldconfig
+
+%define bashcompdir %(pkg-config --variable=completionsdir bash-completion)
+
 %files
 %defattr(-,root,root)
 %license licenses/GPLv2 licenses/BSD-MIT licenses/CC0
 %{_bindir}/ndctl
 %{_mandir}/man1/*
+%{bashcompdir}/ndctl
 
 %files -n LNAME
 %defattr(-,root,root)
@@ -76,6 +109,12 @@ make check
 %license COPYING licenses/BSD-MIT licenses/CC0
 %{_libdir}/libndctl.so.*
 
+%files -n DAX_LNAME
+%defattr(-,root,root)
+%doc README.md
+%license COPYING licenses/BSD-MIT licenses/CC0
+%{_libdir}/libdaxctl.so.*
+
 %files -n DNAME
 %defattr(-,root,root)
 %license COPYING
@@ -83,6 +122,14 @@ make check
 %{_libdir}/libndctl.so
 %{_libdir}/pkgconfig/libndctl.pc
 
+%files -n DAX_DNAME
+%defattr(-,root,root)
+%license COPYING
+%{_includedir}/daxctl/
+%{_libdir}/libdaxctl.so
+%{_libdir}/pkgconfig/libdaxctl.pc
+
+
 %changelog
 * Mon Apr 04 2016 Dan Williams <dan.j.williams@intel.com> - 52-1
 - Initial rpm submission to Fedora

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
