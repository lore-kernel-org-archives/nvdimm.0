Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC6828150F
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883773; cv=none; b=gPTTduO6GFQ2GCkoF4VoWDnIqsCqmzU92pZgdS9TanH8XS5U7xy29EMWviMCYkdVWpBjnfe0PEPvudvqXKXpk0pZgLYxN7ZhNYZ7KCcFAXfNF5xhVFdpCM6lJWPFcilliG3BPjzGJEDVvsREIVtKUHWmIUo2tWR8j8wrpDZHCLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883773; c=relaxed/simple;
	bh=9vIO+rt+XUsnHSIjCSY1INSB9v02OfqYgnn2TqubIsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oc2+Inf6x/6vFvmZ4uRV1LS8BHeRYdA+Eex5Cbc4Lz+1+JVMgyIxLjGDlfzpKyJIjs3gS3GagJTm0ic6S2BEvGsfFJMWtDS/hFnEtjys2zbmAXv6LoRee7SBJD/vvqQdXh13zA1iKSaqiRh8McfjXXzLdjOGfJTVGB/NJoTnGp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E63971C039;
	Thu, 19 Mar 2026 01:29:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf16.hostedemail.com (Postfix) with ESMTPA id 25A172001F;
	Thu, 19 Mar 2026 01:29:13 +0000 (UTC)
From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V8 3/8] dax: add fsdev.c driver for fs-dax on character dax
Date: Wed, 18 Mar 2026 20:28:37 -0500
Message-ID: <20260319012837.4443-1-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318202737.4344.dax@groves.net>
References: <20260318202737.4344.dax@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e6ccc3d7nkf8xxo69hzghz8pyn5b7cff
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 25A172001F
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+UoXtTtTu1z1vtoxGSOpwp0nY+sdEkGGI=
X-HE-Tag: 1773883753-857106
X-HE-Meta: U2FsdGVkX1+xIMNFYs1kzJfCY5J1KNIq2mnrrXAD1p0h5JyrL/Og9YQYpecpOHjAkCnxeN7O2O4ycLN52Z3uk/QKHGb9l6U4PXyCEVt7JZ2KaJ+eB0NxnKJ9EJRZozHLBxzJc9B8zEeE3KlQ1RrwKEnOGnOQ+QaRuE921vN2U0AuZPYBC85G00V7g5QzjSU/ZOkcWdInMeW4VvxwZtN8QUrn+DWlaNzO24MyppKUdBE8uL9Gop+xHiZG/8z94i8zlbMkTabj9jnXy2pu2Wh5gB4etGauKHwGoh3SSfehrYzwfuw9i3d6xu3gOPO+/q7TeUNv7+rKRCF4wDXTts3DOU3X96Ujk6W2rED8O+PGJUwZGnIvzAbXpKq9GVI7PcvRgJC6eZBdqt1FYNk2EVkOziUDtbBsoOKOPwd3lU+wRNwJzqW/ddahhY7gCIip5IWxbpNNiila4qdfbMPk0YQ/edrKr2ZWOXDGYywZNlKOXCLOGp6Pp5pKwpl1dEyHsHInDql7qwsKJto=

The new fsdev driver provides pages/folios initialized compatibly with
fsdax - normal rather than devdax-style refcounting, and starting out
with order-0 folios.

When fsdev binds to a daxdev, it is usually (always?) switching from the
devdax mode (device.c), which pre-initializes compound folios according
to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
folios into a fsdax-compatible state.

A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
dax instance. Accordingly, The fsdev driver does not provide raw mmap -
devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
mmap capability.

In this commit is just the framework, which remaps pages/folios compatibly
with fsdax.

Enabling dax changes:

