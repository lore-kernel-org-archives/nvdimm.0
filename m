Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9180225744F
	for <nvdimm@lists.linux.dev>; Tue, 24 Jun 2025 07:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750750469; cv=none; b=GGvpZnWyrxV/p4pFtoLue2qYp19/WRn8eHr8/Wse/1GsBCBccqfnMZhnGi1OE73n8tu4q4XLqm58ka7F09Eq2GCRZJOsMKDd+p1A/90NMCFaJxe8isx+qlh9N3Xp+3HiNDaaH6fbmVzGX+5T9SLM+jy3hNrK9Kz8FcS38S5zYD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750750469; c=relaxed/simple;
	bh=RYrpgx2oZUDbd0i4ljaphUs7vMsXBt87RtqhxkVvLoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJYAoiV9iwOf+gU/YXmuvbF6Gq58WHq7JEOmZtgTAt6zfHk7s+g638R8AW3Wp9VFnbVd6v7RGaDGHq5q9+jJsZnxEdAzbFAtUpozcnY95pK4jw3Km/fDdEOqi9sYgiBLrQWCVw5zdfyvJtks5qJ+GOYGmBFACrISvhiSrGa8HBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sfcL7SRK; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sfcL7SRK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750750464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KkMlUgLT5HwmnPhhbmoLR2lC4NVKMqmZyapF3plkRE0=;
	b=sfcL7SRKNshAvox5jcdqhMynItrGlQzYmMmdqr+7xjMtsfov/CBpNKIgARXZVnefsj897D
	K2qT0Q21xUea0AF5OQbwJzWU+Dx1itFhlxE1nF0jTdbBAWzO/mYNoKCsnE7Ex8iB7CS10z
	6UYAKoRoC+pwUMR7+0pihKpmSUPTS9k=
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
Subject: [PATCH v1 02/11] dm-pcache: add backing device management
Date: Tue, 24 Jun 2025 07:33:49 +0000
Message-ID: <20250624073359.2041340-3-dongsheng.yang@linux.dev>
In-Reply-To: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
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
 drivers/md/dm-pcache/backing_dev.c | 292 +++++++++++++++++++++++++++++
 drivers/md/dm-pcache/backing_dev.h |  88 +++++++++
 2 files changed, 380 insertions(+)
 create mode 100644 drivers/md/dm-pcache/backing_dev.c
 create mode 100644 drivers/md/dm-pcache/backing_dev.h

diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcache/backing_dev.c
new file mode 100644
index 000000000000..590c6415319d
--- /dev/null
+++ b/drivers/md/dm-pcache/backing_dev.c
@@ -0,0 +1,292 @@
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
+int backing_dev_start(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	int ret;
+
+	ret = backing_dev_init(pcache);
+	if (ret)
+		return ret;
+
+	backing_dev->dev_size = bdev_nr_sectors(backing_dev->dm_dev->bdev);
+
+	return 0;
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
+		if (backing_req->kmem.bvecs != backing_req->kmem.inline_bvecs)
+			kfree(backing_req->kmem.bvecs);
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
+	LIST_HEAD(tmp_list);
+
+	spin_lock_irq(&backing_dev->complete_lock);
+	list_splice_init(&backing_dev->complete_list, &tmp_list);
+	spin_unlock_irq(&backing_dev->complete_lock);
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
+	unsigned long flags;
+
+	backing_req->ret = bio->bi_status;
+
+	spin_lock_irqsave(&backing_dev->complete_lock, flags);
+	list_move_tail(&backing_req->node, &backing_dev->complete_list);
+	queue_work(BACKING_DEV_TO_PCACHE(backing_dev)->task_wq, &backing_dev->req_complete_work);
+	spin_unlock_irqrestore(&backing_dev->complete_lock, flags);
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
+	queue_work(BACKING_DEV_TO_PCACHE(backing_dev)->task_wq, &backing_dev->req_submit_work);
+	spin_unlock(&backing_dev->submit_lock);
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
+	struct page *page;
+	unsigned int offset;
+	unsigned int len;
+
+	if (!is_vmalloc_addr(base)) {
+		page = virt_to_page(base);
+		offset = offset_in_page(base);
+
+		BUG_ON(!bio_add_page(bio, page, size, offset));
+		return;
+	}
+
+	flush_kernel_vmap_range(base, size);
+	while (size) {
+		page = vmalloc_to_page(base);
+		offset = offset_in_page(base);
+		len = min_t(size_t, PAGE_SIZE - offset, size);
+
+		BUG_ON(!bio_add_page(bio, page, len, offset));
+		size -= len;
+		base += len;
+	}
+}
+
+static u32 get_n_vecs(void *data, u32 len)
+{
+	if (!is_vmalloc_addr(data))
+		return 1;
+
+	return DIV_ROUND_UP(len, PAGE_SIZE);
+}
+
+static struct pcache_backing_dev_req *kmem_type_req_create(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_backing_dev_req *backing_req;
+	struct bio *backing_bio;
+	u32 n_vecs = get_n_vecs(opts->kmem.data, opts->kmem.len);
+
+	backing_req = kmem_cache_zalloc(backing_dev->backing_req_cache, opts->gfp_mask);
+	if (!backing_req)
+		return NULL;
+
+	if (n_vecs > BACKING_DEV_REQ_INLINE_BVECS) {
+		backing_req->kmem.bvecs = kmalloc_array(n_vecs, sizeof(struct bio_vec), opts->gfp_mask);
+		if (!backing_req->kmem.bvecs)
+			goto err_free_req;
+	} else {
+		backing_req->kmem.bvecs = backing_req->kmem.inline_bvecs;
+	}
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
+	backing_req->end_req	= opts->end_fn;
+	backing_req->priv_data	= opts->priv_data;
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
index 000000000000..8717ce456393
--- /dev/null
+++ b/drivers/md/dm-pcache/backing_dev.h
@@ -0,0 +1,88 @@
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
+#define BACKING_DEV_REQ_INLINE_BVECS		4
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
+			struct bio_vec	inline_bvecs[BACKING_DEV_REQ_INLINE_BVECS];
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
+int backing_dev_start(struct dm_pcache *pcache);
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
+	void			*priv_data;
+};
+
+void backing_dev_req_submit(struct pcache_backing_dev_req *backing_req, bool direct);
+void backing_dev_req_end(struct pcache_backing_dev_req *backing_req);
+struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts);
+void backing_dev_flush(struct pcache_backing_dev *backing_dev);
+#endif /* _BACKING_DEV_H */
-- 
2.43.0

