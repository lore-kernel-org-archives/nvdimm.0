Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620926;
	b=HWfTl35gZbUmxIB+JgOey0GFwf0QAd+BoF9HMiFR5kFRd5K+Iu03lelv9m6s28NQjP+P
	 7N+cckdE3tL6sGixGop7r9U2ykTMxfBQDod8gmbb6PliTUnpDs+2bbgWvo6+qmZ3nbV3e
	 k9MmWtpx2dmeJ2yLYQSFgvXSl4b/sZcAfXDGeap/bpiFKulTCzct0TTVn5/vZG93UbEMi
	 1BXvWxXpHmYxlQLLZx+oKh36ZkKgTjo0lxQl2pAruUzR4e7klBxUEOKBH67ElDvSdq6vw
	 bHAF3rcGcG9WFpE2mRSDx/dIOqlsz+Jl3K5zw3lsKIppWR9SFNLbrRNC5yWNyxZgdQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BiQwBS2/gR41uglJcjDGNmI+H6Qr25ofWgkYoxBcwCQ=;
	b=HaRUS6LDpiQWLncPnVJ2twJtAP5bJqy/ZYKzrBeI7OyCZoGsFWFVSOaano0CnRVnq4gR
	 Z59gYoKSctkIh2iaL+V0jwJsqSqs4BW4azHPsVaxoTk7R0hFmqzLHeH8JcPCYHYFjmAIY
	 2R50Hfmd7sWsdb+IS4BSIonWsv6Uouw4kRT4THRKHZFmHuTEKNUM1fr4RGhDwM+3SXKxG
	 yhjR/aV4Oo6Wo+WLA2zZf7nc1Zsz7qwk7Cdexi3aex0lUA2TfPCIK1rMpIRIV8F5hYdcL
	 hw2NQN9HJgCeFV8uVx6MDWJ3z/mOY2AtnYcuwBceXjzRfCCYYpEPQZu5Qo0KVCrOcHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linbit.com;
	spf=pass smtp.mailfrom=linbit.com;
	dkim=pass header.d=linbit.com header.i=@linbit.com header.a=rsa-sha256 header.s=google header.b=cUgl18Ny;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A4C606A6B9
	for <nvdimm@lists.linux.dev>; Wed, 25 Nov 2026 15:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6A4C606A6B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit.com header.i=@linbit.com header.a=rsa-sha256 header.s=google header.b=cUgl18Ny
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4acb44dcd7bso5214042f8f.0
        for <nvdimm@lists.linux.dev>; Wed, 25 Nov 2026 07:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit.com; s=google; t=1795620924; x=1796225724; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BiQwBS2/gR41uglJcjDGNmI+H6Qr25ofWgkYoxBcwCQ=;
        b=cUgl18NyYM6maYk8yf8Yl+nrqYH75RLKIcBMCvS3R6Y7da9s/S3K+CINYL2yL8y125
         Wpo2fnM2Ghz4I00dzh/v2g1cpckI5BaojD4bTWHSBkPF8O4sk6n6C2qcG+LMi3JTG55w
         cy7Sruv3zM6CnOo2Hp3wML7PvaLN2f1z/kYkxbo17xTDuZhtvoSK2OKEjVivPyovmxyb
         1NniDGwR8YTqqy/lDFCLi6WxL+zYU59UVD81aQDV8ckRMtTmwRiokIoA1SGJACI78bSp
         j3TcBQGFiWcfwPK8RDokg8RVWIBxSTvY1MTCTbIFefduIL+4jDLN4tYKAsaFIe9xcLQH
         W3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795620924; x=1796225724;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BiQwBS2/gR41uglJcjDGNmI+H6Qr25ofWgkYoxBcwCQ=;
        b=bPIo9Vea+1YgfGy8wqPXcWttn1v9qgnDcK5/a9M3aSSkWo/2DWfk9MDDT+f9CQGK72
         wVqATE7PLZmlqXJQPmqs8sqF6yprYOlKx2XksSKy1MiRdyp1vApSDXEZHal3DN28oGXj
         faP/ctWFglwvYI23s2wzLywp4hFHmtqkQ6PJj/4yOFHdvPbGAYhqvV//Y+/V+OJ3KuhK
         2S1cMHxvQ22Hpn4UEK7SkQSWIFPioHdacO89H6JuRPGeMaoPVawqHHLPNSl/wPHuS7wl
         bcEY/S7BwTFj41c+KpHiypDXiZdhLpNpebWPiFM/K9M7hnDj4/IMy6GnBxwPGxqfppjU
         IcQw==
