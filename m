Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 687A01A1DFB
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 21:46:26 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: --enable-destructive implies --enable-test
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jul 2016 21:44:02 -0700
Message-ID: <146985384226.31275.12640474468428142434.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Currently the build fails if --enable-destructive is specified without
--enable-test, but --enable-destructive assumes that --enable-test is
already specified.  Just force --enable-test to satisfy the requirement.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 01f4345fa263..126fc6bf16ef 100644
--- a/configure.ac
+++ b/configure.ac
@@ -92,13 +92,6 @@ AS_IF([test "x$enable_debug" = "xyes"], [
         AC_DEFINE(ENABLE_DEBUG, [1], [Debug messages.])
 ])
 
-AC_ARG_ENABLE([test],
-        AS_HELP_STRING([--enable-test], [enable ndctl test command @<:@default=disabled@:>@]),
-        [], [enable_test=no])
-AS_IF([test "x$enable_test" = "xyes"],
-	[AC_DEFINE([ENABLE_TEST], [1], [ndctl test support])])
-AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
-
 AC_ARG_ENABLE([destructive],
         AS_HELP_STRING([--enable-destructive], [enable destructive functional tests @<:@default=disabled@:>@]),
         [], [enable_destructive=no])
@@ -106,6 +99,13 @@ AS_IF([test "x$enable_destructive" = "xyes"],
 	[AC_DEFINE([ENABLE_DESTRUCTIVE], [1], [destructive functional tests support])])
 AM_CONDITIONAL([ENABLE_DESTRUCTIVE], [test "x$enable_destructive" = "xyes"])
 
+AC_ARG_ENABLE([test],
+        AS_HELP_STRING([--enable-test], [enable ndctl test command @<:@default=disabled@:>@]),
+        [], [enable_test=$enable_destructive])
+AS_IF([test "x$enable_test" = "xyes"],
+	[AC_DEFINE([ENABLE_TEST], [1], [ndctl test support])])
+AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
+
 PKG_CHECK_MODULES([KMOD], [libkmod])
 PKG_CHECK_MODULES([UDEV], [libudev])
 PKG_CHECK_MODULES([UUID], [uuid])

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
