Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FDF3211F8889
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 16:15:33 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 test: check availability of MAP_SYNC for poison test
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 16:05:27 -0700
Message-ID: <153005432756.18809.2045444497326930293.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The poison handling test requires the systems that have both MAP_SYNC
and BUS_MCEERR_AR definitions. Add the missing MAP_SYNC gate for this
test to detect this functionality at build time.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 17b5a657149c..cf4426076c65 100644
--- a/configure.ac
+++ b/configure.ac
@@ -102,10 +102,13 @@ AS_IF([test "x$enable_test" = "xyes"],
 	[AC_DEFINE([ENABLE_TEST], [1], [ndctl test support])])
 AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
 
-AC_CHECK_DECLS([BUS_MCEERR_AR], [enable_poison=yes], [], [[#include <signal.h>]])
-AS_IF([test "x$enable_poison" = "xyes"],
+AC_CHECK_DECLS([BUS_MCEERR_AR], [enable_bus_mc_err=yes], [], [[#include <signal.h>]])
+AC_CHECK_DECLS([MAP_SYNC], [enable_map_sync=yes], [], [[#include <linux/mman.h>]])
+
+AS_IF([test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes"],
 	[AC_DEFINE([ENABLE_POISON], [1], [ndctl test poison support])])
-AM_CONDITIONAL([ENABLE_POISON], [test "x$enable_poison" = "xyes"])
+AM_CONDITIONAL([ENABLE_POISON],
+	[test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes"])
 
 PKG_CHECK_MODULES([KMOD], [libkmod])
 PKG_CHECK_MODULES([UDEV], [libudev])

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
