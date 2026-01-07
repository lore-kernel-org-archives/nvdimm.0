Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AF43A1D08
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800032; cv=none; b=Cc7Bhe+yoXsOGU8e4U/krfH8GNCJMCUuhCioYjRAxQCcVmsFRPvRBeRaiMVU1EsWUmkHE6XR/rRJXecHKgIR+jeSUhNk1ALNAAoxgu04bTbw+gnXb32pEsVg/bel98U448Nk6JU4x+p+pQZqzRlZ6CR20zs18zOHv6AAJgFoX6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800032; c=relaxed/simple;
	bh=XYuMwvSGfsD6m78+ebqdaOLpAZMpGJGzuP5EaFJuLj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM1MoVl2QJXR/D7xRbhf9y41Eo5/5s322DrRHhMJMYJPNUib5pIYirXgvHROLdAysUguJNOhvDJEUNRzEuYG81Ld30qTLISWdT1gvzJLi2utxNh+sbhrqKbeCHZZxaDzAEfP/1y8MapryRQh3XZT1rTbkQg+dzaDejbDehtp6EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XCXi2GoC; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XCXi2GoC"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45358572a11so1325788b6e.3
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800028; x=1768404828; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpTU4sBIkkpSuASPg2mbfPHdAKpdWRtHuhFiIrJI6T0=;
        b=XCXi2GoCMBUs4WFEGmhJHCya4ELvdVLAC6H1IJm78kU76jRGl2E7KXzHUJJQ5uC6jw
         /go0c7EOQ51wy+64C/JYm/q8EB5duh5/2biZn8y5toE+0VIvZFCLb4mbZmtY/hUexKLq
         pBDGxf4O6X+G3eKV98wr/KFS3YwUvCHv4Zm0GWZuZzkwg7YsBG+BJbAdiD8Q/587EhDg
         Y05CgxbkvuUwVpU+DcywEFKQophTBqMMcIAIg+gILJx3zNM6iw7UYTYCAPyxurXNUpl1
         h8supNZhmjraQJfZunzSlNn0VtwfvRCuA0EruXA3/ZXSOFVfg4cqdqIiwQr1bqZvtRzC
         NyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800028; x=1768404828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PpTU4sBIkkpSuASPg2mbfPHdAKpdWRtHuhFiIrJI6T0=;
        b=wx8tW5+FITVdTAAxALvQJgdG8YpOdcZB8ErtbhmPTIxmYiP00gHImTLKxoVrMOtRmy
         3fXwF9BVn1Da9Adw4OBmgxyTRmz3lOjcNM+UkMizK2yoY1IIowuTaI+d9g/xZK/hP9T6
         G2i7PqmEcVsM7qG273ZV7G/W/5AlumcfHCGrRKhqYRRFv4CPzmrC7WU17R/jwqN2w7Wv
         BTgcQSbAfHTaqeZuKteRenxUaeFIk5y8EBD9r1aso40Es6VSxqYnYDZNvxZPxlCRkLO6
         5Aotdt6zds9dsFgOj2bhrmGol90FGz1X6JL0VNiDxaS9pDGdCvkDTunWmIOy0DUy1XEW
         p8bw==
X-Forwarded-Encrypted: i=1; AJvYcCVuIRobW1p7u6JAtNGLr8mAvGNDMc/yLG+cZCd5JZMU96wF8tQCvtLchY/TMrRM0RfLRULjh1U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzz7nFlxeZxhajnA5c5P7l31A/tUvgS2E/bGStMgkfdCzVtlB0g
	S/5UKa83GEFvxag21hLz7KIC9qCwv3wLj0jic3zQv+7/JtSHOFI9O1E8
X-Gm-Gg: AY/fxX5vpg6cdLN2tzTooP545FiXNngIyMotwXppd8+FM+y1WQ0TYonV/0RtU09RZK0
	uy7GRHNrjgYUS/Rfv+8uPvbpdqGl9J1T94XRWYLkEVi22c10CT3yV3/5Nd2WX8b/ICBccM8cFko
	OK+9tIYUx/G/luU5MP51xaeq+cQUOsvRASTddO10d4MnmNZTp+aKcyxG+qulhJTXe2OEz1Wgjol
	IBb0CVSfcfhrU3FHzR8vEL2oddzMzJdYkKKCzzwydJMCSZ9doD5WktqgT5fzBAC0IxWWLdhoMfq
	LpgAs9mnbLKMdOoPmFD77Urd2OoarWVIP7VrGAOKSSKb27b83GK0VcFkr/4M4GD/mHxbcFB5BNp
	NS1T+Kl+CBMHiiltZmL3KoTrdMsbRku169c781S6r0fHezS+BqBLxAbhEPSJVcpRCSgiMSg8unl
	zslz1ZaAZ555imev3plQuc0r3ovD400zFzMupwlL94gSfF
X-Google-Smtp-Source: AGHT+IHPGtjoYX1Si7Gm5rn+aIJuMk4zbmp2FbhjNzf6QxbBnA8l/jsAfKj/acLHvT+M5z4N6tttBA==
X-Received: by 2002:a05:6808:6412:b0:450:cc6d:d4ce with SMTP id 5614622812f47-45a6bf090cdmr1300044b6e.63.1767800028458;
        Wed, 07 Jan 2026 07:33:48 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.33.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:33:48 -0800 (PST)
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
Subject: [PATCH V3 02/21] dax: add fsdev.c driver for fs-dax on character dax
Date: Wed,  7 Jan 2026 09:33:11 -0600
Message-ID: <20260107153332.64727-3-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
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