- bus.h: add DAXDRV_FSDEV_TYPE driver type
- bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
- dax.h: prototype inode_dax(), which fsdev needs

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: John Groves <john@groves.net>
---
 MAINTAINERS          |   8 ++
 drivers/dax/Makefile |   6 +
 drivers/dax/bus.c    |   4 +
 drivers/dax/bus.h    |   1 +
 drivers/dax/fsdev.c  | 253 +++++++++++++++++++++++++++++++++++++++++++
 fs/dax.c             |   1 +
 include/linux/dax.h  |   3 +
 7 files changed, 276 insertions(+)
 create mode 100644 drivers/dax/fsdev.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 96ea84948d76..e83cfcf7e932 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7298,6 +7298,14 @@ L:	linux-cxl@vger.kernel.org
 S:	Supported
 F:	drivers/dax/
 
+DEVICE DIRECT ACCESS (DAX) [fsdev_dax]
+M:	John Groves <jgroves@micron.com>
+M:	John Groves <John@Groves.net>
+L:	nvdimm@lists.linux.dev
+L:	linux-cxl@vger.kernel.org
+S:	Supported
+F:	drivers/dax/fsdev.c
+
 DEVICE FREQUENCY (DEVFREQ)
 M:	MyungJoo Ham <myungjoo.ham@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
index 5ed5c39857c8..3bae252fd1bf 100644
--- a/drivers/dax/Makefile
+++ b/drivers/dax/Makefile
@@ -5,10 +5,16 @@ obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 obj-$(CONFIG_DEV_DAX_CXL) += dax_cxl.o
 
+# fsdev_dax: fs-dax compatible devdax driver (needs DEV_DAX and FS_DAX)
+ifeq ($(CONFIG_FS_DAX),y)
+obj-$(CONFIG_DEV_DAX) += fsdev_dax.o
+endif
+
 dax-y := super.o
 dax-y += bus.o
 device_dax-y := device.o
 dax_pmem-y := pmem.o
 dax_cxl-y := cxl.o
+fsdev_dax-y := fsdev.o
 
 obj-y += hmem/
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index e4bd5c9f006c..562e2b06f61a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -81,6 +81,10 @@ static int dax_match_type(const struct dax_device_driver *dax_drv, struct device
 	    !IS_ENABLED(CONFIG_DEV_DAX_KMEM))
 		return 1;
 
