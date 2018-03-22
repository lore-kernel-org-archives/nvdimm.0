Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4636C22631492
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 11:26:54 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/3] Add pkg-config file for NUMA library
Date: Thu, 22 Mar 2018 12:33:22 -0600
Message-Id: <20180322183322.23076-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20180322183322.23076-1-ross.zwisler@linux.intel.com>
References: <20180322183322.23076-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andi Kleen <ak@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This is needed so that other projects can add a dependency on libnuma via
PKG_CHECK_MODULES([NUMA], [numa]).  This enabling makes 'make install' do
the right thing, and of course individual distros will need to add enabling
to their associated packages (rpm, deb, etc.) so the package manager
installs do the right thing.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 .gitignore  |  3 +++
 Makefile.am | 18 ++++++++++++++++++
 numa.pc.in  | 10 ++++++++++
 3 files changed, 31 insertions(+)
 create mode 100644 numa.pc.in

diff --git a/.gitignore b/.gitignore
index 68d5235..8cfe9f8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -59,3 +59,6 @@
 /test-suite.log
 /test/*.log
 /test/*.trs
+
+# pkg-config file
+numa.pc
diff --git a/Makefile.am b/Makefile.am
index b6db339..ac4dc3c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,6 @@
 
 ACLOCAL_AMFLAGS = -I m4
+CLEANFILES =
 
 AM_CPPFLAGS = -Wall
 
@@ -141,3 +142,20 @@ TESTS = \
 # These are known to be broken:
 #	test/prefered
 #	test/randmap
+
+SED_PROCESS = \
+        $(AM_V_GEN)$(SED) \
+        -e 's,@VERSION\@,$(VERSION),g' \
+        -e 's,@prefix\@,$(prefix),g' \
+        -e 's,@exec_prefix\@,$(exec_prefix),g' \
+        -e 's,@libdir\@,$(libdir),g' \
+        -e 's,@includedir\@,$(includedir),g' \
+        < $< > $@ || rm $@
+
+%.pc: %.pc.in Makefile
+	$(SED_PROCESS)
+
+pkgconfigdir = $(libdir)/pkgconfig
+pkgconfig_DATA = numa.pc
+EXTRA_DIST += numa.pc.in
+CLEANFILES += numa.pc
diff --git a/numa.pc.in b/numa.pc.in
new file mode 100644
index 0000000..8a0f202
--- /dev/null
+++ b/numa.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: numa
+Description: NUMA policy library
+Version: @VERSION@
+Cflags: -I${includedir}
+Libs: -L${libdir} -lnuma
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
