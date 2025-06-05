Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9BC2749F0
	for <nvdimm@lists.linux.dev>; Thu,  5 Jun 2025 14:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749133439; cv=none; b=OqU0V5QyubtK0qOvIsv88RPeFmX+/8zXd6IYOEZiTnOzRSU5vL82d4OgTh1HX6/1FDDSlBcioyAEEztestUAhpebBXH/N9M41LUZq3BTaEdzsL3tDLGTlgcK/Z9tDRjjU3F/hoFaaAIpbQbDkJYH30dGsIlSgEpT9wJ5XKbP3o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749133439; c=relaxed/simple;
	bh=Wd6UwPHbh5g8fk5xB/7evE07lpJ7pMuMRzQ/jcJuniY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=glXcvC4dzfWuetlKMZAROtYxiL1S4hzTgIusekDVHaJR/EsHGtUtk2hSIvOEPbGit00VeGShf1My5UwbPSyi+pV6lc3LQS5l5L7pqlq+6ERNpFIY7lw1h1l8tLrZ6bBBuXfW1Ilm8F68Q8ErA5fThNvExKCqKQOOLEmGf51ZGKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D0WibMpl; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D0WibMpl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749133434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sIsclH7WNkkF/JVTKezZJI19OpMaWanv0inQs2KR4wo=;
	b=D0WibMplEtLcfccq8vPrYCcauKRxt68c8Y/E+McTQMca2J0+Xul96vIfUTkh0OrR1VhrO0
	FQC8QFzyv3n8hk2ba6zAyCF+cJYMHpounNKu8Z7Zi93BQl+YW98ZwlwHCm+LUzWG9ckzcf
	nAL/fEH0piBsnlsbdhbBNxDZhUvUIQI=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	Jonathan.Cameron@Huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [RFC PATCH 03/11] dm-pcache: add cache device
Date: Thu,  5 Jun 2025 14:22:58 +0000
Message-Id: <20250605142306.1930831-4-dongsheng.yang@linux.dev>
In-Reply-To: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add cache_dev.{c,h} to manage the persistent-memory device that stores
all pcache metadata and data segments.  Splitting this logic out keeps
the main dm-pcache code focused on policy while cache_dev handles the
low-level interaction with the DAX block device.

* DAX mapping
  - Opens the underlying device via dm_get_device().
  - Uses dax_direct_access() to obtain a direct linear mapping; falls
    back to vmap() when the range is fragmented.

* On-disk layout
  ┌─ 4 KB ─┐  super-block (SB)
  ├─ 4 KB ─┤  cache_info[0]
  ├─ 4 KB ─┤  cache_info[1]
  ├─ 4 KB ─┤  cache_ctrl
  └─ ...  ─┘  segments
  Constants and macros in the header expose offsets and sizes.

* Super-block handling
  - sb_read(), sb_validate(), sb_init() verify magic, CRC32 and host
    endianness (flag *PCACHE_SB_F_BIGENDIAN*).
  - Formatting zeroes the metadata replicas and initialises the segment
    bitmap when the SB is blank.

* Segment allocator
  - Bitmap protected by seg_lock; find_next_zero_bit() yields the next
    free 16 MB segment.

* Lifecycle helpers
  - cache_dev_start()/stop() encapsulate init/exit and are invoked by
    dm-pcache core.
  - Gracefully handles errors: CRC mismatch, wrong endianness, device
    too small (< 512 MB), or failed DAX mapping.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_dev.c | 310 +++++++++++++++++++++++++++++++
 drivers/md/dm-pcache/cache_dev.h |  70 +++++++
 2 files changed, 380 insertions(+)
 create mode 100644 drivers/md/dm-pcache/cache_dev.c
 create mode 100644 drivers/md/dm-pcache/cache_dev.h

