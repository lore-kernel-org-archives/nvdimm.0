Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B235FEE6
	for <nvdimm@lists.linux.dev>; Thu,  5 Jun 2025 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749133435; cv=none; b=lVj5j/b7fVQc2+Cr73clhKtBuJhAfow3LXM/mKc22NghVHXXu/9I1LJTKUhs3uQZh7RbzOQTthmA/PgFOdUsQWPqp1IlvBN9ruofpE2r7e0K5VK+gWxh06llfIqxqHMuOXDRdybbpXA5kDjGOfHadxVsi7ei4ffGUIbBUu8+e9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749133435; c=relaxed/simple;
	bh=cVqSblQRPUMKuxExdj6fRaq3ounZ01k/ElYFHjbgK58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCqHtqaClZ4OIDM7U7aZGA4iaFSd5Jrnz/u+i1gPKN7BskGbNP1aZb2SKpFqzumkdvvHHF831NcY+aCG5q+Zg0Z9oeYcCQ/EfaATC3NezdY0qcdm+Y8PV2NpPpVJGox0kmhre0EHTrbNNssAWRJphlpqVWOWCJ6NtLYnCVEqoPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cj5z66+V; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cj5z66+V"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749133429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fe4m3owosPzB3KvlAMRW3NDZUpPP7y6rq1nR9F2nKx0=;
	b=Cj5z66+VtoenRz6bZve+z4yR8qfxBbCTSdcG7+t8YbnVMjRbBa9QS2QRrgmnVIj2+KfAHn
	LLOyyLn1LMtvW5oZC2SHAjCjjpFzZwU5ifWRPLsDS+PRzganlpALEVhsc85OR1whwmxjhh
	iA25NI5fIdKi0gdrFui2/Q/+63AHw/E=
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
Subject: [RFC PATCH 02/11] dm-pcache: add backing device management
Date: Thu,  5 Jun 2025 14:22:57 +0000
Message-Id: <20250605142306.1930831-3-dongsheng.yang@linux.dev>
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

This patch introduces *backing_dev.{c,h}*, a self-contained layer that
handles all interaction with the *backing block device* where cache
write-back and cache-miss reads are serviced.  Isolating this logic
keeps the core dm-pcache code free of low-level bio plumbing.

* Device setup / teardown
  - Opens the target with `dm_get_device()`, stores `bdev`, file and
    size, and initialises a dedicated `bioset`.
  - Gracefully releases resources via `backing_dev_stop()`.

* Request object (`struct pcache_backing_dev_req`)
  - Two request flavours:
    - REQ-type – cloned from an upper `struct bio` issued to
      dm-pcache; trimmed and re-targeted to the backing LBA.
    - KMEM-type – maps an arbitrary kernel memory buffer
      into a freshly built.
  - Private completion callback (`end_req`) propagates status to the
    upper layer and handles resource recycling.

* Submission & completion path
  - Lock-protected submit queue + worker (`req_submit_work`) let pcache
    push many requests asynchronously, at the same time, allow caller
    to submit backing_dev_req in atomic context.
  - End-io handler moves finished requests to a completion list processed
    by `req_complete_work`, ensuring callbacks run in process context.
  - Direct-submit option for non-atomic context.

* Flush
  - `backing_dev_flush()` issues a flush to persist backing-device data.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/backing_dev.c | 305 +++++++++++++++++++++++++++++
 drivers/md/dm-pcache/backing_dev.h |  84 ++++++++
 2 files changed, 389 insertions(+)
 create mode 100644 drivers/md/dm-pcache/backing_dev.c
 create mode 100644 drivers/md/dm-pcache/backing_dev.h

diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcache/backing_dev.c
new file mode 100644
index 000000000000..080944cd6c93
--- /dev/null
+++ b/drivers/md/dm-pcache/backing_dev.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blkdev.h>
+
+#include "../dm-core.h"
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "cache.h"
+#include "dm_pcache.h"
+
+static void backing_dev_exit(struct pcache_backing_dev *backing_dev)
+{
+	kmem_cache_destroy(backing_dev->backing_req_cache);
+}
+
+static void req_submit_fn(struct work_struct *work);
+static void req_complete_fn(struct work_struct *work);
+static int backing_dev_init(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	int ret;
+
+	backing_dev->backing_req_cache = KMEM_CACHE(pcache_backing_dev_req, 0);
+	if (!backing_dev->backing_req_cache) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	INIT_LIST_HEAD(&backing_dev->submit_list);
+	INIT_LIST_HEAD(&backing_dev->complete_list);
+	spin_lock_init(&backing_dev->submit_lock);
+	spin_lock_init(&backing_dev->complete_lock);
+	INIT_WORK(&backing_dev->req_submit_work, req_submit_fn);
+	INIT_WORK(&backing_dev->req_complete_work, req_complete_fn);
+
+	return 0;
+err:
+	return ret;
+}
+
+static int backing_dev_open(struct pcache_backing_dev *backing_dev, const char *path)
+{
+	struct dm_pcache *pcache = BACKING_DEV_TO_PCACHE(backing_dev);
+	int ret;
+
+	ret = dm_get_device(pcache->ti, path,
+			BLK_OPEN_READ | BLK_OPEN_WRITE, &backing_dev->dm_dev);
+	if (ret) {
+		pcache_dev_err(pcache, "failed to open dm_dev: %s: %d", path, ret);
+		goto err;
+	}
+	backing_dev->dev_size = bdev_nr_sectors(backing_dev->dm_dev->bdev);
+
+	return 0;
+err:
+	return ret;
+}
+
+static void backing_dev_close(struct pcache_backing_dev *backing_dev)
+{
+	struct dm_pcache *pcache = BACKING_DEV_TO_PCACHE(backing_dev);
+
+	dm_put_device(pcache->ti, backing_dev->dm_dev);
+}
+
+int backing_dev_start(struct dm_pcache *pcache, const char *backing_dev_path)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	int ret;
+
+	ret = backing_dev_init(pcache);
+	if (ret)
+		goto err;
+
+	ret = backing_dev_open(backing_dev, backing_dev_path);
+	if (ret)
+		goto destroy_backing_dev;
+
+	return 0;
+
+destroy_backing_dev:
+	backing_dev_exit(backing_dev);
+err:
+	return ret;
+}
+
+void backing_dev_stop(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+
+	flush_work(&backing_dev->req_submit_work);
+	flush_work(&backing_dev->req_complete_work);
+
+	/* There should be no inflight backing_dev_request */
+	BUG_ON(!list_empty(&backing_dev->submit_list));
+	BUG_ON(!list_empty(&backing_dev->complete_list));
+
+	backing_dev_close(backing_dev);
+	backing_dev_exit(backing_dev);
+}
+
+/* pcache_backing_dev_req functions */
+void backing_dev_req_end(struct pcache_backing_dev_req *backing_req)
+{
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	if (backing_req->end_req)
+		backing_req->end_req(backing_req, backing_req->ret);
+
+	switch (backing_req->type) {
+	case BACKING_DEV_REQ_TYPE_REQ:
+		pcache_req_put(backing_req->req.upper_req, backing_req->ret);
+		break;
+	case BACKING_DEV_REQ_TYPE_KMEM:
+		kfree(backing_req->kmem.bvecs);
+		break;
+	default:
+		BUG();
+	}
+
+	kmem_cache_free(backing_dev->backing_req_cache, backing_req);
+}
+
+static void req_complete_fn(struct work_struct *work)
+{
+	struct pcache_backing_dev *backing_dev = container_of(work, struct pcache_backing_dev, req_complete_work);
+	struct pcache_backing_dev_req *backing_req;
+	unsigned long flags;
+	LIST_HEAD(tmp_list);
+
+	spin_lock_irqsave(&backing_dev->complete_lock, flags);
+	list_splice_init(&backing_dev->complete_list, &tmp_list);
+	spin_unlock_irqrestore(&backing_dev->complete_lock, flags);
+
+	while (!list_empty(&tmp_list)) {
+		backing_req = list_first_entry(&tmp_list,
+					    struct pcache_backing_dev_req, node);
+		list_del_init(&backing_req->node);
+		backing_dev_req_end(backing_req);
+	}
+}
+
+static void backing_dev_bio_end(struct bio *bio)
+{
+	struct pcache_backing_dev_req *backing_req = bio->bi_private;
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	backing_req->ret = bio->bi_status;
+
+	spin_lock(&backing_dev->complete_lock);
+	list_move_tail(&backing_req->node, &backing_dev->complete_list);
+	spin_unlock(&backing_dev->complete_lock);
+
+	queue_work(BACKING_DEV_TO_PCACHE(backing_dev)->task_wq, &backing_dev->req_complete_work);
+}
+
+static void req_submit_fn(struct work_struct *work)
+{
+	struct pcache_backing_dev *backing_dev = container_of(work, struct pcache_backing_dev, req_submit_work);
+	struct pcache_backing_dev_req *backing_req;
+	LIST_HEAD(tmp_list);
+
+	spin_lock(&backing_dev->submit_lock);
+	list_splice_init(&backing_dev->submit_list, &tmp_list);
+	spin_unlock(&backing_dev->submit_lock);
+
+	while (!list_empty(&tmp_list)) {
+		backing_req = list_first_entry(&tmp_list,
+					    struct pcache_backing_dev_req, node);
+		list_del_init(&backing_req->node);
+		submit_bio_noacct(&backing_req->bio);
+	}
+}
+
+void backing_dev_req_submit(struct pcache_backing_dev_req *backing_req, bool direct)
+{
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	if (direct) {
+		submit_bio_noacct(&backing_req->bio);
+		return;
+	}
+
+	spin_lock(&backing_dev->submit_lock);
+	list_add_tail(&backing_req->node, &backing_dev->submit_list);
+	spin_unlock(&backing_dev->submit_lock);
+
+	queue_work(BACKING_DEV_TO_PCACHE(backing_dev)->task_wq, &backing_dev->req_submit_work);
+}
+
+static struct pcache_backing_dev_req *req_type_req_create(struct pcache_backing_dev *backing_dev,
+							struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_request *pcache_req = opts->req.upper_req;
+	struct pcache_backing_dev_req *backing_req;
+	struct bio *clone, *orig = pcache_req->bio;
+	u32 off = opts->req.req_off;
+	u32 len = opts->req.len;
+	int ret;
+
+	backing_req = kmem_cache_zalloc(backing_dev->backing_req_cache, opts->gfp_mask);
+	if (!backing_req)
+		return NULL;
+
+	ret = bio_init_clone(backing_dev->dm_dev->bdev, &backing_req->bio, orig, opts->gfp_mask);
+	if (ret)
+		goto err_free_req;
+
+	backing_req->type = BACKING_DEV_REQ_TYPE_REQ;
+
+	clone = &backing_req->bio;
+	BUG_ON(off & SECTOR_MASK);
+	BUG_ON(len & SECTOR_MASK);
+	bio_trim(clone, off >> SECTOR_SHIFT, len >> SECTOR_SHIFT);
+
+	clone->bi_iter.bi_sector = (pcache_req->off + off) >> SECTOR_SHIFT;
+	clone->bi_private = backing_req;
+	clone->bi_end_io = backing_dev_bio_end;
+
+	backing_req->backing_dev = backing_dev;
+	INIT_LIST_HEAD(&backing_req->node);
+	backing_req->end_req     = opts->end_fn;
+
+	pcache_req_get(pcache_req);
+	backing_req->req.upper_req	= pcache_req;
+	backing_req->req.bio_off	= off;
+
+	return backing_req;
+
+err_free_req:
+	kmem_cache_free(backing_dev->backing_req_cache, backing_req);
+	return NULL;
+}
+
+static void bio_map(struct bio *bio, void *base, size_t size)
+{
+	if (is_vmalloc_addr(base))
+		flush_kernel_vmap_range(base, size);
+
+	while (size) {
+		struct page *page = is_vmalloc_addr(base)
+				? vmalloc_to_page(base)
+				: virt_to_page(base);
+		unsigned int offset = offset_in_page(base);
+		unsigned int len = min_t(size_t, PAGE_SIZE - offset, size);
+
+		BUG_ON(!bio_add_page(bio, page, len, offset));
+		size -= len;
+		base += len;
+	}
+}
+
+static struct pcache_backing_dev_req *kmem_type_req_create(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_backing_dev_req *backing_req;
+	struct bio *backing_bio;
+	u32 n_vecs = DIV_ROUND_UP(opts->kmem.len, PAGE_SIZE);
+
+	backing_req = kmem_cache_zalloc(backing_dev->backing_req_cache, opts->gfp_mask);
+	if (!backing_req)
+		return NULL;
+
+	backing_req->kmem.bvecs = kcalloc(n_vecs, sizeof(struct bio_vec), opts->gfp_mask);
+	if (!backing_req->kmem.bvecs)
+		goto err_free_req;
+
+	backing_req->type = BACKING_DEV_REQ_TYPE_KMEM;
+
+	bio_init(&backing_req->bio, backing_dev->dm_dev->bdev, backing_req->kmem.bvecs,
+			n_vecs, opts->kmem.opf);
+
+	backing_bio = &backing_req->bio;
+	bio_map(backing_bio, opts->kmem.data, opts->kmem.len);
+
+	backing_bio->bi_iter.bi_sector = (opts->kmem.backing_off) >> SECTOR_SHIFT;
+	backing_bio->bi_private = backing_req;
+	backing_bio->bi_end_io = backing_dev_bio_end;
+
+	backing_req->backing_dev = backing_dev;
+	INIT_LIST_HEAD(&backing_req->node);
+	backing_req->end_req     = opts->end_fn;
+
+	return backing_req;
+
+err_free_req:
+	kmem_cache_free(backing_dev->backing_req_cache, backing_req);
+	return NULL;
+}
+
+struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts)
+{
+	if (opts->type == BACKING_DEV_REQ_TYPE_REQ)
+		return req_type_req_create(backing_dev, opts);
+	else if (opts->type == BACKING_DEV_REQ_TYPE_KMEM)
+		return kmem_type_req_create(backing_dev, opts);
+
+	return NULL;
+}
+
+void backing_dev_flush(struct pcache_backing_dev *backing_dev)
+{
+	blkdev_issue_flush(backing_dev->dm_dev->bdev);
+}
diff --git a/drivers/md/dm-pcache/backing_dev.h b/drivers/md/dm-pcache/backing_dev.h
new file mode 100644
index 000000000000..935fdd88ef6e
--- /dev/null
+++ b/drivers/md/dm-pcache/backing_dev.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _BACKING_DEV_H
+#define _BACKING_DEV_H
+
+#include <linux/device-mapper.h>
+
+#include "pcache_internal.h"
+
+struct pcache_backing_dev_req;
+typedef void (*backing_req_end_fn_t)(struct pcache_backing_dev_req *backing_req, int ret);
+
+#define BACKING_DEV_REQ_TYPE_REQ		1
+#define BACKING_DEV_REQ_TYPE_KMEM		2
+
+struct pcache_request;
+struct pcache_backing_dev_req {
+	u8				type;
+	struct bio			bio;
+	struct pcache_backing_dev	*backing_dev;
+
+	void				*priv_data;
+	backing_req_end_fn_t		end_req;
+
+	struct list_head		node;
+	int				ret;
+
+	union {
+		struct {
+			struct pcache_request		*upper_req;
+			u32				bio_off;
+		} req;
+		struct {
+			struct bio_vec	*bvecs;
+		} kmem;
+	};
+};
+
+struct pcache_backing_dev {
+	struct pcache_cache		*cache;
+
+	struct dm_dev			*dm_dev;
+	struct kmem_cache		*backing_req_cache;
+
+	struct list_head		submit_list;
+	spinlock_t			submit_lock;
+	struct work_struct		req_submit_work;
+
+	struct list_head		complete_list;
+	spinlock_t			complete_lock;
+	struct work_struct		req_complete_work;
+
+	u64				dev_size;
+};
+
+struct dm_pcache;
+int backing_dev_start(struct dm_pcache *pcache, const char *backing_dev_path);
+void backing_dev_stop(struct dm_pcache *pcache);
+
+struct pcache_backing_dev_req_opts {
+	u32 type;
+	union {
+		struct {
+			struct pcache_request *upper_req;
+			u32 req_off;
+			u32 len;
+		} req;
+		struct {
+			void *data;
+			blk_opf_t opf;
+			u32 len;
+			u64 backing_off;
+		} kmem;
+	};
+
+	gfp_t gfp_mask;
+	backing_req_end_fn_t	end_fn;
+};
+
+void backing_dev_req_submit(struct pcache_backing_dev_req *backing_req, bool direct);
+void backing_dev_req_end(struct pcache_backing_dev_req *backing_req);
+struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts);
+void backing_dev_flush(struct pcache_backing_dev *backing_dev);
+#endif /* _BACKING_DEV_H */
-- 
2.34.1

