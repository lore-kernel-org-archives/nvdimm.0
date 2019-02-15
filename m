Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 463BB208AE349
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 18:52:10 -0800 (PST)
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x1F2pONu027772
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 02:52:09 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 by mx0b-002e3701.pphosted.com with ESMTP id 2qngjj1tbb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 02:52:09 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net
 [16.220.97.129])
 by g9t5009.houston.hpe.com (Postfix) with ESMTP id 8B4B46B
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 02:52:08 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [ndctl PATCH v2 3/3] ndctl,
 test: Make tests using MAP_SYNC only include <sys/mman.h>
Date: Thu, 14 Feb 2019 20:57:25 -0600
Message-Id: <20190215025725.19366-3-elliott@hpe.com>
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

The kernel-4.15 mmap() manpage defines that MAP_SHARED_VALIDATE and
MAP_SYNC are provided to applications by <sys/mman.h>. This requires
glibc-2.28 and architecture support.

Although they are also available via <linux/mman.h>, that is not the
defined API.

Make tests using it (currently only dax-poison) rely on <sys/mman.h>
by removing inclusion of <linux/mman.h>.

Fixes: e6a1d12d4a6e2 ("ndctl: autoconf detect BUS_MCEERR_AR")
Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 test/dax-poison.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/test/dax-poison.c b/test/dax-poison.c
index a25bf0b..69bb161 100644
--- a/test/dax-poison.c
+++ b/test/dax-poison.c
@@ -5,7 +5,6 @@
 #include <signal.h>
 #include <setjmp.h>
 #include <sys/mman.h>
-#include <linux/mman.h>
 #include <fcntl.h>
 #include <string.h>
 #include <errno.h>
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
