Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F8A32AAC6
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426434; cv=none; b=UF1MJ3yR9Easxvpj8HKQn55yzydTnErpXZuqqCooiVe7jYzvfax272IEvMwOf7rCdmpT9LiPqqa1On1uVadeDMFQU62OPbesrJmgnB1EhvY82CAs4oJMJJM9zaCqCLq40llPawjcagtCScHhKWyuW0VkDRtzX/TDWTtVHFzG0Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426434; c=relaxed/simple;
	bh=6iOFQQ79bqcXSs59hkqRnd5nZOGBqQUL3wkhxD/TGyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWBDcdh/sR4v4YgXgk/NiGWn+Pm0wA5DZRxK7faGxcO76pV1O/pysd2CPmeiKE7WFA4xko27uPuGH5Nw896vNBwnUyEYSY9icQWfSRlfLey85iBob8w5clip8yw5jQa2d5+9y86CQvs4EWkZtwUTGvGsG5G4T992h7k+rYV8PRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gLdSA5qK; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLdSA5qK"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7cdd651c884so168215a34.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426431; x=1769031231; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ijPsfKwe0kUKVbjzVLoDsQmd/A3/O0Ncsl7+mSklls=;
        b=gLdSA5qK904iVw8MNRr4b2BLDbNHwMZ+bwIkAOeAZLGOELQDBo/lRq2skDKQDZBtTb
         dnUE/AeENPDY33vk68qEcS1yK4ob8y5NRzBjvizI/MHLwQzLViFrSc7v6ATntnin0Jf8
         BTr95DocD0o8etOOUGDKYW0EVW9XGunoo/Q550eYfOMF++wqVeYwnNxqqlXAIHyf7vTy
         vdTnmzPTiZ9Gg2XlRjMenrZC2Id93uDiQZZU6NOsKNYI0VLVx+yrnv8317nFdydZKNE7
         YOQudT05QU54L9NyBdA9OmBI6tHmw8m5pyfWt1XxVzzEu+MKpVbeZ4RbDcLxe0iwytMU
         sq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426431; x=1769031231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ijPsfKwe0kUKVbjzVLoDsQmd/A3/O0Ncsl7+mSklls=;
        b=i4FPpd6EmJuq0uE2N4gWQaPFVQk944lfgdPj6BR6njEP0GbnqibtX1RXceebAtnjwl
         0nVRoArpN6lyz4hk5HxhHMZjE0sp5rzsBVEXFNaTQxJhM3j+PgyFd2EvJUBURJhDvUbh
         /Rm2HOxcR+/PbZdbn/hh9vVKsPcjWXGyRhxy/1F929TpJmhwrZhVYGKa9QzCXuWkE/X6
         s4kpneRJHEJ3hAq1viODP+jEp/qB1GTK3IyQFJfcVSdjmUyUrHXHpGtK7VAsVBICbzTR
         BPYgIZN1VaXhiVIvfQ2pemKFnxW/WShc32UCucU2gZfsim+sMKDebdy+MWdRf7j6j4Hd
         tQIw==
X-Forwarded-Encrypted: i=1; AJvYcCUyg381abLs4KTiN+bBVi0JHQ6aIcXpyOSSKOCjBrho7ASlpt7ZumMiK/MhUk0wjtSi0aYUJxg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd7eUAeTCoSWg2DJAp4gUHLJyFDB1k268oGuBOV2IEoRJgPNE+
	41JCXDxCHxnGZQ8Rb7fpw/5JkiErCFdgqd0gLH/WvPp0DlndINK7jjh+
X-Gm-Gg: AY/fxX7cl2r09Ke1HgEDS7UxYZeTf3d73oVacxX3jGhqtjkMm8WXlLAuFXbKdMvvrZa
	pvc+cjWK01M9c2KLS+dI9rXRd2joNrhqww3IIGZq6AFAIyws1/n4QnM+tJZOfI2iFh0318L/yl7
	gUZHyq36yJmpQKaAHx1cCZUCIcEgh6nbQz+sPrQnhDOJaQhgFdVXHXWroP/HdlquJLYYXXoBaHg
	r1D7lc7dLak3hqMpHbkzugJSAfqm7pjHNEP/QX6v+/v91jJ9iLDjldsuMxjRI9Oc0OGhQb9Ahqe
	wUnneezDQrGHaVmhih2iWyzzcoklapRZmwsGZi7pLjOOzyWqOpVlxWb4H8+uYy6tlZENpDGbFSE
	bzdqXwSjYiXq8cG6NoyqKE8Hwl5AcbYULIG57tdh65pTtmEaiP0+SWtqw6sqP1yEg4917tvMhJW
	7gacNxaavMwepDZRr4lKJVS3QIlJKdsg38iH1xKXLOPOcl
X-Received: by 2002:a05:6830:81c9:b0:7c7:1a6:6a09 with SMTP id 46e09a7af769-7cfd469cf11mr643762a34.17.1768426431072;
        Wed, 14 Jan 2026 13:33:51 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce47802551sm18803253a34.1.2026.01.14.13.33.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:33:50 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V4 03/19] dax: add fsdev.c driver for fs-dax on character dax
Date: Wed, 14 Jan 2026 15:31:50 -0600
Message-ID: <20260114213209.29453-4-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114213209.29453-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114213209.29453-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 drivers/dax/Makefile |   6 ++
 drivers/dax/bus.c    |   4 +
 drivers/dax/bus.h    |   1 +
 drivers/dax/fsdev.c  | 242 +++++++++++++++++++++++++++++++++++++++++++
 fs/dax.c             |   1 +
 include/linux/dax.h  |   5 +
 7 files changed, 267 insertions(+)
 create mode 100644 drivers/dax/fsdev.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d044a58cbfe..10aa5120d93f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7188,6 +7188,14 @@ L:	linux-cxl@vger.kernel.org
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
index a73f54eac567..e79daf825b52 100644
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
index 000000000000..29b7345f65b1
--- /dev/null
+++ b/drivers/dax/fsdev.c
@@ -0,0 +1,242 @@
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
+	 * driver (e.g., device_dax with vmemmap_shift).
+	 */
+	fsdev_clear_folio_state(dev_dax);
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
index 9d624f4d9df6..fe1315135fdd 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -51,6 +51,10 @@ struct dax_holder_operations {
 
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
+
+#if IS_ENABLED(CONFIG_DEV_DAX_FS)
+struct dax_device *inode_dax(struct inode *inode);
+#endif
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
@@ -153,6 +157,7 @@ static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
 #if IS_ENABLED(CONFIG_FS_DAX)
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
+int dax_folio_reset_order(struct folio *folio);
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
-- 
2.52.0

