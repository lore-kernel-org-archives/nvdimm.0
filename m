Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C402C203525EC
 for <linux-nvdimm@lists.01.org>; Tue, 14 Aug 2018 16:05:24 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, autoconf: include sys/mman.h for MAP_SYNC
Date: Tue, 14 Aug 2018 17:05:16 -0600
Message-Id: <20180814230516.3139-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Commit 94679e6b78aa ("ndctl, test: check availability of MAP_SYNC for
poison test") added a MAP_SYNC gate for checking its availability at
build time. However the check included linux/mman.h, where as the
canonical location for MAP_SYNC should be sys/mman.h.

Fixes: 94679e6b78aa ("ndctl, test: check availability of MAP_SYNC for poison test")
Reported-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 4441a44..00178bb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -103,7 +103,7 @@ AS_IF([test "x$enable_test" = "xyes"],
 AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
 
 AC_CHECK_DECLS([BUS_MCEERR_AR], [enable_bus_mc_err=yes], [], [[#include <signal.h>]])
-AC_CHECK_DECLS([MAP_SYNC], [enable_map_sync=yes], [], [[#include <linux/mman.h>]])
+AC_CHECK_DECLS([MAP_SYNC], [enable_map_sync=yes], [], [[#include <sys/mman.h>]])
 
 AS_IF([test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes"],
 	[AC_DEFINE([ENABLE_POISON], [1], [ndctl test poison support])])
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