diff --git a/drivers/md/dm-pcache/cache_dev.c b/drivers/md/dm-pcache/cache_dev.c
new file mode 100644
index 000000000000..8089518fe5c9
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_dev.c
@@ -0,0 +1,310 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/blkdev.h>
+#include <linux/dax.h>
+#include <linux/vmalloc.h>
+#include <linux/pfn_t.h>
+#include <linux/parser.h>
+
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "cache.h"
+#include "dm_pcache.h"
+
+static void cache_dev_dax_exit(struct pcache_cache_dev *cache_dev)
+{
+	struct dm_pcache *pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+
+	if (cache_dev->use_vmap)
+		vunmap(cache_dev->mapping);
+
+	dm_put_device(pcache->ti, cache_dev->dm_dev);
+}
+
+static int build_vmap(struct dax_device *dax_dev, long total_pages, void **vaddr)
+{
+	struct page **pages;
+	long i = 0, chunk;
+	pfn_t pfn;
+	int ret;
+
+	pages = vmalloc_array(total_pages, sizeof(struct page *));
+	if (!pages)
+		return -ENOMEM;
+
+	do {
+		chunk = dax_direct_access(dax_dev, i, total_pages - i,
+					  DAX_ACCESS, NULL, &pfn);
+		if (chunk <= 0) {
+			ret = chunk ? chunk : -EINVAL;
+			goto out_free;
+		}
+
+		if (!pfn_t_has_page(pfn)) {
+			ret = -EOPNOTSUPP;
+			goto out_free;
+		}
+
+		while (chunk-- && i < total_pages) {
+			pages[i++] = pfn_t_to_page(pfn);
+			pfn.val++;
+			if (!(i & 15))
+				cond_resched();
+		}
+	} while (i < total_pages);
+
+	*vaddr = vmap(pages, total_pages, VM_MAP, PAGE_KERNEL);
+	if (!*vaddr)
+		ret = -ENOMEM;
+out_free:
+	vfree(pages);
+	return ret;
+}
+
+static int cache_dev_dax_init(struct pcache_cache_dev *cache_dev, const char *path)
+{
+	struct dm_pcache	*pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	struct dax_device	*dax_dev;
+	long			total_pages, mapped_pages;
+	u64			bdev_size;
+	void			*vaddr;
+	int			ret, id;
+	pfn_t			pfn;
+
+	ret = dm_get_device(pcache->ti, path,
+			    BLK_OPEN_READ | BLK_OPEN_WRITE, &cache_dev->dm_dev);
+	if (ret) {
+		pcache_dev_err(pcache, "failed to open dm_dev: %s: %d", path, ret);
+		goto err;
+	}
+
+	dax_dev	= cache_dev->dm_dev->dax_dev;
+
+	/* total size check */
+	bdev_size = bdev_nr_bytes(cache_dev->dm_dev->bdev);
+	if (!bdev_size) {
+		ret = -ENODEV;
+		pcache_dev_err(pcache, "device %s has zero size\n", path);
+		goto put_dm;
+	}
+
+	total_pages = bdev_size >> PAGE_SHIFT;
+	/* attempt: direct-map the whole range */
+	id = dax_read_lock();
+	mapped_pages = dax_direct_access(dax_dev, 0, total_pages,
+					 DAX_ACCESS, &vaddr, &pfn);
+	if (mapped_pages < 0) {
+		pcache_dev_err(pcache, "dax_direct_access failed: %ld\n", mapped_pages);
+		ret = mapped_pages;
+		goto unlock;
+	}
+
+	if (!pfn_t_has_page(pfn)) {
+		ret = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if (mapped_pages == total_pages) {
+		/* success: contiguous direct mapping */
+		cache_dev->mapping = vaddr;
+	} else {
+		/* need vmap fallback */
+		ret = build_vmap(dax_dev, total_pages, &vaddr);
+		if (ret) {
+			pcache_dev_err(pcache, "vmap fallback failed: %d\n", ret);
+			goto unlock;
+		}
+
+		cache_dev->mapping	= vaddr;
+		cache_dev->use_vmap	= true;
+	}
+	dax_read_unlock(id);
+
+	return 0;
+unlock:
+	dax_read_unlock(id);
+put_dm:
+	dm_put_device(pcache->ti, cache_dev->dm_dev);
+err:
+	return ret;
+}
+
+void cache_dev_zero_range(struct pcache_cache_dev *cache_dev, void *pos, u32 size)
+{
+	memset(pos, 0, size);
+	dax_flush(cache_dev->dm_dev->dax_dev, pos, size);
+}
+
+static int sb_read(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct pcache_sb *sb_addr = CACHE_DEV_SB(cache_dev);
+
+	if (copy_mc_to_kernel(sb, sb_addr, sizeof(struct pcache_sb)))
+		return -EIO;
+
+	return 0;
+}
+
+static void sb_write(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct pcache_sb *sb_addr = CACHE_DEV_SB(cache_dev);
+
+	memcpy_flushcache(sb_addr, sb, sizeof(struct pcache_sb));
+	pmem_wmb();
+}
+
+static int sb_init(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct dm_pcache *pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	u64 nr_segs;
+	u64 cache_dev_size;
+	u64 magic;
+	u32 flags = 0;
+
+	magic = le64_to_cpu(sb->magic);
+	if (magic)
+		return -EEXIST;
+
+	cache_dev_size = bdev_nr_bytes(file_bdev(cache_dev->dm_dev->bdev_file));
+	if (cache_dev_size < PCACHE_CACHE_DEV_SIZE_MIN) {
+		pcache_dev_err(pcache, "dax device is too small, required at least %llu",
+				PCACHE_CACHE_DEV_SIZE_MIN);
+		return -ENOSPC;
+	}
+
+	nr_segs = (cache_dev_size - PCACHE_SEGMENTS_OFF) / ((PCACHE_SEG_SIZE));
+
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	flags |= PCACHE_SB_F_BIGENDIAN;
+#endif
+	sb->flags = cpu_to_le32(flags);
+	sb->magic = cpu_to_le64(PCACHE_MAGIC);
+	sb->seg_num = cpu_to_le32(nr_segs);
+	sb->crc = cpu_to_le32(crc32(PCACHE_CRC_SEED, (void *)(sb) + 4, sizeof(struct pcache_sb) - 4));
+
+	cache_dev_zero_range(cache_dev, CACHE_DEV_CACHE_INFO(cache_dev),
+			     PCACHE_CACHE_INFO_SIZE * PCACHE_META_INDEX_MAX +
+			     PCACHE_CACHE_CTRL_SIZE);
+
+	return 0;
+}
+
+static int sb_validate(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct dm_pcache *pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	u32 flags;
+	u32 crc;
+
+	if (le64_to_cpu(sb->magic) != PCACHE_MAGIC) {
+		pcache_dev_err(pcache, "unexpected magic: %llx\n",
+				le64_to_cpu(sb->magic));
+		return -EINVAL;
+	}
+
+	crc = crc32(PCACHE_CRC_SEED, (void *)(sb) + 4, sizeof(struct pcache_sb) - 4);
+	if (crc != le32_to_cpu(sb->crc)) {
+		pcache_dev_err(pcache, "corrupted sb: %u, expected: %u\n", crc, le32_to_cpu(sb->crc));
+		return -EINVAL;
+	}
+
+	flags = le32_to_cpu(sb->flags);
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	if (!(flags & PCACHE_SB_F_BIGENDIAN)) {
+		pcache_dev_err(pcache, "cache_dev is not big endian\n");
+		return -EINVAL;
+	}
+#else
+	if (flags & PCACHE_SB_F_BIGENDIAN) {
+		pcache_dev_err(pcache, "cache_dev is big endian\n");
+		return -EINVAL;
+	}
+#endif
+	return 0;
+}
+
+static int cache_dev_init(struct pcache_cache_dev *cache_dev, u32 seg_num)
+{
+	cache_dev->seg_num = seg_num;
+	cache_dev->seg_bitmap = bitmap_zalloc(cache_dev->seg_num, GFP_KERNEL);
+	if (!cache_dev->seg_bitmap)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void cache_dev_exit(struct pcache_cache_dev *cache_dev)
+{
+	bitmap_free(cache_dev->seg_bitmap);
+}
+
+void cache_dev_stop(struct dm_pcache *pcache)
+{
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+
+	cache_dev_exit(cache_dev);
+	cache_dev_dax_exit(cache_dev);
+}
+
+int cache_dev_start(struct dm_pcache *pcache, const char *cache_dev_path)
+{
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+	struct pcache_sb sb;
+	bool format = false;
+	int ret;
+
+	mutex_init(&cache_dev->seg_lock);
+
+	ret = cache_dev_dax_init(cache_dev, cache_dev_path);
+	if (ret) {
+		pcache_dev_err(pcache, "failed to init cache_dev via dax way: %d.", ret);
+		goto err;
+	}
+
+	ret = sb_read(cache_dev, &sb);
+	if (ret)
+		goto dax_release;
+
+	if (le64_to_cpu(sb.magic) == 0) {
+		format = true;
+		ret = sb_init(cache_dev, &sb);
+		if (ret < 0)
+			goto dax_release;
+	}
+
+	ret = sb_validate(cache_dev, &sb);
+	if (ret)
+		goto dax_release;
+
+	cache_dev->sb_flags = le32_to_cpu(sb.flags);
+	ret = cache_dev_init(cache_dev, sb.seg_num);
+	if (ret)
+		goto dax_release;
+
+	if (format)
+		sb_write(cache_dev, &sb);
+
+	return 0;
+
+dax_release:
+	cache_dev_dax_exit(cache_dev);
+err:
+	return ret;
+}
+
+int cache_dev_get_empty_segment_id(struct pcache_cache_dev *cache_dev, u32 *seg_id)
+{
+	int ret;
+
+	mutex_lock(&cache_dev->seg_lock);
+	*seg_id = find_next_zero_bit(cache_dev->seg_bitmap, cache_dev->seg_num, 0);
+	if (*seg_id == cache_dev->seg_num) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
+
+	set_bit(*seg_id, cache_dev->seg_bitmap);
+	ret = 0;
+unlock:
+	mutex_unlock(&cache_dev->seg_lock);
+	return ret;
+}
diff --git a/drivers/md/dm-pcache/cache_dev.h b/drivers/md/dm-pcache/cache_dev.h
new file mode 100644
index 000000000000..3b5249f7128e
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_dev.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_CACHE_DEV_H
+#define _PCACHE_CACHE_DEV_H
+
+#include <linux/device.h>
+#include <linux/device-mapper.h>
+
+#include "pcache_internal.h"
+
+#define PCACHE_MAGIC				0x65B05EFA96C596EFULL
+
+#define PCACHE_SB_OFF				(4 * PCACHE_KB)
+#define PCACHE_SB_SIZE				(4 * PCACHE_KB)
+
+#define PCACHE_CACHE_INFO_OFF			(PCACHE_SB_OFF + PCACHE_SB_SIZE)
+#define PCACHE_CACHE_INFO_SIZE			(4 * PCACHE_KB)
+
+#define PCACHE_CACHE_CTRL_OFF			(PCACHE_CACHE_INFO_OFF + (PCACHE_CACHE_INFO_SIZE * PCACHE_META_INDEX_MAX))
+#define PCACHE_CACHE_CTRL_SIZE			(4 * PCACHE_KB)
+
+#define PCACHE_SEGMENTS_OFF			(PCACHE_CACHE_CTRL_OFF + PCACHE_CACHE_CTRL_SIZE)
+#define PCACHE_SEG_INFO_SIZE			(4 * PCACHE_KB)
+
+#define PCACHE_CACHE_DEV_SIZE_MIN		(512 * PCACHE_MB)	/* 512 MB */
+#define PCACHE_SEG_SIZE				(16 * PCACHE_MB)	/* Size of each PCACHE segment (16 MB) */
+
+#define CACHE_DEV_SB(cache_dev)			((struct pcache_sb *)(cache_dev->mapping + PCACHE_SB_OFF))
+#define CACHE_DEV_CACHE_INFO(cache_dev)		((void *)cache_dev->mapping + PCACHE_CACHE_INFO_OFF)
+#define CACHE_DEV_CACHE_CTRL(cache_dev)		((void *)cache_dev->mapping + PCACHE_CACHE_CTRL_OFF)
+#define CACHE_DEV_SEGMENTS(cache_dev)		((void *)cache_dev->mapping + PCACHE_SEGMENTS_OFF)
+#define CACHE_DEV_SEGMENT(cache_dev, id)	((void *)CACHE_DEV_SEGMENTS(cache_dev) + (u64)id * PCACHE_SEG_SIZE)
+
+/*
+ * PCACHE SB flags configured during formatting
+ *
+ * The PCACHE_SB_F_xxx flags define registration requirements based on cache_dev
+ * formatting. For a machine to register a cache_dev:
+ * - PCACHE_SB_F_BIGENDIAN: Requires a big-endian machine.
+ */
+#define PCACHE_SB_F_BIGENDIAN			BIT(0)
+
+struct pcache_sb {
+	__le32 crc;
+	__le32 flags;
+	__le64 magic;
+
+	__le32 seg_num;
+};
+
+struct pcache_cache_dev {
+	u32				sb_flags;
+	u32				seg_num;
+	void				*mapping;
+	bool				use_vmap;
+
+	struct dm_dev			*dm_dev;
+
+	struct mutex			seg_lock;
+	unsigned long			*seg_bitmap;
+};
+
+struct dm_pcache;
+int cache_dev_start(struct dm_pcache *pcache, const char *cache_dev_path);
+void cache_dev_stop(struct dm_pcache *pcache);
+
+void cache_dev_zero_range(struct pcache_cache_dev *cache_dev, void *pos, u32 size);
+
+int cache_dev_get_empty_segment_id(struct pcache_cache_dev *cache_dev, u32 *seg_id);
+
+#endif /* _PCACHE_CACHE_DEV_H */
-- 
2.34.1