X-Forwarded-Encrypted: i=1; AL+hErExqZGDs1PGWLDEdsUSGoYB+iZ0gboZYHKI5gvC2nryohUDy0XT8IvWcg7/UY3lPdfRRTJewIM=@lists.linux.dev
X-Gm-Message-State: APuU4Z+SaZf3eazBPtC9Nnle+VhOWQ5whbCZ69oOKNyqjIJ2bM+3r3sM
	D5Arr9zcAH37ffeT3+FBv0Xt3ac7HexgdcHX1BWsNzM2h3FRxZ1kGwT7dkLJv5lN95U=
X-Gm-Gg: AZFdTZeoT1VxxCZpShI8yfBhxgjbWkxhj/VPYXJBQNyszSuM55TGilAqgRV5dBS0nZs
	DOqinwLOnI2BhX++Lg7ijYJ9524gLwdFRRBUmhpd/x8qr4WmYLTqrQCoYFnBILjVjS3MNEtRGhT
	ccGbw6lsXmS3xAA//kMkojfU38E+abb4Lovvlj9b78bFTG9g72GBxnNWQB+KDeMwvTE1cElwrQI
	57/Nybp3OvKICpjnD1nK6AdtSNX/JivDV52TFpY5POnxK5GyB/EhG6lJERUQBDvM7+fehhYCXHv
	tR3HwzXL8MLd65O86qsGigIFmv1ZRETPjfWeWTLwXTB2VTvGK7T4eWxFPP5odfb2629zeY44ihH
	nsALxLmF7soFxPDfpfoOFSfWFa4zubcWjAGX7PFqWpxld5WWAdMeoxyJR729jReqsDO/rKjMfqY
	i0nZ8kVsgLWQBufbRBcRPM60XOpETxw6HjHhzhcxG/S2xe1MTSlz2GClAaJMbqtVKHEVsk3yi86
	FXs0GiW5dJ3VT0nDjzlfp+E/wG/jmM5nNMKth1GZuDQjVbS3UkrR9d3OP1eJDsJAxtyC0ZU1Bj0
	EfLMbROZog4lphT6VBFF/3/8DhO/QKdQ9e69HxOrAYRE2bANaT1d1827AWg/qWUrVFqWXnP3QQ=
	=
X-Received: by 2002:a05:6000:1a86:b0:4ad:d65:aaf9 with SMTP id ffacd0b85a97d-4ad0d65afa1mr37656106f8f.56.1795620924092;
        Wed, 25 Nov 2026 07:35:24 -0800 (PST)
