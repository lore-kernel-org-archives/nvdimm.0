Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 912E5209605C6
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 00:00:10 -0700 (PDT)
Subject: [PATCH 13/13] libnvdimm,
 namespace: Publish page structure init state / control
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 23:50:13 -0700
Message-ID: <153077341292.40830.11333232703318633087.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Applications may want to know that page structure initialization is
complete rather than be subject to delays at first DAX fault. Also,
page structure initialization consumes CPU resources impacting
application performance, so a environment may want to wait before
considering the system fully initialized.

Provide a sysfs attribute to display the current state, and when
written with 'sync' complete memmap initialization.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   53 +++++++++++++++++++++++++++++++++++----------
 mm/page_alloc.c           |    1 +
 2 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 147c62e2ef2b..00f1792d070c 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -1,15 +1,6 @@
-/*
- * Copyright(c) 2013-2016 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2013-2018 Intel Corporation. All rights reserved. */
+#include <linux/memory_hotplug.h>
 #include <linux/memremap.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
@@ -103,6 +94,43 @@ static ssize_t mode_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(mode);
 
+static ssize_t memmap_state_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
+	struct memmap_async_state *async = &nd_pfn->async;
+
+	return sprintf(buf, "%s\n", bitmap_weight(async->active,
+				NR_MEMMAP_THREADS) ? "active" : "idle");
+}
+
+static ssize_t memmap_state_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int i;
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
+	struct memmap_async_state *async = &nd_pfn->async;
+
+	if (strcmp(buf, "sync") == 0)
+		/* pass */;
+	else if (strcmp(buf, "sync\n") == 0)
+		/* pass */;
+	else
+		return -EINVAL;
+
+	for (i = 0; i < NR_MEMMAP_THREADS; i++) {
+		struct memmap_init_pages *thread = &async->page_init[i];
+
+		if (!test_bit(i, async->active))
+			continue;
+		async_synchronize_cookie_domain(thread->cookie,
+				&memmap_init_domain);
+	}
+
+	return len;
+}
+static DEVICE_ATTR_RW(memmap_state);
+
 static ssize_t align_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -279,6 +307,7 @@ static struct attribute *nd_pfn_attributes[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_size.attr,
 	&dev_attr_supported_alignments.attr,
+	&dev_attr_memmap_state.attr,
 	NULL,
 };
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1466dd82bc2..90414c1d2ca8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5456,6 +5456,7 @@ void __ref build_all_zonelists(pg_data_t *pgdat)
 }
 
 ASYNC_DOMAIN_EXCLUSIVE(memmap_init_domain);
+EXPORT_SYMBOL_GPL(memmap_init_domain);
 
 static void __meminit memmap_init_one(unsigned long pfn, unsigned long zone,
 		int nid, enum memmap_context context, struct dev_pagemap *pgmap)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
