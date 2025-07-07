Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB6928852B
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871572; cv=none; b=I3jbDM4f/0o5SW3fQZoY9CC7UcogMD3ltnKSegIRsAk3CMIHomgM+lSGEs0jhq/usjwGHWMFxv8z1sELhqQg28sV9HtU+rT4shHca8VVUPOPvYz2+/rBUUhqUjjr5h3LbI4fgjirC+dqucYncfuz4uKpaXO8CIpIlSAEFVDSsdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871572; c=relaxed/simple;
	bh=rfq3CIOyWWYiRjX7gu6L2EV+cHMRPu4MVsdK9G1ch0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HeGAp2ebQYVdc2nC+2ADrvUBTRommD5KrLYwssIwcNOKZzh3BYT1g3rTi4E9lmLtyj4vF0SOgDTkLixITjTUOlcY0ql5rHfXmh2n81YVhDX2/D6ioNZeSVzDMgh172Vnc20cLR1fQb9qXVFo/mVrUDMk/9nZOgHSVprpdSaxYow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NI4dWAyP; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NI4dWAyP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751871567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WQzD0Qdye4yu9y+IJF0FX3xvRoOryuI6PjxJ+4nacks=;
	b=NI4dWAyPYM2zK7QmVB+8YkbrWr/lMzks9MCnlC5RUjKhpsjjLWQrHJ2ykI1JniTTDn3H3H
	Nicl/Hd2yt6zVBJghlS6uFytKV6SEuMnkf+lqWQ/515mHQPFA+zMEnoq5SxWBak/F0YUNM
	4O30luDIvpgENQ3TCp+ugTg3t4x/wK8=
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
Subject: [PATCH v2 10/11] dm-pcache: add cache core
Date: Mon,  7 Jul 2025 06:58:08 +0000
Message-ID: <20250707065809.437589-11-dongsheng.yang@linux.dev>
In-Reply-To: <20250707065809.437589-1-dongsheng.yang@linux.dev>
References: <20250707065809.437589-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add cache.c and cache.h that introduce the top-level
“struct pcache_cache”. This object glues together the backing block
device, the persistent-memory cache device, segment array, RB-tree
indexes, and the background workers for write-back and garbage
collection.

* Persistent metadata
  - pcache_cache_info tracks options such as cache mode, data-crc flag
    and GC threshold, written atomically with CRC+sequence.
  - key_tail and dirty_tail positions are double-buffered and recovered
    at mount time.

* Segment management
  - kvcalloc()’d array of pcache_cache_segment objects, bitmap for fast
    allocation, refcounts and generation numbers so GC can invalidate
    old extents safely.
  - First segment hosts a pcache_cache_ctrl block shared by all
    threads.

* Request path hooks
  - pcache_cache_handle_req() dispatches READ, WRITE and FLUSH bios to
    the engines added in earlier patches.
  - Per-CPU data_heads support lock-free allocation of space for new
    writes.

* Background workers
  - Delayed work items for write-back (5 s) and GC (5 s).
  - clean_work removes stale keys after segments are reclaimed.

* Lifecycle helpers
  - pcache_cache_start()/stop() bring the cache online, replay keys,
    start workers, and flush everything on shutdown.

