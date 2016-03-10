Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 72FFC1A1F6B
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 07:51:56 -0800 (PST)
Subject: [ndctl PATCH] ndctl: add '--disable-docs' option to configure
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Mar 2016 07:51:15 -0800
Message-ID: <20160310155115.29036.52353.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: Arjan van de Ven <arjan@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

For environments that want to build without the documentation add an
option to omit the Documentation/ sub-directory.

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am  |    2 ++
 configure.ac |    9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index ce97a15c7c0d..84582771e97d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,7 @@
 EXTRA_DIST =
+if ENABLE_DOCS
 SUBDIRS = . Documentation
+endif
 CLEANFILES =
 ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
 AM_MAKEFLAGS = --no-print-directory
diff --git a/configure.ac b/configure.ac
index 9506e8e7dd25..96a02d9f9972 100644
--- a/configure.ac
+++ b/configure.ac
@@ -58,6 +58,15 @@ AS_IF([test "x$enable_logging" = "xyes"], [
         AC_DEFINE(ENABLE_LOGGING, [1], [System logging.])
 ])
 
+AC_ARG_ENABLE([docs],
+        AS_HELP_STRING([--disable-docs],
+	[disable documentation build @<:@default=enabled@:>@]),
+        [], enable_docs=yes)
+AS_IF([test "x$enable_docs" = "xyes"], [
+        AC_DEFINE(ENABLE_DOCS, [1], [Documentation / man pages.])
+])
+AM_CONDITIONAL([ENABLE_DOCS], [test "x$enable_docs" = "xyes"])
+
 AC_ARG_ENABLE([debug],
         AS_HELP_STRING([--enable-debug], [enable debug messages @<:@default=disabled@:>@]),
         [], [enable_debug=no])

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