Received: from linbit.com (h082218129081.host.wavenet.at. [82.218.129.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d60sm35816275f8f.3.2026.11.25.07.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:35:23 -0800 (PST)
From: =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v4 07/21] drbd: add DAX/PMEM support for metadata access
Date: Wed, 25 Nov 2026 16:34:57 +0100
Message-ID: <20261125153511.3060599-8-christoph.boehmwalder@linbit.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261125153511.3060599-1-christoph.boehmwalder@linbit.com>
References: <20261125153511.3060599-1-christoph.boehmwalder@linbit.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When DRBD's metadata device resides on persistent memory (PMEM/NVDIMM),
accessing it by reading and writing full blocks is unnecessarily
costly.
Add a DAX-based metadata path that directly maps the metadata region,
enabling byte-granular, IRQ-safe access without having to go through
the block layer.

The PMEM path also introduces a more efficient activity log layout:
instead of writing journal transactions, the in-memory LRU-cache hash
table is stored directly in persistent memory and updated in-place.
Similarly, the resync bitmap is accessed directly from PMEM rather than
being loaded into and flushed from DRAM.

The PMEM path is compiled in when the kernel has filesystem DAX
support (CONFIG_FS_DAX) and the architecture can write CPU caches back
to persistent memory (CONFIG_ARCH_HAS_PMEM_API). The hidden symbol
CONFIG_DRBD_DAX stands for both.

Co-developed-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
---
 drivers/block/drbd/Kconfig         |   4 +
 drivers/block/drbd/Makefile        |   1 +
 drivers/block/drbd/drbd_dax_pmem.c | 175 +++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_dax_pmem.h |  43 +++++++
 4 files changed, 223 insertions(+)
 create mode 100644 drivers/block/drbd/drbd_dax_pmem.c
 create mode 100644 drivers/block/drbd/drbd_dax_pmem.h

diff --git a/drivers/block/drbd/Kconfig b/drivers/block/drbd/Kconfig
index 615516941fb7..fbf1d5011aa3 100644
--- a/drivers/block/drbd/Kconfig
+++ b/drivers/block/drbd/Kconfig
@@ -99,3 +99,7 @@ config BLK_DEV_DRBD_TCP_TLS
 	  https://github.com/oracle/ktls-utils.
 
 	  If unsure, say N.
+
+config DRBD_DAX
+	def_bool y
+	depends on BLK_DEV_DRBD && FS_DAX && ARCH_HAS_PMEM_API
diff --git a/drivers/block/drbd/Makefile b/drivers/block/drbd/Makefile
index 9f05f74e619c..750202bce516 100644
--- a/drivers/block/drbd/Makefile
+++ b/drivers/block/drbd/Makefile
@@ -5,6 +5,7 @@ drbd-y += drbd_main.o drbd_strings.o drbd_nl.o
 drbd-y += drbd_interval.o drbd_state.o
 drbd-y += drbd_nl_gen.o
 drbd-y += drbd_transport.o
+drbd-$(CONFIG_DRBD_DAX) += drbd_dax_pmem.o
 drbd-$(CONFIG_DEBUG_FS) += drbd_debugfs.o
 
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
diff --git a/drivers/block/drbd/drbd_dax_pmem.c b/drivers/block/drbd/drbd_dax_pmem.c
new file mode 100644
index 000000000000..1fb22e57cf5d
--- /dev/null
+++ b/drivers/block/drbd/drbd_dax_pmem.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017, LINBIT HA-Solutions GmbH.
+ */
+
+/*
+ * In case DRBD's meta-data resides in persistent memory do a few things
+ * different.
+ *
+ * 1 direct access the bitmap in place. Do not load it into DRAM, do not
+ *   write it back from DRAM.
+ * 2 Use a better fitting format for the on-disk activity log. Instead of
+ *   writing transactions, the unmangled LRU-cache hash table is there.
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/dax.h>
+#include <linux/libnvdimm.h>
+#include <linux/blkdev.h>
+#include <linux/sizes.h>
+#include "drbd_int.h"
+#include "drbd_dax_pmem.h"
+#include "drbd_meta_data.h"
+
+/*
+ * Unit conversions for addressing the metadata area through DAX.
+ * DRBD keeps metadata offsets in sectors, dax_direct_access() works in pages.
+ */
+static pgoff_t md_sector_to_pgoff(sector_t sector)
+{
+	return sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+}
+
+static long md_sectors_to_pages(sector_t nr_sectors)
+{
+	return nr_sectors >> (PAGE_SHIFT - SECTOR_SHIFT);
+}
+
+/* Signed, since the bitmap offset relative to the superblock may be negative. */
+static long md_sector_offset_to_bytes(long sector_offset)
+{
+	return sector_offset * SECTOR_SIZE;
+}
+
+static int map_superblock_for_dax(struct drbd_backing_dev *bdev, struct dax_device *dax_dev)
+{
+	long want = 1;
+	pgoff_t pgoff = md_sector_to_pgoff(bdev->md.md_offset);
+	void *kaddr;
+	long len;
+	int id;
+
+	id = dax_read_lock();
+	len = dax_direct_access(dax_dev, pgoff, want, DAX_ACCESS, &kaddr, NULL);
+	dax_read_unlock(id);
+
+	if (len < want)
+		return -EIO;
+
+	bdev->md_on_pmem = kaddr;
+
+	return 0;
+}
+
+/**
+ * drbd_dax_open() - Open device for dax and map metadata superblock
+ * @bdev: backing device to be opened
+ */
+int drbd_dax_open(struct drbd_backing_dev *bdev)
+{
+	struct dax_device *dax_dev;
+	int err;
+	u64 part_off;
+
+	dax_dev = fs_dax_get_by_bdev(bdev->md_bdev, &part_off, NULL, NULL);
+	if (!dax_dev)
+		return -ENODEV;
+
+	err = map_superblock_for_dax(bdev, dax_dev);
+	if (!err)
+		bdev->dax_dev = dax_dev;
+	else
+		put_dax(dax_dev);
+
+	return err;
+}
+
+void drbd_dax_close(struct drbd_backing_dev *bdev)
+{
+	put_dax(bdev->dax_dev);
+}
+
+/**
+ * drbd_dax_map() - Map metadata for dax
+ * @bdev: backing device whose metadata is to be mapped
+ */
+int drbd_dax_map(struct drbd_backing_dev *bdev)
+{
+	struct dax_device *dax_dev = bdev->dax_dev;
+	sector_t first_sector = drbd_md_first_sector(bdev);
+	sector_t al_sector = bdev->md.md_offset + bdev->md.al_offset;
+	long want = md_sectors_to_pages(drbd_md_last_sector(bdev) + 1 - first_sector);
+	pgoff_t pgoff = md_sector_to_pgoff(first_sector);
+	long md_offset_byte = md_sector_offset_to_bytes(bdev->md.md_offset - first_sector);
+	long al_offset_byte = md_sector_offset_to_bytes(al_sector - first_sector);
+	void *kaddr;
+	long len;
+	int id;
+
+	id = dax_read_lock();
+	len = dax_direct_access(dax_dev, pgoff, want, DAX_ACCESS, &kaddr, NULL);
+	dax_read_unlock(id);
+
+	if (len < want)
+		return -EIO;
+
+	bdev->md_on_pmem = kaddr + md_offset_byte;
+	bdev->al_on_pmem = kaddr + al_offset_byte;
+
+	return 0;
+}
+
+void drbd_dax_al_update(struct drbd_device *device, struct lc_element *al_ext)
+{
+	struct al_on_pmem *al_on_pmem = device->ldev->al_on_pmem;
+	__be32 *slot = &al_on_pmem->slots[al_ext->lc_index];
+
+	*slot = cpu_to_be32(al_ext->lc_new_number);
+	arch_wb_cache_pmem(slot, sizeof(*slot));
+}
+
+void drbd_dax_al_begin_io_commit(struct drbd_device *device)
+{
+	struct lc_element *e;
+
+	spin_lock_irq(&device->al_lock);
+
+	list_for_each_entry(e, &device->act_log->to_be_changed, list)
+		drbd_dax_al_update(device, e);
+
+	lc_committed(device->act_log);
+
+	spin_unlock_irq(&device->al_lock);
+}
+
+int drbd_dax_al_initialize(struct drbd_device *device)
+{
+	struct al_on_pmem *al_on_pmem = device->ldev->al_on_pmem;
+	__be32 *slots = al_on_pmem->slots;
+	/* The activity log area holds the magic followed by the slots. */
+	int i, al_slots = device->ldev->md.al_size_4k * (SZ_4K / sizeof(*slots)) - 1;
+
+	al_on_pmem->magic = cpu_to_be32(DRBD_AL_PMEM_MAGIC);
+	/*
+	 * Initialize all slots rather than just the configured number in case
+	 * the configuration is later changed.
+	 */
+	for (i = 0; i < al_slots; i++) {
+		unsigned int extent_nr = i < device->act_log->nr_elements ?
+			lc_element_by_index(device->act_log, i)->lc_number :
+			LC_FREE;
+		slots[i] = cpu_to_be32(extent_nr);
+	}
+
+	return 0;
+}
+
+void *drbd_dax_bitmap(struct drbd_device *device, unsigned long want)
+{
+	struct drbd_backing_dev *bdev = device->ldev;
+	unsigned char *md_on_pmem = (unsigned char *)bdev->md_on_pmem;
+
+	return md_on_pmem + md_sector_offset_to_bytes(bdev->md.bm_offset);
+}
diff --git a/drivers/block/drbd/drbd_dax_pmem.h b/drivers/block/drbd/drbd_dax_pmem.h
new file mode 100644
index 000000000000..8e3ecf74a557
--- /dev/null
+++ b/drivers/block/drbd/drbd_dax_pmem.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2017, LINBIT HA-Solutions GmbH.
+ */
+#ifndef DRBD_DAX_H
+#define DRBD_DAX_H
+
+#include <linux/kconfig.h>
+
+#if IS_ENABLED(CONFIG_DRBD_DAX)
+
+int drbd_dax_open(struct drbd_backing_dev *bdev);
+void drbd_dax_close(struct drbd_backing_dev *bdev);
+int drbd_dax_map(struct drbd_backing_dev *bdev);
+void drbd_dax_al_update(struct drbd_device *device, struct lc_element *al_ext);
+void drbd_dax_al_begin_io_commit(struct drbd_device *device);
+int drbd_dax_al_initialize(struct drbd_device *device);
+void *drbd_dax_bitmap(struct drbd_device *device, unsigned long want);
+
+static inline bool drbd_md_dax_active(struct drbd_backing_dev *bdev)
+{
+	return bdev->dax_dev != NULL;
+}
+static inline struct meta_data_on_disk_9 *drbd_dax_md_addr(struct drbd_backing_dev *bdev)
+{
+	return bdev->md_on_pmem;
+}
+#else
+
+#define drbd_dax_open(B) do { } while (0)
+#define drbd_dax_close(B) do { } while (0)
+#define drbd_dax_map(B) (-ENOTSUPP)
+#define drbd_dax_al_begin_io_commit(D) do { } while (0)
+#define drbd_dax_al_initialize(D) (-EIO)
+#define drbd_dax_bitmap(D, L) (NULL)
+#define drbd_md_dax_active(B) (false)
+#define drbd_dax_md_addr(B) (NULL)
+
+#define arch_wb_cache_pmem(A, L) do { } while (0)
+
+#endif /* IS_ENABLED(CONFIG_DRBD_DAX) */
+
+#endif /* DRBD_DAX_H */
-- 
2.56.0

