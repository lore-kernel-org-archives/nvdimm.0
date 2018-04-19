Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F233722637DCF
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 11:22:33 -0700 (PDT)
Subject: [PATCH] dax: allowing MAP_SYNC for device-dax mmap() to succeed
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 19 Apr 2018 11:22:33 -0700
Message-ID: <152416215323.6262.188669847137941145.stgit@djiang5-desk3.ch.intel.com>
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

MAP_SYNC is basically a nop for device-dax. However allowing the MAP_SYNC
flag to succeed on device-dax would make it consistent with fs-dax and
reduces confusion for the application writer. This allows the application to
assume that it does not need to call fsync() after writes to device-dax
mappings.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
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
