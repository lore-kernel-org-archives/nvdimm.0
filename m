Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4AC93201B0441
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 08:28:54 -0800 (PST)
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
 by mx0a-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x1EGCwm4014032
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 16:28:53 GMT
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 by mx0a-002e3701.pphosted.com with ESMTP id 2qnbac8cka-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 16:28:53 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net
 [16.220.97.129])
 by g4t3425.houston.hpe.com (Postfix) with ESMTP id F2464A8
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 16:28:52 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [ndctl PATCH 1/2] autoconf: Check for MAP_SHARED_VALIDATE
Date: Thu, 14 Feb 2019 10:34:21 -0600
Message-Id: <20190214163422.15221-1-elliott@hpe.com>
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
defined for applications by sys/mman.h. However, these do not exist
unless the distro has glibc-2.28.

In addition to the existing check for MAP_SYNC, check that
MAP_SHARED_VALIDATE is provided.

Fixes: 94679e6b78aa ("ndctl, test: check availability of MAP_SYNC for poison test")
Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 configure.ac | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index d27a2b1..efbdcde 100644
--- a/configure.ac
+++ b/configure.ac
@@ -103,12 +103,13 @@ AS_IF([test "x$enable_test" = "xyes"],
 AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
 
 AC_CHECK_DECLS([BUS_MCEERR_AR], [enable_bus_mc_err=yes], [], [[#include <signal.h>]])
+AC_CHECK_DECLS([MAP_SHARED_VALIDATE], [enable_map_shared_validate=yes], [], [[#include <sys/mman.h>]])
 AC_CHECK_DECLS([MAP_SYNC], [enable_map_sync=yes], [], [[#include <sys/mman.h>]])
 
-AS_IF([test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes"],
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
