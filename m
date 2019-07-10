Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56065211A2DB2
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jul 2019 07:27:18 -0700 (PDT)
From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH] virtio_pmem: fix sparse warning
Date: Wed, 10 Jul 2019 19:57:00 +0530
Message-Id: <20190710142700.10215-1-pagupta@redhat.com>
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

nd_virtio.c:56:28: warning: incorrect type in assignment (different base types)
nd_virtio.c:56:28:    expected unsigned int [unsigned] [usertype] type
nd_virtio.c:56:28:    got restricted __virtio32
nd_virtio.c:93:59: warning: incorrect type in argument 2 (different base types)
nd_virtio.c:93:59:    expected restricted __virtio32 [usertype] val
nd_virtio.c:93:59:    got unsigned int [unsigned] [usertype] ret

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
Reported-by: kbuild test robot <lkp@intel.com>
---

This fixes a warning, so submitting it as a separate
patch on top of virtio pmem series. 
 
 include/uapi/linux/virtio_pmem.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/virtio_pmem.h b/include/uapi/linux/virtio_pmem.h
index efcd72f2d20d..f89129bf1f84 100644
--- a/include/uapi/linux/virtio_pmem.h
+++ b/include/uapi/linux/virtio_pmem.h
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
