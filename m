Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 259BB208AE347
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 18:52:09 -0800 (PST)
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x1F2pJjI007884
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 02:52:08 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 by mx0b-002e3701.pphosted.com with ESMTP id 2qnf8jt9xm-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 02:52:07 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net
 [16.220.97.129])
 by g9t5009.houston.hpe.com (Postfix) with ESMTP id 52CFC58
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 02:52:07 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [ndctl PATCH v2 2/3] autoconf: Check for MAP_SHARED_VALIDATE and
 kernel/glibc conflicts
Date: Thu, 14 Feb 2019 20:57:24 -0600
Message-Id: <20190215025725.19366-2-elliott@hpe.com>
In-Reply-To: <20190215025725.19366-1-elliott@hpe.com>
References: <20190214163422.15221-1-elliott@hpe.com>
 <20190215025725.19366-1-elliott@hpe.com>
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

Some ndctl tests use two new mmap() flags named MAP_SHARED_VALIDATE
and MAP_SYNC that were added by linux kernel-4.15, intended to be
defined for applications by sys/mman.h. However, these do not
always exist; the distro must have glibc-2.28 and the architecture
must support MAP_SYNC.

In glibc-2.28, MAP_SHARED_VALIDATE was incorporated for all
architectures while MAP_SYNC was left out for these:
    alpha hppa mips powerpc sparc tile

See these git://sourceware.org/git/glibc.git commits on 2018-02-06:
    e76def72eb74 ("Add MAP_SYNC from Linux 4.15.")
    92669d6ee3f2 ("Add MAP_SHARED_VALIDATE from Linux 4.15.")

Expand the current check for MAP_SYNC to check both MAP_SHARED_VALIDATE
and MAP_SYNC in <linux/mman.h> and <sys/mman.h> and suggest remedies
for each possible combination of results:
    kernel  glibc  where defined?
      4.14   2.17  neither
      4.14   2.18  neither
      4.15   2.17  <linux/mman.h>
      4.15   2.18  <sys/mman.h> and <linux/mman.h>

Fixes: 94679e6b78aa ("ndctl, test: check availability of MAP_SYNC for poison test")
Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 configure.ac | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 8e57a53..6dca96e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -103,12 +103,30 @@ AS_IF([test "x$enable_test" = "xyes"],
 AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
 
 AC_CHECK_DECLS([BUS_MCEERR_AR], [enable_bus_mc_err=yes], [], [[#include <signal.h>]])
+AC_CHECK_DECLS([MAP_SHARED_VALIDATE], [kernel_map_shared_validate=yes], [], [[#include <linux/mman.h>]])
+AC_CHECK_DECLS([MAP_SYNC], [kernel_map_sync=yes], [], [[#include <linux/mman.h>]])
+AS_UNSET([ac_cv_have_decl_MAP_SHARED_VALIDATE])
+AS_UNSET([ac_cv_have_decl_MAP_SYNC])
+AC_CHECK_DECLS([MAP_SHARED_VALIDATE], [enable_map_shared_validate=yes], [], [[#include <sys/mman.h>]])
 AC_CHECK_DECLS([MAP_SYNC], [enable_map_sync=yes], [], [[#include <sys/mman.h>]])
 
-AS_IF([test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes"],
+if test "x$kernel_map_shared_validate" = "xyes" -a "x$enable_map_shared_validate" != "xyes" ; then
+	AC_MSG_WARN([MAP_SHARED_VALIDATE supported by kernel but not by <sys/mman.h>, consider installing glibc-2.28 or later.])
+fi
+if test "x$kernel_map_shared_validate" != "xyes" -a "x$enable_map_shared_validate" != "xyes" ; then
+	AC_MSG_WARN([MAP_SHARED_VALIDATE not supported by kernel, consider installing kernel-4.15 or later.])
+fi
+if test "x$kernel_map_sync" = "xyes" -a "x$enable_map_sync" != "xyes" ; then
+	AC_MSG_WARN([MAP_SYNC supported by kernel but not by <sys/mman.h>, consider installing glibc-2.28 or later.])
+fi
+if test "x$kernel_map_sync" != "xyes" -a "x$enable_map_sync" != "xyes" ; then
+	AC_MSG_WARN([MAP_SYNC not supported by kernel or architecture, consider installing kernel-4.15 or later.])
+fi
+
+AS_IF([test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes" -a "x$enable_map_shared_validate" = "xyes"],
 	[AC_DEFINE([ENABLE_POISON], [1], [ndctl test poison support])])
 AM_CONDITIONAL([ENABLE_POISON],
-	[test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes"])
+	[test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes" -a "x$enable_map_shared_validate" = "xyes"])
 
 PKG_CHECK_MODULES([KMOD], [libkmod])
 PKG_CHECK_MODULES([UDEV], [libudev])
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
