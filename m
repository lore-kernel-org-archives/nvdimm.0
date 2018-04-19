Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCB4621EBD1BF
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 13:39:44 -0700 (PDT)
Subject: [PATCH v2] dax: allow MAP_SYNC for device-dax mmap() to succeed
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 19 Apr 2018 13:39:43 -0700
Message-ID: <152417033504.18702.8933921557309052260.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

MAP_SYNC is a nop for device-dax. Allow MAP_SYNC to succeed on device-dax
to eliminate special casing between device-dax and fs-dax as to when the
flag can be specified. Device-dax users already implicitly assume that they do
not need to call fsync(), and this enables them to explicitly check for this
capability.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2: update commit message with suggestion from Dan.

 drivers/dax/device.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 37be5a306c8f..374b6718f6c5 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -19,6 +19,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/mman.h>
 #include "dax-private.h"
 #include "dax.h"
 
@@ -530,6 +531,7 @@ static const struct file_operations dax_fops = {
 	.release = dax_release,
 	.get_unmapped_area = dax_get_unmapped_area,
 	.mmap = dax_mmap,
+	.mmap_supported_flags = MAP_SYNC,
 };
 
 static void dev_dax_release(struct device *dev)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
