Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 9BF161A1EF0
 for <linux-nvdimm@lists.01.org>; Mon,  4 Apr 2016 17:27:13 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: more rpmlint fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 04 Apr 2016 17:26:22 -0700
Message-ID: <20160405002622.3954.59093.stgit@dwillia2-desk3.jf.intel.com>
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

Fedora rpmlint says:
ndctl.src:2: W: mixed-use-of-spaces-and-tabs (spaces: line 1, tab: line 2)
ndctl-libs.x86_64: W: non-standard-group System/Libraries
ndctl-devel.x86_64: W: non-standard-group Development/Libraries/Other
ndctl.x86_64: W: non-standard-group Hardware/Other
ndctl.x86_64: W: incoherent-version-in-changelog an.j.williams@intel.com ['52-1.fc23', '52-1']

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.spec.in |   55 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index e24b31cc54f0..0bdd2463698c 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -1,22 +1,22 @@
-Name:           ndctl
+Name:		ndctl
 Version:	VERSION
-Release:        1%{?dist}
+Release:	1%{?dist}
 Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
-License:        GPLv2
-Group:          Hardware/Other
-Url:            https://github.com/pmem/ndctl
-Source0:        https://github.com/pmem/ndctl/archive/v%{version}.tar.gz
-
-BuildRequires:  autoconf
-BuildRequires:  asciidoc
-BuildRequires:  xmlto
-BuildRequires:  automake
-BuildRequires:  libtool
-BuildRequires:  pkgconfig
-BuildRequires:  pkgconfig(libkmod)
-BuildRequires:  pkgconfig(libudev)
-BuildRequires:  pkgconfig(uuid)
-BuildRequires:  pkgconfig(json-c)
+License:	GPLv2
+Group:		System Environment/Base
+Url:		https://github.com/pmem/ndctl
+Source0:	https://github.com/pmem/ndctl/archive/v%{version}.tar.gz
+
+BuildRequires:	autoconf
+BuildRequires:	asciidoc
+BuildRequires:	xmlto
+BuildRequires:	automake
+BuildRequires:	libtool
+BuildRequires:	pkgconfig
+BuildRequires:	pkgconfig(libkmod)
+BuildRequires:	pkgconfig(libudev)
+BuildRequires:	pkgconfig(uuid)
+BuildRequires:	pkgconfig(json-c)
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -26,10 +26,10 @@ Firmware Interface Table).
 
 
 %package -n DNAME
-Summary:        Development files for libndctl
-License:        LGPLv2
-Group:          Development/Libraries/Other
-Requires:       LNAME%{?_isa} = %{version}-%{release}
+Summary:	Development files for libndctl
+License:	LGPLv2
+Group:		Development/Libraries
+Requires:	LNAME%{?_isa} = %{version}-%{release}
 
 %description -n DNAME
 The %{name}-devel package contains libraries and header files for
@@ -37,9 +37,9 @@ developing applications that use %{name}.
 
 
 %package -n LNAME
-Summary:        Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
-License:        LGPLv2
-Group:          System/Libraries
+Summary:	Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
+License:	LGPLv2
+Group:		System Environment/Libraries
 
 %description -n LNAME
 Libraries for %{name}.
@@ -84,8 +84,5 @@ make check
 %{_libdir}/pkgconfig/libndctl.pc
 
 %changelog
-* Wed Sep 09 2015 dan.j.williams@intel.com
-- Stop emitting git commit info by default
-
-* Mon Aug 03 2015 dan.j.williams@intel.com
-- Initial rpm release
+* Mon Apr 04 2016 Dan Williams <dan.j.williams@intel.com> - 52-1
+- Initial rpm submission to Fedora

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