* bus.h: add DAXDRV_FSDEV_TYPE driver type
* bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
* dax.h: prototype inode_dax(), which fsdev needs

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: John Groves <john@groves.net>
---
 MAINTAINERS          |   8 ++
 drivers/dax/Kconfig  |  17 +++
 drivers/dax/Makefile |   2 +
 drivers/dax/bus.c    |   4 +
 drivers/dax/bus.h    |   1 +
 drivers/dax/fsdev.c  | 276 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h  |   4 +
 7 files changed, 312 insertions(+)
 create mode 100644 drivers/dax/fsdev.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 765ad2daa218..90429cb06090 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7184,6 +7184,14 @@ L:	linux-cxl@vger.kernel.org
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
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index d656e4c0eb84..491325d914a8 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -78,4 +78,21 @@ config DEV_DAX_KMEM
 
 	  Say N if unsure.
 
+config DEV_DAX_FS
+	tristate "FSDEV DAX: fs-dax compatible device driver"
+	depends on DEV_DAX
+	default DEV_DAX
+	help
+	  Support a device-dax driver mode that is compatible with fs-dax
+	  filesystems. Unlike the standard device-dax driver which
+	  pre-initializes compound folios based on device alignment, this
+	  driver leaves folios uninitialized (similar to pmem) allowing
+	  fs-dax to manage folio lifecycles dynamically.
+
+	  This driver uses MEMORY_DEVICE_FS_DAX type and does not set
+	  vmemmap_shift, making it compatible with filesystems like famfs
+	  that use the iomap-based fs-dax infrastructure.
+
+	  Say M if you plan to use fs-dax filesystems on /dev/dax devices.
+	  Say N if you only need raw character device access to DAX memory.
 endif
diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
index 5ed5c39857c8..77aa3df3285c 100644
--- a/drivers/dax/Makefile
+++ b/drivers/dax/Makefile
@@ -4,11 +4,13 @@ obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 obj-$(CONFIG_DEV_DAX_CXL) += dax_cxl.o
+obj-$(CONFIG_DEV_DAX_FS) += fsdev_dax.o
 
 dax-y := super.o
 dax-y += bus.o
 device_dax-y := device.o
 dax_pmem-y := pmem.o
 dax_cxl-y := cxl.o
+fsdev_dax-y := fsdev.o
 
 obj-y += hmem/
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index a2f9a3cc30a5..0d7228acb913 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -84,6 +84,10 @@ static int dax_match_type(const struct dax_device_driver *dax_drv, struct device
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
index 000000000000..2a3249d1529c
--- /dev/null
+++ b/drivers/dax/fsdev.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2026 Micron Technology, Inc. */
+#include <linux/memremap.h>
+#include <linux/pagemap.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/slab.h>
+#include <linux/dax.h>
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
+	int i;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range *range = &dev_dax->ranges[i].range;
+		unsigned long pfn, end_pfn;
+
+		pfn = PHYS_PFN(range->start);
+		end_pfn = PHYS_PFN(range->end) + 1;
+
+		while (pfn < end_pfn) {
+			struct page *page = pfn_to_page(pfn);
+			struct folio *folio = (struct folio *)page;
+			struct dev_pagemap *pgmap = page_pgmap(page);
+			int order = folio_order(folio);
+
+			/*
+			 * Clear any stale mapping pointer. At probe time,
+			 * no filesystem is mounted, so any mapping is stale.
+			 */
+			folio->mapping = NULL;
+			folio->share = 0;
+
+			if (order > 0) {
+				int j;
+
+				folio_reset_order(folio);
+				for (j = 0; j < (1UL << order); j++) {
+					struct page *p = page + j;
+
+					ClearPageHead(p);
+					clear_compound_head(p);
+					((struct folio *)p)->mapping = NULL;
+					((struct folio *)p)->share = 0;
+					((struct folio *)p)->pgmap = pgmap;
+				}
+				pfn += (1UL << order);
+			} else {
+				folio->pgmap = pgmap;
+				pfn++;
+			}
+		}
+	}
+}
+
+static int fsdev_open(struct inode *inode, struct file *filp)
+{
+	struct dax_device *dax_dev = inode_dax(inode);
+	struct dev_dax *dev_dax = dax_get_private(dax_dev);
+
+	dev_dbg(&dev_dax->dev, "trace\n");
+	filp->private_data = dev_dax;
+
+	return 0;
+}
+
+static int fsdev_release(struct inode *inode, struct file *filp)
+{
+	struct dev_dax *dev_dax = filp->private_data;
+
+	dev_dbg(&dev_dax->dev, "trace\n");
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
+			dev_warn(dev,
+				"static pgmap / multi-range device conflict\n");
+			return -EINVAL;
+		}
+
+		pgmap = dev_dax->pgmap;
+	} else {
+		if (dev_dax->pgmap) {
+			dev_warn(dev,
+				 "dynamic-dax with pre-populated page map\n");
+			return -EINVAL;
+		}
+
+		pgmap = devm_kzalloc(dev,
+			struct_size(pgmap, ranges, dev_dax->nr_range - 1),
+				     GFP_KERNEL);
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
+					i, range->start, range->end);
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
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9d624f4d9df6..74e098010016 100644
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
-- 
2.49.0