+	/* fsdev driver can also bind to device-type dax devices */
+	if (dax_drv->type == DAXDRV_FSDEV_TYPE && type == DAXDRV_DEVICE_TYPE)
+		return 1;
+
 	return 0;
 }
 
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..880bdf7e72d7 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -31,6 +31,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
 enum dax_driver_type {
 	DAXDRV_KMEM_TYPE,
 	DAXDRV_DEVICE_TYPE,
+	DAXDRV_FSDEV_TYPE,
 };
 
 struct dax_device_driver {
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
new file mode 100644
index 000000000000..e5b4396ce401
--- /dev/null
+++ b/drivers/dax/fsdev.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2026 Micron Technology, Inc. */
+#include <linux/memremap.h>
+#include <linux/pagemap.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/slab.h>
+#include <linux/dax.h>
+#include <linux/uio.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include "dax-private.h"
+#include "bus.h"
+
+/*
+ * FS-DAX compatible devdax driver
+ *
+ * Unlike drivers/dax/device.c which pre-initializes compound folios based
+ * on device alignment (via vmemmap_shift), this driver leaves folios
+ * uninitialized similar to pmem. This allows fs-dax filesystems like famfs
+ * to work without needing special handling for pre-initialized folios.
+ *
+ * Key differences from device.c:
+ * - pgmap type is MEMORY_DEVICE_FS_DAX (not MEMORY_DEVICE_GENERIC)
+ * - vmemmap_shift is NOT set (folios remain order-0)
+ * - fs-dax can dynamically create compound folios as needed
+ * - No mmap support - all access is through fs-dax/iomap
+ */
+
+
+static void fsdev_cdev_del(void *cdev)
+{
+	cdev_del(cdev);
+}
+
+static void fsdev_kill(void *dev_dax)
+{
+	kill_dev_dax(dev_dax);
+}
+
+/*
+ * Page map operations for FS-DAX mode
+ * Similar to fsdax_pagemap_ops in drivers/nvdimm/pmem.c
+ *
+ * Note: folio_free callback is not needed for MEMORY_DEVICE_FS_DAX.
+ * The core mm code in free_zone_device_folio() handles the wake_up_var()
+ * directly for this memory type.
+ */
+static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
+		unsigned long pfn, unsigned long nr_pages, int mf_flags)
+{
+	struct dev_dax *dev_dax = pgmap->owner;
+	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
+	u64 len = nr_pages << PAGE_SHIFT;
+
+	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
+					 len, mf_flags);
+}
+
+static const struct dev_pagemap_ops fsdev_pagemap_ops = {
+	.memory_failure		= fsdev_pagemap_memory_failure,
+};
+
+/*
+ * Clear any stale folio state from pages in the given range.
+ * This is necessary because device_dax pre-initializes compound folios
+ * based on vmemmap_shift, and that state may persist after driver unbind.
+ * Since fsdev_dax uses MEMORY_DEVICE_FS_DAX without vmemmap_shift, fs-dax
+ * expects to find clean order-0 folios that it can build into compound
+ * folios on demand.
+ *
+ * At probe time, no filesystem should be mounted yet, so all mappings
+ * are stale and must be cleared along with compound state.
+ */
+static void fsdev_clear_folio_state(struct dev_dax *dev_dax)
+{
+	for (int i = 0; i < dev_dax->nr_range; i++) {
+		struct range *range = &dev_dax->ranges[i].range;
+		unsigned long pfn = PHYS_PFN(range->start);
+		unsigned long end_pfn = PHYS_PFN(range->end) + 1;
+
+		while (pfn < end_pfn) {
+			struct folio *folio = pfn_folio(pfn);
+			int order = dax_folio_reset_order(folio);
+
+			pfn += 1UL << order;
+		}
+	}
+}
+
+static void fsdev_clear_folio_state_action(void *data)
+{
+	fsdev_clear_folio_state(data);
+}
+
+static int fsdev_open(struct inode *inode, struct file *filp)
+{
+	struct dax_device *dax_dev = inode_dax(inode);
+	struct dev_dax *dev_dax = dax_get_private(dax_dev);
+
+	filp->private_data = dev_dax;
+
+	return 0;
+}
+
+static int fsdev_release(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static const struct file_operations fsdev_fops = {
+	.llseek = noop_llseek,
+	.owner = THIS_MODULE,
+	.open = fsdev_open,
+	.release = fsdev_release,
+};
+
+static int fsdev_dax_probe(struct dev_dax *dev_dax)
+{
+	struct dax_device *dax_dev = dev_dax->dax_dev;
+	struct device *dev = &dev_dax->dev;
+	struct dev_pagemap *pgmap;
+	u64 data_offset = 0;
+	struct inode *inode;
+	struct cdev *cdev;
+	void *addr;
+	int rc, i;
+
+	if (static_dev_dax(dev_dax))  {
+		if (dev_dax->nr_range > 1) {
+			dev_warn(dev, "static pgmap / multi-range device conflict\n");
+			return -EINVAL;
+		}
+
+		pgmap = dev_dax->pgmap;
+	} else {
+		size_t pgmap_size;
+
+		if (dev_dax->pgmap) {
+			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
+			return -EINVAL;
+		}
+
+		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
+		pgmap = devm_kzalloc(dev, pgmap_size,  GFP_KERNEL);
+		if (!pgmap)
+			return -ENOMEM;
+
+		pgmap->nr_range = dev_dax->nr_range;
+		dev_dax->pgmap = pgmap;
+
+		for (i = 0; i < dev_dax->nr_range; i++) {
+			struct range *range = &dev_dax->ranges[i].range;
+
+			pgmap->ranges[i] = *range;
+		}
+	}
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range *range = &dev_dax->ranges[i].range;
+
+		if (!devm_request_mem_region(dev, range->start,
+					range_len(range), dev_name(dev))) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
+				 i, range->start, range->end);
+			return -EBUSY;
+		}
+	}
+
+	/*
+	 * FS-DAX compatible mode: Use MEMORY_DEVICE_FS_DAX type and
+	 * do NOT set vmemmap_shift. This leaves folios at order-0,
+	 * allowing fs-dax to dynamically create compound folios as needed
+	 * (similar to pmem behavior).
+	 */
+	pgmap->type = MEMORY_DEVICE_FS_DAX;
+	pgmap->ops = &fsdev_pagemap_ops;
+	pgmap->owner = dev_dax;
+
+	/*
+	 * CRITICAL DIFFERENCE from device.c:
+	 * We do NOT set vmemmap_shift here, even if align > PAGE_SIZE.
+	 * This ensures folios remain order-0 and are compatible with
+	 * fs-dax's folio management.
+	 */
+
+	addr = devm_memremap_pages(dev, pgmap);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
+	/*
+	 * Clear any stale compound folio state left over from a previous
+	 * driver (e.g., device_dax with vmemmap_shift). Also register this
+	 * as a devm action so folio state is cleared on unbind, ensuring
+	 * clean pages for subsequent drivers (e.g., kmem for system-ram).
+	 */
+	fsdev_clear_folio_state(dev_dax);
+	rc = devm_add_action_or_reset(dev, fsdev_clear_folio_state_action,
+				      dev_dax);
+	if (rc)
+		return rc;
+
+	/* Detect whether the data is at a non-zero offset into the memory */
+	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
+		u64 phys = dev_dax->ranges[0].range.start;
+		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
+
+		if (!WARN_ON(pgmap_phys > phys))
+			data_offset = phys - pgmap_phys;
+
+		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
+		       __func__, phys, pgmap_phys, data_offset);
+	}
+
+	inode = dax_inode(dax_dev);
+	cdev = inode->i_cdev;
+	cdev_init(cdev, &fsdev_fops);
+	cdev->owner = dev->driver->owner;
+	cdev_set_parent(cdev, &dev->kobj);
+	rc = cdev_add(cdev, dev->devt, 1);
+	if (rc)
+		return rc;
+
+	rc = devm_add_action_or_reset(dev, fsdev_cdev_del, cdev);
+	if (rc)
+		return rc;
+
+	run_dax(dax_dev);
+	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+}
+
+static struct dax_device_driver fsdev_dax_driver = {
+	.probe = fsdev_dax_probe,
+	.type = DAXDRV_FSDEV_TYPE,
+};
+
+static int __init dax_init(void)
+{
+	return dax_driver_register(&fsdev_dax_driver);
+}
+
+static void __exit dax_exit(void)
+{
+	dax_driver_unregister(&fsdev_dax_driver);
+}
+
+MODULE_AUTHOR("John Groves");
+MODULE_DESCRIPTION("FS-DAX Device: fs-dax compatible devdax driver");
+MODULE_LICENSE("GPL");
+module_init(dax_init);
+module_exit(dax_exit);
+MODULE_ALIAS_DAX_DEVICE(0);
diff --git a/fs/dax.c b/fs/dax.c
index 7d7bbfb32c41..85a4b428e72b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -416,6 +416,7 @@ int dax_folio_reset_order(struct folio *folio)
 
 	return order;
 }
+EXPORT_SYMBOL_GPL(dax_folio_reset_order);
 
 static inline unsigned long dax_folio_put(struct folio *folio)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index bf103f317cac..996493f5c538 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -51,6 +51,7 @@ struct dax_holder_operations {
 
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
+
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
@@ -151,8 +152,10 @@ static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
 #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
 #if IS_ENABLED(CONFIG_FS_DAX)
+struct dax_device *inode_dax(struct inode *inode);
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
+int dax_folio_reset_order(struct folio *folio);
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
-- 
2.53.0

