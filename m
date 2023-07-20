Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FE514298
	for <nvdimm@lists.linux.dev>; Thu, 20 Jul 2023 07:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689837273; x=1721373273;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=t5Tx1xjKMmZzJYwXq10A5dhCDPrE7RYDBM8wVBgMdO0=;
  b=eqHuCVVJbYZh32OSs44Ei3bBk4kgiz/6SLCY+S+tzPnLj62pYralcdN3
   8sOpb1CkSBFz8/tSjaFb54CnzBAk9B8Awaai4HIhx5lW5te0+r+lFTCcu
   lY8M0NpmRwFDHZwf9pMUPMvvr2cISXmj84aRU6fY10MQbLpmq6h8Aprpz
   kjHE85fdQ4/OC/r+AzLmwnQZIcBK4bLgPqYVcD3DWQBjYgRHXwjTyuxbH
   Cp7PA5loCsMK2e17lp+373N3WVzLXjtq+xdMt97i1IIXIOFJrkeVkoKw7
   laVQj8ziGQdqRcZMJlAeQZhgeSnkd56efgPPxNNlsCX+D/cLHS+UGvtUJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="430424018"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="430424018"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 00:14:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="794334971"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="794334971"
Received: from mfgalan-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.172.204])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 00:14:30 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 20 Jul 2023 01:14:24 -0600
Subject: [PATCH v2 3/3] dax/kmem: allow kmem to add memory with
 memmap_on_memory
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230720-vv-kmem_memmap-v2-3-88bdaab34993@intel.com>
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
In-Reply-To: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4666;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=t5Tx1xjKMmZzJYwXq10A5dhCDPrE7RYDBM8wVBgMdO0=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCk77l35ZGnE8/cqw/EfF2OW2vyb9m391imrjrKf35uns
 3TSlR0d5zpKWRjEuBhkxRRZ/u75yHhMbns+T2CCI8wcViaQIQxcnAIwkVMJDP/U/uSYVR7RlF/V
 lsH2ziKjUffFKtY0pZKjzGzthpadntcY/gcnRfPsPtXH5hbMads97c9Ve8UJTBPzXX+mPOJaE5D
 5hQEA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Large amounts of memory managed by the kmem driver may come in via CXL,
and it is often desirable to have the memmap for this memory on the new
memory itself.

Enroll kmem-managed memory for memmap_on_memory semantics as a default
if other requirements for it are met. Add a sysfs override under the dax
device to opt out of this behavior.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/dax-private.h |  1 +
 drivers/dax/bus.c         | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dax/kmem.c        |  7 ++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 27cf2daaaa79..446617b73aea 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -70,6 +70,7 @@ struct dev_dax {
 	struct ida ida;
 	struct device dev;
 	struct dev_pagemap *pgmap;
+	bool memmap_on_memory;
 	int nr_range;
 	struct dev_dax_range {
 		unsigned long pgoff;
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 0ee96e6fc426..c8e3ea7c674d 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
+#include <linux/memory_hotplug.h>
 #include <linux/memremap.h>
+#include <linux/memory.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
@@ -1269,6 +1271,43 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t memmap_on_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
+}
+
+static ssize_t memmap_on_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_region *dax_region = dev_dax->region;
+	ssize_t rc;
+	bool val;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+
+	if (mhp_supports_memmap_on_memory(memory_block_size_bytes()))
+		dev_dax->memmap_on_memory = val;
+	else
+		rc = -ENXIO;
+
+	device_unlock(dax_region->dev);
+	return rc == 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(memmap_on_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1295,6 +1334,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_memmap_on_memory.attr,
 	NULL,
 };
 
@@ -1400,6 +1440,14 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 	dev_dax->align = dax_region->align;
 	ida_init(&dev_dax->ida);
 
+	/*
+	 * If supported by memory_hotplug, allow memmap_on_memory behavior by
+	 * default. This can be overridden via sysfs before handing the memory
+	 * over to kmem if desired.
+	 */
+	if (mhp_supports_memmap_on_memory(memory_block_size_bytes()))
+		dev_dax->memmap_on_memory = true;
+
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
 	dev->bus = &dax_bus_type;
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 898ca9505754..e6976a79093d 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -56,6 +56,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	unsigned long total_len = 0;
 	struct dax_kmem_data *data;
 	int i, rc, mapped = 0;
+	mhp_t mhp_flags;
 	int numa_node;
 
 	/*
@@ -136,12 +137,16 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 */
 		res->flags = IORESOURCE_SYSTEM_RAM;
 
+		mhp_flags = MHP_NID_IS_MGID;
+		if (dev_dax->memmap_on_memory)
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+
 		/*
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
 		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, MHP_NID_IS_MGID);
+				range_len(&range), kmem_name, mhp_flags);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",

-- 
2.41.0

