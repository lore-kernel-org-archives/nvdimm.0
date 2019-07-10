Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A79C212B6D53
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jul 2019 11:01:43 -0700 (PDT)
From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH v2] virtio_pmem: fix sparse warning
Date: Wed, 10 Jul 2019 23:28:32 +0530
Message-Id: <20190710175832.17252-1-pagupta@redhat.com>
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
To: virtualization@lists.linux-foundation.org, dan.j.williams@intel.com
Cc: mst@redhat.com, cohuck@redhat.com, linux-kernel@vger.kernel.org, yuval.shaia@oracle.com, lcapitulino@redhat.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch fixes below sparse warning related to __virtio
type in virtio pmem driver. This is reported by Intel test
bot on linux-next tree.

nd_virtio.c:56:28: warning: incorrect type in assignment 
				(different base types)
nd_virtio.c:56:28:    expected unsigned int [unsigned] [usertype] type
nd_virtio.c:56:28:    got restricted __virtio32
nd_virtio.c:93:59: warning: incorrect type in argument 2 
				(different base types)
nd_virtio.c:93:59:    expected restricted __virtio32 [usertype] val
nd_virtio.c:93:59:    got unsigned int [unsigned] [usertype] ret

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---

This fixes a warning, so submitting it as a separate
patch on top of virtio pmem series.

 include/uapi/linux/virtio_pmem.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/virtio_pmem.h b/include/uapi/linux/virtio_pmem.h
index efcd72f2d20d..7a7435281362 100644
--- a/include/uapi/linux/virtio_pmem.h
+++ b/include/uapi/linux/virtio_pmem.h
@@ -10,7 +10,7 @@
 #ifndef _UAPI_LINUX_VIRTIO_PMEM_H
 #define _UAPI_LINUX_VIRTIO_PMEM_H
 
-#include <linux/types.h>
+#include <linux/virtio_types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
@@ -23,12 +23,12 @@ struct virtio_pmem_config {
 
 struct virtio_pmem_resp {
 	/* Host return status corresponding to flush request */
-	__u32 ret;
+	__virtio32 ret;
 };
 
 struct virtio_pmem_req {
 	/* command type */
-	__u32 type;
+	__virtio32 type;
 };
 
 #endif
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