With this piece in place dm-pcache has a fully initialised cache object
capable of serving I/O and maintaining its on-disk structures.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache.c | 432 ++++++++++++++++++++++++
 drivers/md/dm-pcache/cache.h | 616 +++++++++++++++++++++++++++++++++++
 2 files changed, 1048 insertions(+)
 create mode 100644 drivers/md/dm-pcache/cache.c
 create mode 100644 drivers/md/dm-pcache/cache.h

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
new file mode 100644
index 000000000000..d649f6b2c935
--- /dev/null
+++ b/drivers/md/dm-pcache/cache.c
@@ -0,0 +1,432 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blk_types.h>
+
+#include "cache.h"
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "dm_pcache.h"
+
+static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
+{
+	return cache->cache_info_addr + cache->info_index;
+}
+
+static void cache_info_write(struct pcache_cache *cache)
+{
+	struct pcache_cache_info *cache_info = &cache->cache_info;
+
+	cache_info->header.seq++;
+	cache_info->header.crc = pcache_meta_crc(&cache_info->header,
+						sizeof(struct pcache_cache_info));
+
+	memcpy_flushcache(get_cache_info_addr(cache), cache_info,
+			sizeof(struct pcache_cache_info));
+
+	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
+}
+
+static void cache_info_init_default(struct pcache_cache *cache);
+static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_options *opts)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_info *cache_info_addr;
+
+	cache_info_addr = pcache_meta_find_latest(&cache->cache_info_addr->header,
+						sizeof(struct pcache_cache_info),
+						PCACHE_CACHE_INFO_SIZE,
+						&cache->cache_info);
+	if (IS_ERR(cache_info_addr))
+		return PTR_ERR(cache_info_addr);
+
+	if (cache_info_addr) {
+		if (opts->data_crc !=
+				(cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC)) {
+			pcache_dev_err(pcache, "invalid option for data_crc: %s, expected: %s",
+					opts->data_crc ? "true" : "false",
+					cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC ? "true" : "false");
+			return -EINVAL;
+		}
+
+		return 0;
+	}
+
+	/* init cache_info for new cache */
+	cache_info_init_default(cache);
+
+	cache->cache_info.flags &= ~PCACHE_CACHE_FLAGS_CACHE_MODE_MASK;
+	cache->cache_info.flags |= FIELD_PREP(PCACHE_CACHE_FLAGS_CACHE_MODE_MASK, opts->cache_mode);
+
+	if (opts->data_crc)
+		cache->cache_info.flags |= PCACHE_CACHE_FLAGS_DATA_CRC;
+
+	return 0;
+}
+
+static void cache_info_set_gc_percent(struct pcache_cache_info *cache_info, u8 percent)
+{
+	cache_info->flags &= ~PCACHE_CACHE_FLAGS_GC_PERCENT_MASK;
+	cache_info->flags |= FIELD_PREP(PCACHE_CACHE_FLAGS_GC_PERCENT_MASK, percent);
+}
+
+int pcache_cache_set_gc_percent(struct pcache_cache *cache, u8 percent)
+{
+	if (percent > PCACHE_CACHE_GC_PERCENT_MAX || percent < PCACHE_CACHE_GC_PERCENT_MIN)
+		return -EINVAL;
+
+	mutex_lock(&cache->cache_info_lock);
+	cache_info_set_gc_percent(&cache->cache_info, percent);
+
+	cache_info_write(cache);
+	mutex_unlock(&cache->cache_info_lock);
+
+	return 0;
+}
+
+void cache_pos_encode(struct pcache_cache *cache,
+			     struct pcache_cache_pos_onmedia *pos_onmedia_base,
+			     struct pcache_cache_pos *pos, u64 seq, u32 *index)
+{
+	struct pcache_cache_pos_onmedia pos_onmedia;
+	struct pcache_cache_pos_onmedia *pos_onmedia_addr = pos_onmedia_base + *index;
+
+	pos_onmedia.cache_seg_id = pos->cache_seg->cache_seg_id;
+	pos_onmedia.seg_off = pos->seg_off;
+	pos_onmedia.header.seq = seq;
+	pos_onmedia.header.crc = cache_pos_onmedia_crc(&pos_onmedia);
+
+	memcpy_flushcache(pos_onmedia_addr, &pos_onmedia, sizeof(struct pcache_cache_pos_onmedia));
+	pmem_wmb();
+
+	*index = (*index + 1) % PCACHE_META_INDEX_MAX;
+}
+
+int cache_pos_decode(struct pcache_cache *cache,
+			    struct pcache_cache_pos_onmedia *pos_onmedia,
+			    struct pcache_cache_pos *pos, u64 *seq, u32 *index)
+{
+	struct pcache_cache_pos_onmedia latest, *latest_addr;
+
+	latest_addr = pcache_meta_find_latest(&pos_onmedia->header,
+					sizeof(struct pcache_cache_pos_onmedia),
+					sizeof(struct pcache_cache_pos_onmedia),
+					&latest);
+	if (IS_ERR(latest_addr))
+		return PTR_ERR(latest_addr);
+
+	if (!latest_addr)
+		return -EIO;
+
+	pos->cache_seg = &cache->segments[latest.cache_seg_id];
+	pos->seg_off = latest.seg_off;
+	*seq = latest.header.seq;
+	*index = (latest_addr - pos_onmedia);
+
+	return 0;
+}
+
+static inline void cache_info_set_seg_id(struct pcache_cache *cache, u32 seg_id)
+{
+	cache->cache_info.seg_id = seg_id;
+}
+
+static int cache_init(struct dm_pcache *pcache)
+{
+	struct pcache_cache *cache = &pcache->cache;
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+	int ret;
+
+	cache->segments = kvcalloc(cache_dev->seg_num, sizeof(struct pcache_cache_segment), GFP_KERNEL);
+	if (!cache->segments) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	cache->seg_map = bitmap_zalloc(cache_dev->seg_num, GFP_KERNEL);
+	if (!cache->seg_map) {
+		ret = -ENOMEM;
+		goto free_segments;
+	}
+
+	cache->backing_dev = backing_dev;
+	cache->cache_dev = &pcache->cache_dev;
+	cache->n_segs = cache_dev->seg_num;
+	atomic_set(&cache->gc_errors, 0);
+	spin_lock_init(&cache->seg_map_lock);
+	spin_lock_init(&cache->key_head_lock);
+
+	mutex_init(&cache->cache_info_lock);
+	mutex_init(&cache->key_tail_lock);
+	mutex_init(&cache->dirty_tail_lock);
+	mutex_init(&cache->writeback_lock);
+
+	INIT_DELAYED_WORK(&cache->writeback_work, cache_writeback_fn);
+	INIT_DELAYED_WORK(&cache->gc_work, pcache_cache_gc_fn);
+	INIT_WORK(&cache->clean_work, clean_fn);
+
+	return 0;
+
+free_segments:
+	kvfree(cache->segments);
+err:
+	return ret;
+}
+
+static void cache_exit(struct pcache_cache *cache)
+{
+	bitmap_free(cache->seg_map);
+	kvfree(cache->segments);
+}
+
+static void cache_info_init_default(struct pcache_cache *cache)
+{
+	struct pcache_cache_info *cache_info = &cache->cache_info;
+
+	cache_info->header.seq = 0;
+	cache_info->n_segs = cache->cache_dev->seg_num;
+	cache_info_set_gc_percent(cache_info, PCACHE_CACHE_GC_PERCENT_DEFAULT);
+}
+
+static int cache_tail_init(struct pcache_cache *cache)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	bool new_cache = !(cache->cache_info.flags & PCACHE_CACHE_FLAGS_INIT_DONE);
+
+	if (new_cache) {
+		set_bit(0, cache->seg_map);
+
+		cache->key_head.cache_seg = &cache->segments[0];
+		cache->key_head.seg_off = 0;
+		cache_pos_copy(&cache->key_tail, &cache->key_head);
+		cache_pos_copy(&cache->dirty_tail, &cache->key_head);
+
+		cache_encode_dirty_tail(cache);
+		cache_encode_key_tail(cache);
+	} else {
+		if (cache_decode_key_tail(cache) || cache_decode_dirty_tail(cache)) {
+			pcache_dev_err(pcache, "Corrupted key tail or dirty tail.\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static int get_seg_id(struct pcache_cache *cache,
+		      struct pcache_cache_segment *prev_cache_seg,
+		      bool new_cache, u32 *seg_id)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_dev *cache_dev = cache->cache_dev;
+	int ret;
+
+	if (new_cache) {
+		ret = cache_dev_get_empty_segment_id(cache_dev, seg_id);
+		if (ret) {
+			pcache_dev_err(pcache, "no available segment\n");
+			goto err;
+		}
+
+		if (prev_cache_seg)
+			cache_seg_set_next_seg(prev_cache_seg, *seg_id);
+		else
+			cache_info_set_seg_id(cache, *seg_id);
+	} else {
+		if (prev_cache_seg) {
+			struct pcache_segment_info *prev_seg_info;
+
+			prev_seg_info = &prev_cache_seg->cache_seg_info;
+			if (!segment_info_has_next(prev_seg_info)) {
+				ret = -EFAULT;
+				goto err;
+			}
+			*seg_id = prev_cache_seg->cache_seg_info.next_seg;
+		} else {
+			*seg_id = cache->cache_info.seg_id;
+		}
+	}
+	return 0;
+err:
+	return ret;
+}
+
+static int cache_segs_init(struct pcache_cache *cache)
+{
+	struct pcache_cache_segment *prev_cache_seg = NULL;
+	struct pcache_cache_info *cache_info = &cache->cache_info;
+	bool new_cache = !(cache->cache_info.flags & PCACHE_CACHE_FLAGS_INIT_DONE);
+	u32 seg_id;
+	int ret;
+	u32 i;
+
+	for (i = 0; i < cache_info->n_segs; i++) {
+		ret = get_seg_id(cache, prev_cache_seg, new_cache, &seg_id);
+		if (ret)
+			goto err;
+
+		ret = cache_seg_init(cache, seg_id, i, new_cache);
+		if (ret)
+			goto err;
+
+		prev_cache_seg = &cache->segments[i];
+	}
+	return 0;
+err:
+	return ret;
+}
+
+static int cache_init_req_keys(struct pcache_cache *cache, u32 n_paral)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	u32 n_subtrees;
+	int ret;
+	u32 i, cpu;
+
+	/* Calculate number of cache trees based on the device size */
+	n_subtrees = DIV_ROUND_UP(cache->dev_size << SECTOR_SHIFT, PCACHE_CACHE_SUBTREE_SIZE);
+	ret = cache_tree_init(cache, &cache->req_key_tree, n_subtrees);
+	if (ret)
+		goto err;
+
+	cache->n_ksets = n_paral;
+	cache->ksets = kcalloc(cache->n_ksets, PCACHE_KSET_SIZE, GFP_KERNEL);
+	if (!cache->ksets) {
+		ret = -ENOMEM;
+		goto req_tree_exit;
+	}
+
+	/*
+	 * Initialize each kset with a spinlock and delayed work for flushing.
+	 * Each kset is associated with one queue to ensure independent handling
+	 * of cache keys across multiple queues, maximizing multiqueue concurrency.
+	 */
+	for (i = 0; i < cache->n_ksets; i++) {
+		struct pcache_cache_kset *kset = get_kset(cache, i);
+
+		kset->cache = cache;
+		spin_lock_init(&kset->kset_lock);
+		INIT_DELAYED_WORK(&kset->flush_work, kset_flush_fn);
+	}
+
+	cache->data_heads = alloc_percpu(struct pcache_cache_data_head);
+	if (!cache->data_heads) {
+		ret = -ENOMEM;
+		goto free_kset;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct pcache_cache_data_head *h =
+			per_cpu_ptr(cache->data_heads, cpu);
+		h->head_pos.cache_seg = NULL;
+	}
+
+	/*
+	 * Replay persisted cache keys using cache_replay.
+	 * This function loads and replays cache keys from previously stored
+	 * ksets, allowing the cache to restore its state after a restart.
+	 */
+	ret = cache_replay(cache);
+	if (ret) {
+		pcache_dev_err(pcache, "failed to replay keys\n");
+		goto free_heads;
+	}
+
+	return 0;
+
+free_heads:
+	free_percpu(cache->data_heads);
+free_kset:
+	kfree(cache->ksets);
+req_tree_exit:
+	cache_tree_exit(&cache->req_key_tree);
+err:
+	return ret;
+}
+
+static void cache_destroy_req_keys(struct pcache_cache *cache)
+{
+	u32 i;
+
+	for (i = 0; i < cache->n_ksets; i++) {
+		struct pcache_cache_kset *kset = get_kset(cache, i);
+
+		cancel_delayed_work_sync(&kset->flush_work);
+	}
+
+	free_percpu(cache->data_heads);
+	kfree(cache->ksets);
+	cache_tree_exit(&cache->req_key_tree);
+}
+
+int pcache_cache_start(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	struct pcache_cache *cache = &pcache->cache;
+	struct pcache_cache_options *opts = &pcache->opts;
+	int ret;
+
+	ret = cache_init(pcache);
+	if (ret)
+		return ret;
+
+	cache->cache_info_addr = CACHE_DEV_CACHE_INFO(cache->cache_dev);
+	cache->cache_ctrl = CACHE_DEV_CACHE_CTRL(cache->cache_dev);
+	backing_dev->cache = cache;
+	cache->dev_size = backing_dev->dev_size;
+
+	ret = cache_info_init(cache, opts);
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_segs_init(cache);
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_tail_init(cache);
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_init_req_keys(cache, num_online_cpus());
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_writeback_init(cache);
+	if (ret)
+		goto destroy_keys;
+
+	cache->cache_info.flags |= PCACHE_CACHE_FLAGS_INIT_DONE;
+	cache_info_write(cache);
+	queue_delayed_work(cache_get_wq(cache), &cache->gc_work, 0);
+
+	return 0;
+
+destroy_keys:
+	cache_destroy_req_keys(cache);
+cache_exit:
+	cache_exit(cache);
+
+	return ret;
+}
+
+void pcache_cache_stop(struct dm_pcache *pcache)
+{
+	struct pcache_cache *cache = &pcache->cache;
+
+	cache_flush(cache);
+
+	cancel_delayed_work_sync(&cache->gc_work);
+	flush_work(&cache->clean_work);
+	cache_writeback_exit(cache);
+
+	if (cache->req_key_tree.n_subtrees)
+		cache_destroy_req_keys(cache);
+
+	cache_exit(cache);
+}
+
+struct workqueue_struct *cache_get_wq(struct pcache_cache *cache)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+
+	return pcache->task_wq;
+}
diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
new file mode 100644
index 000000000000..5f5e05724f4a
--- /dev/null
+++ b/drivers/md/dm-pcache/cache.h
@@ -0,0 +1,616 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_CACHE_H
+#define _PCACHE_CACHE_H
+
+#include "segment.h"
+
+/* Garbage collection thresholds */
+#define PCACHE_CACHE_GC_PERCENT_MIN       0                   /* Minimum GC percentage */
+#define PCACHE_CACHE_GC_PERCENT_MAX       90                  /* Maximum GC percentage */
+#define PCACHE_CACHE_GC_PERCENT_DEFAULT   70                  /* Default GC percentage */
+
+#define PCACHE_CACHE_SUBTREE_SIZE		(4 * 1024 * 1024)   /* 4MB total tree size */
+#define PCACHE_CACHE_SUBTREE_SIZE_MASK		0x3FFFFF            /* Mask for tree size */
+#define PCACHE_CACHE_SUBTREE_SIZE_SHIFT		22                  /* Bit shift for tree size */
+
+/* Maximum number of keys per key set */
+#define PCACHE_KSET_KEYS_MAX		128
+#define PCACHE_CACHE_SEGS_MAX		(1024 * 1024)	/* maximum cache size for each device is 16T */
+#define PCACHE_KSET_ONMEDIA_SIZE_MAX	struct_size_t(struct pcache_cache_kset_onmedia, data, PCACHE_KSET_KEYS_MAX)
+#define PCACHE_KSET_SIZE		(sizeof(struct pcache_cache_kset) + sizeof(struct pcache_cache_key_onmedia) * PCACHE_KSET_KEYS_MAX)
+
+/* Maximum number of keys to clean in one round of clean_work */
+#define PCACHE_CLEAN_KEYS_MAX             10
+
+/* Writeback and garbage collection intervals in jiffies */
+#define PCACHE_CACHE_WRITEBACK_INTERVAL   (5 * HZ)
+#define PCACHE_CACHE_GC_INTERVAL          (5 * HZ)
+
+/* Macro to get the cache key structure from an rb_node pointer */
+#define CACHE_KEY(node)                (container_of(node, struct pcache_cache_key, rb_node))
+
+struct pcache_cache_pos_onmedia {
+	struct pcache_meta_header header;
+	__u32 cache_seg_id;
+	__u32 seg_off;
+};
+
+/* Offset and size definitions for cache segment control */
+#define PCACHE_CACHE_SEG_CTRL_OFF     (PCACHE_SEG_INFO_SIZE * PCACHE_META_INDEX_MAX)
+#define PCACHE_CACHE_SEG_CTRL_SIZE    (4 * PCACHE_KB)
+
+struct pcache_cache_seg_gen {
+	struct pcache_meta_header header;
+	__u64 gen;
+};
+
+/* Control structure for cache segments */
+struct pcache_cache_seg_ctrl {
+	struct pcache_cache_seg_gen gen[PCACHE_META_INDEX_MAX];
+	__u64	res[64];
+};
+
+#define PCACHE_CACHE_FLAGS_DATA_CRC			BIT(0)
+#define PCACHE_CACHE_FLAGS_INIT_DONE			BIT(1)
+
+#define PCACHE_CACHE_FLAGS_CACHE_MODE_MASK		GENMASK(5, 2)
+#define PCACHE_CACHE_MODE_WRITEBACK			0
+#define PCACHE_CACHE_MODE_WRITETHROUGH			1
+#define PCACHE_CACHE_MODE_WRITEAROUND			2
+#define PCACHE_CACHE_MODE_WRITEONLY			3
+
+#define PCACHE_CACHE_FLAGS_GC_PERCENT_MASK		GENMASK(12, 6)
+
+struct pcache_cache_info {
+	struct pcache_meta_header header;
+	__u32 seg_id;
+	__u32 n_segs;
+	__u32 flags;
+	__u32 reserved;
+};
+
+struct pcache_cache_pos {
+	struct pcache_cache_segment *cache_seg;
+	u32 seg_off;
+};
+
+struct pcache_cache_segment {
+	struct pcache_cache	*cache;
+	u32			cache_seg_id;   /* Index in cache->segments */
+	struct pcache_segment	segment;
+	atomic_t		refs;
+
+	struct pcache_segment_info cache_seg_info;
+	struct mutex		info_lock;
+	u32			info_index;
+
+	spinlock_t		gen_lock;
+	u64			gen;
+	u64			gen_seq;
+	u32			gen_index;
+
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl;
+	struct mutex		ctrl_lock;
+};
+
+/* rbtree for cache entries */
+struct pcache_cache_subtree {
+	struct rb_root root;
+	spinlock_t tree_lock;
+};
+
+struct pcache_cache_tree {
+	struct pcache_cache		*cache;
+	u32				n_subtrees;
+	struct kmem_cache		*key_cache;
+	mempool_t			key_pool;
+	struct pcache_cache_subtree	*subtrees;
+};
+
+struct pcache_cache_key {
+	struct pcache_cache_tree	*cache_tree;
+	struct pcache_cache_subtree	*cache_subtree;
+	struct kref			ref;
+	struct rb_node			rb_node;
+	struct list_head		list_node;
+	u64				off;
+	u32				len;
+	u32				flags;
+	struct pcache_cache_pos		cache_pos;
+	u64				seg_gen;
+};
+
+#define PCACHE_CACHE_KEY_FLAGS_EMPTY		BIT(0)
+#define PCACHE_CACHE_KEY_FLAGS_CLEAN		BIT(1)
+
+struct pcache_cache_key_onmedia {
+	__u64 off;
+	__u32 len;
+	__u32 flags;
+	__u32 cache_seg_id;
+	__u32 cache_seg_off;
+	__u64 seg_gen;
+	__u32 data_crc;
+	__u32 reserved;
+};
+
+struct pcache_cache_kset_onmedia {
+	__u32 crc;
+	union {
+		__u32 key_num;
+		__u32 next_cache_seg_id;
+	};
+	__u64 magic;
+	__u64 flags;
+	struct pcache_cache_key_onmedia data[];
+};
+
+struct pcache_cache {
+	struct pcache_backing_dev	*backing_dev;
+	struct pcache_cache_dev		*cache_dev;
+	struct pcache_cache_ctrl	*cache_ctrl;
+	u64				dev_size;
+
+	struct pcache_cache_data_head __percpu *data_heads;
+
+	spinlock_t		key_head_lock;
+	struct pcache_cache_pos	key_head;
+	u32			n_ksets;
+	struct pcache_cache_kset	*ksets;
+
+	struct mutex		key_tail_lock;
+	struct pcache_cache_pos	key_tail;
+	u64			key_tail_seq;
+	u32			key_tail_index;
+
+	struct mutex		dirty_tail_lock;
+	struct pcache_cache_pos	dirty_tail;
+	u64			dirty_tail_seq;
+	u32			dirty_tail_index;
+
+	struct pcache_cache_tree	req_key_tree;
+	struct work_struct	clean_work;
+
+	struct mutex		writeback_lock;
+	char wb_kset_onmedia_buf[PCACHE_KSET_ONMEDIA_SIZE_MAX];
+	struct pcache_cache_tree	writeback_key_tree;
+	struct delayed_work	writeback_work;
+	struct {
+		atomic_t pending;
+		u32 advance;
+		int ret;
+	} writeback_ctx;
+
+	char gc_kset_onmedia_buf[PCACHE_KSET_ONMEDIA_SIZE_MAX];
+	struct delayed_work	gc_work;
+	atomic_t		gc_errors;
+
+	struct mutex			cache_info_lock;
+	struct pcache_cache_info	cache_info;
+	struct pcache_cache_info	*cache_info_addr;
+	u32				info_index;
+
+	u32			n_segs;
+	unsigned long		*seg_map;
+	u32			last_cache_seg;
+	bool			cache_full;
+	spinlock_t		seg_map_lock;
+	struct pcache_cache_segment *segments;
+};
+
+struct workqueue_struct *cache_get_wq(struct pcache_cache *cache);
+
+struct dm_pcache;
+struct pcache_cache_options {
+	u32	cache_mode:4;
+	u32	data_crc:1;
+};
+int pcache_cache_start(struct dm_pcache *pcache);
+void pcache_cache_stop(struct dm_pcache *pcache);
+
+struct pcache_cache_ctrl {
+	/* Updated by gc_thread */
+	struct pcache_cache_pos_onmedia key_tail_pos[PCACHE_META_INDEX_MAX];
+
+	/* Updated by writeback_thread */
+	struct pcache_cache_pos_onmedia dirty_tail_pos[PCACHE_META_INDEX_MAX];
+};
+
+struct pcache_cache_data_head {
+	struct pcache_cache_pos head_pos;
+};
+
+static inline u16 pcache_cache_get_gc_percent(struct pcache_cache *cache)
+{
+	return FIELD_GET(PCACHE_CACHE_FLAGS_GC_PERCENT_MASK, cache->cache_info.flags);
+}
+
+int pcache_cache_set_gc_percent(struct pcache_cache *cache, u8 percent);
+
+/* cache key */
+struct pcache_cache_key *cache_key_alloc(struct pcache_cache_tree *cache_tree);
+void cache_key_init(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key);
+void cache_key_get(struct pcache_cache_key *key);
+void cache_key_put(struct pcache_cache_key *key);
+int cache_key_append(struct pcache_cache *cache, struct pcache_cache_key *key, bool force_close);
+int cache_key_insert(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key, bool fixup);
+int cache_key_decode(struct pcache_cache *cache,
+			struct pcache_cache_key_onmedia *key_onmedia,
+			struct pcache_cache_key *key);
+void cache_pos_advance(struct pcache_cache_pos *pos, u32 len);
+
+#define PCACHE_KSET_FLAGS_LAST		BIT(0)
+#define PCACHE_KSET_MAGIC		0x676894a64e164f1aULL
+
+struct pcache_cache_kset {
+	struct pcache_cache *cache;
+	spinlock_t        kset_lock;
+	struct delayed_work flush_work;
+	struct pcache_cache_kset_onmedia kset_onmedia;
+};
+
+extern struct pcache_cache_kset_onmedia pcache_empty_kset;
+
+#define SUBTREE_WALK_RET_OK		0
+#define SUBTREE_WALK_RET_ERR		1
+#define SUBTREE_WALK_RET_NEED_KEY	2
+#define SUBTREE_WALK_RET_NEED_REQ	3
+#define SUBTREE_WALK_RET_RESEARCH	4
+
+struct pcache_cache_subtree_walk_ctx {
+	struct pcache_cache_tree *cache_tree;
+	struct rb_node *start_node;
+	struct pcache_request *pcache_req;
+	struct pcache_cache_key *key;
+	u32	req_done;
+	int	ret;
+
+	/* pre-allocated key and backing_dev_req */
+	struct pcache_cache_key		*pre_alloc_key;
+	struct pcache_backing_dev_req	*pre_alloc_req;
+
+	struct list_head *delete_key_list;
+	struct list_head *submit_req_list;
+
+	/*
+	 *	  |--------|		key_tmp
+	 * |====|			key
+	 */
+	int (*before)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |----------|			key_tmp
+	 *		|=====|		key
+	 */
+	int (*after)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *     |----------------|	key_tmp
+	 * |===========|		key
+	 */
+	int (*overlap_tail)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |--------|			key_tmp
+	 *   |==========|		key
+	 */
+	int (*overlap_head)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *    |----|			key_tmp
+	 * |==========|			key
+	 */
+	int (*overlap_contain)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |-----------|		key_tmp
+	 *   |====|			key
+	 */
+	int (*overlap_contained)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	int (*walk_finally)(struct pcache_cache_subtree_walk_ctx *ctx, int ret);
+	bool (*walk_done)(struct pcache_cache_subtree_walk_ctx *ctx);
+};
+
+int cache_subtree_walk(struct pcache_cache_subtree_walk_ctx *ctx);
+struct rb_node *cache_subtree_search(struct pcache_cache_subtree *cache_subtree, struct pcache_cache_key *key,
+				  struct rb_node **parentp, struct rb_node ***newp,
+				  struct list_head *delete_key_list);
+int cache_kset_close(struct pcache_cache *cache, struct pcache_cache_kset *kset);
+void clean_fn(struct work_struct *work);
+void kset_flush_fn(struct work_struct *work);
+int cache_replay(struct pcache_cache *cache);
+int cache_tree_init(struct pcache_cache *cache, struct pcache_cache_tree *cache_tree, u32 n_subtrees);
+void cache_tree_exit(struct pcache_cache_tree *cache_tree);
+
+/* cache segments */
+struct pcache_cache_segment *get_cache_segment(struct pcache_cache *cache);
+int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache);
+void cache_seg_get(struct pcache_cache_segment *cache_seg);
+void cache_seg_put(struct pcache_cache_segment *cache_seg);
+void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id);
+
+/* cache request*/
+int cache_flush(struct pcache_cache *cache);
+void miss_read_end_work_fn(struct work_struct *work);
+int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req);
+
+/* gc */
+void pcache_cache_gc_fn(struct work_struct *work);
+
+/* writeback */
+void cache_writeback_exit(struct pcache_cache *cache);
+int cache_writeback_init(struct pcache_cache *cache);
+void cache_writeback_fn(struct work_struct *work);
+
+/* inline functions */
+static inline struct pcache_cache_subtree *get_subtree(struct pcache_cache_tree *cache_tree, u64 off)
+{
+	if (cache_tree->n_subtrees == 1)
+		return &cache_tree->subtrees[0];
+
+	return &cache_tree->subtrees[off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT];
+}
+
+static inline void *cache_pos_addr(struct pcache_cache_pos *pos)
+{
+	return (pos->cache_seg->segment.data + pos->seg_off);
+}
+
+static inline void *get_key_head_addr(struct pcache_cache *cache)
+{
+	return cache_pos_addr(&cache->key_head);
+}
+
+static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
+{
+	return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
+}
+
+static inline struct pcache_cache_kset *get_kset(struct pcache_cache *cache, u32 kset_id)
+{
+	return (void *)cache->ksets + PCACHE_KSET_SIZE * kset_id;
+}
+
+static inline struct pcache_cache_data_head *get_data_head(struct pcache_cache *cache)
+{
+	return this_cpu_ptr(cache->data_heads);
+}
+
+static inline bool cache_key_empty(struct pcache_cache_key *key)
+{
+	return key->flags & PCACHE_CACHE_KEY_FLAGS_EMPTY;
+}
+
+static inline bool cache_key_clean(struct pcache_cache_key *key)
+{
+	return key->flags & PCACHE_CACHE_KEY_FLAGS_CLEAN;
+}
+
+static inline void cache_pos_copy(struct pcache_cache_pos *dst, struct pcache_cache_pos *src)
+{
+	memcpy(dst, src, sizeof(struct pcache_cache_pos));
+}
+
+/**
+ * cache_seg_is_ctrl_seg - Checks if a cache segment is a cache ctrl segment.
+ * @cache_seg_id: ID of the cache segment.
+ *
+ * Returns true if the cache segment ID corresponds to a cache ctrl segment.
+ *
+ * Note: We extend the segment control of the first cache segment
+ * (cache segment ID 0) to serve as the cache control (pcache_cache_ctrl)
+ * for the entire PCACHE cache. This function determines whether the given
+ * cache segment is the one storing the pcache_cache_ctrl information.
+ */
+static inline bool cache_seg_is_ctrl_seg(u32 cache_seg_id)
+{
+	return (cache_seg_id == 0);
+}
+
+/**
+ * cache_key_cutfront - Cuts a specified length from the front of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ * @cut_len: Length to cut from the front.
+ *
+ * Advances the cache key position by cut_len and adjusts offset and length accordingly.
+ */
+static inline void cache_key_cutfront(struct pcache_cache_key *key, u32 cut_len)
+{
+	if (key->cache_pos.cache_seg)
+		cache_pos_advance(&key->cache_pos, cut_len);
+
+	key->off += cut_len;
+	key->len -= cut_len;
+}
+
+/**
+ * cache_key_cutback - Cuts a specified length from the back of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ * @cut_len: Length to cut from the back.
+ *
+ * Reduces the length of the cache key by cut_len.
+ */
+static inline void cache_key_cutback(struct pcache_cache_key *key, u32 cut_len)
+{
+	key->len -= cut_len;
+}
+
+static inline void cache_key_delete(struct pcache_cache_key *key)
+{
+	struct pcache_cache_subtree *cache_subtree;
+
+	cache_subtree = key->cache_subtree;
+	BUG_ON(!cache_subtree);
+
+	rb_erase(&key->rb_node, &cache_subtree->root);
+	key->flags = 0;
+	cache_key_put(key);
+}
+
+static inline bool cache_data_crc_on(struct pcache_cache *cache)
+{
+	return (cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC);
+}
+
+/**
+ * cache_key_data_crc - Calculates CRC for data in a cache key.
+ * @key: Pointer to the pcache_cache_key structure.
+ *
+ * Returns the CRC-32 checksum of the data within the cache key's position.
+ */
+static inline u32 cache_key_data_crc(struct pcache_cache_key *key)
+{
+	void *data;
+
+	data = cache_pos_addr(&key->cache_pos);
+
+	return crc32c(PCACHE_CRC_SEED, data, key->len);
+}
+
+static inline u32 cache_kset_crc(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	u32 crc_size;
+
+	if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST)
+		crc_size = sizeof(struct pcache_cache_kset_onmedia) - 4;
+	else
+		crc_size = struct_size(kset_onmedia, data, kset_onmedia->key_num) - 4;
+
+	return crc32c(PCACHE_CRC_SEED, (void *)kset_onmedia + 4, crc_size);
+}
+
+static inline u32 get_kset_onmedia_size(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	return struct_size_t(struct pcache_cache_kset_onmedia, data, kset_onmedia->key_num);
+}
+
+/**
+ * cache_seg_remain - Computes remaining space in a cache segment.
+ * @pos: Pointer to pcache_cache_pos structure.
+ *
+ * Returns the amount of remaining space in the segment data starting from
+ * the current position offset.
+ */
+static inline u32 cache_seg_remain(struct pcache_cache_pos *pos)
+{
+	struct pcache_cache_segment *cache_seg;
+	struct pcache_segment *segment;
+	u32 seg_remain;
+
+	cache_seg = pos->cache_seg;
+	segment = &cache_seg->segment;
+	seg_remain = segment->data_size - pos->seg_off;
+
+	return seg_remain;
+}
+
+/**
+ * cache_key_invalid - Checks if a cache key is invalid.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns true if the cache key is invalid due to its generation being
+ * less than the generation of its segment; otherwise returns false.
+ *
+ * When the GC (garbage collection) thread identifies a segment
+ * as reclaimable, it increments the segment's generation (gen). However,
+ * it does not immediately remove all related cache keys. When accessing
+ * such a cache key, this function can be used to determine if the cache
+ * key has already become invalid.
+ */
+static inline bool cache_key_invalid(struct pcache_cache_key *key)
+{
+	if (cache_key_empty(key))
+		return false;
+
+	return (key->seg_gen < key->cache_pos.cache_seg->gen);
+}
+
+/**
+ * cache_key_lstart - Retrieves the logical start offset of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns the logical start offset for the cache key.
+ */
+static inline u64 cache_key_lstart(struct pcache_cache_key *key)
+{
+	return key->off;
+}
+
+/**
+ * cache_key_lend - Retrieves the logical end offset of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns the logical end offset for the cache key.
+ */
+static inline u64 cache_key_lend(struct pcache_cache_key *key)
+{
+	return key->off + key->len;
+}
+
+static inline void cache_key_copy(struct pcache_cache_key *key_dst, struct pcache_cache_key *key_src)
+{
+	key_dst->off = key_src->off;
+	key_dst->len = key_src->len;
+	key_dst->seg_gen = key_src->seg_gen;
+	key_dst->cache_tree = key_src->cache_tree;
+	key_dst->cache_subtree = key_src->cache_subtree;
+	key_dst->flags = key_src->flags;
+
+	cache_pos_copy(&key_dst->cache_pos, &key_src->cache_pos);
+}
+
+/**
+ * cache_pos_onmedia_crc - Calculates the CRC for an on-media cache position.
+ * @pos_om: Pointer to pcache_cache_pos_onmedia structure.
+ *
+ * Calculates the CRC-32 checksum of the position, excluding the first 4 bytes.
+ * Returns the computed CRC value.
+ */
+static inline u32 cache_pos_onmedia_crc(struct pcache_cache_pos_onmedia *pos_om)
+{
+	return pcache_meta_crc(&pos_om->header, sizeof(struct pcache_cache_pos_onmedia));
+}
+
+void cache_pos_encode(struct pcache_cache *cache,
+			     struct pcache_cache_pos_onmedia *pos_onmedia,
+			     struct pcache_cache_pos *pos, u64 seq, u32 *index);
+int cache_pos_decode(struct pcache_cache *cache,
+			    struct pcache_cache_pos_onmedia *pos_onmedia,
+			    struct pcache_cache_pos *pos, u64 *seq, u32 *index);
+
+static inline void cache_encode_key_tail(struct pcache_cache *cache)
+{
+	cache_pos_encode(cache, cache->cache_ctrl->key_tail_pos,
+			&cache->key_tail, ++cache->key_tail_seq,
+			&cache->key_tail_index);
+}
+
+static inline int cache_decode_key_tail(struct pcache_cache *cache)
+{
+	return cache_pos_decode(cache, cache->cache_ctrl->key_tail_pos,
+				&cache->key_tail, &cache->key_tail_seq,
+				&cache->key_tail_index);
+}
+
+static inline void cache_encode_dirty_tail(struct pcache_cache *cache)
+{
+	cache_pos_encode(cache, cache->cache_ctrl->dirty_tail_pos,
+			&cache->dirty_tail, ++cache->dirty_tail_seq,
+			&cache->dirty_tail_index);
+}
+
+static inline int cache_decode_dirty_tail(struct pcache_cache *cache)
+{
+	return cache_pos_decode(cache, cache->cache_ctrl->dirty_tail_pos,
+				&cache->dirty_tail, &cache->dirty_tail_seq,
+				&cache->dirty_tail_index);
+}
+#endif /* _PCACHE_CACHE_H */
-- 
2.43.0

