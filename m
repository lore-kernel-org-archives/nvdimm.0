Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FFD25A623
	for <nvdimm@lists.linux.dev>; Tue, 24 Jun 2025 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750750487; cv=none; b=cPb0S+YXRSLgGlBsno+E4TeMkQJhTU6cqhncGs8F98BYAYR4oz5zEJ0xIE0HbT2Vb5omYiRGj3mq9GFtsaiXq3Q24u3YIYqUa8Awm9jkARdN0WDgBz7hvnfHlQlAon7KD/f0eO5/sJHLFEBWMgyHpukVViOtNP+oXb7nT4oup7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750750487; c=relaxed/simple;
	bh=dyZ3Q/WfUc9Yfr8WKgBkBq1Rov1nBro8nX9cJJIUKkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r7QWG7WwrMUDwzCotFvEm8sVqMuTrfzVIKfqwM7Hibhe/xYLudnKzBP3UfJP/EEwolz7cT5zi5VaEF3j76Ss5/mmcB7EVYQH0HR00NP6j1GfGwlnqbdvlitnSazWDM5eHSZAclDI8e1MiTyCCAngfH5OlKsQBcQHSeQhAnPiiwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FRHohkC5; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FRHohkC5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750750483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IslX9SNKgy5A0C8YZbwreUYJmYXqmY/6W1FdQ3Ycp9w=;
	b=FRHohkC5aRH7+IeC1n/rpITenjhxzxFT0IEVgePodbNc0ju2PTnfB9CHq/Ua5bl5tgOicP
	3KOrMLIDoMfRtENUah2tHnagnAMitb1IKtlRCHz4a2jI1v6BhyGZFyVipCYBtFbG8qep5Z
	+k9egFyBlhKIxBjqGtRv72F8grC5JTE=
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
Subject: [PATCH v1 05/11] dm-pcache: add cache_segment
Date: Tue, 24 Jun 2025 07:33:52 +0000
Message-ID: <20250624073359.2041340-6-dongsheng.yang@linux.dev>
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

Introduce *cache_segment.c*, the in-memory/on-disk glue that lets a
`struct pcache_cache` manage its array of data segments.

* Metadata handling
  - Loads the most-recent replica of both the segment-info block
    (`struct pcache_segment_info`) and per-segment generation counter
    (`struct pcache_cache_seg_gen`) using `pcache_meta_find_latest()`.
  - Updates those structures atomically with CRC + sequence rollover,
    writing alternately to the two metadata slots inside each segment.

* Segment initialisation (`cache_seg_init`)
  - Builds a `struct pcache_segment` pointing to the segment’s data
    area, sets up locks, generation counters, and, when formatting a new
    cache, zeroes the on-segment kset header.

* Linked-list of segments
  - `cache_seg_set_next_seg()` stores the *next* segment id in
    `seg_info->next_seg` and sets the HAS_NEXT flag, allowing a cache to
    span multiple segments. This is important to allow other type of
    segment added in future.

* Runtime life-cycle
  - Reference counting (`cache_seg_get/put`) with invalidate-on-last-put
    that clears the bitmap slot and schedules cleanup work.
  - Generation bump (`cache_seg_gen_increase`) persists a new generation
    record whenever the segment is modified.

* Allocator
  - `get_cache_segment()` uses a bitmap and per-cache hint to pick the
    next free segment, retrying with micro-delays when none are
    immediately available.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_segment.c | 293 +++++++++++++++++++++++++++
 1 file changed, 293 insertions(+)
 create mode 100644 drivers/md/dm-pcache/cache_segment.c

diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
new file mode 100644
index 000000000000..298f881874d1
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cache_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+#include "dm_pcache.h"
+
+static inline struct pcache_segment_info *get_seg_info_addr(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_segment_info *seg_info_addr;
+	u32 seg_id = cache_seg->segment.seg_id;
+	void *seg_addr;
+
+	seg_addr = CACHE_DEV_SEGMENT(cache_seg->cache->cache_dev, seg_id);
+	seg_info_addr = seg_addr + PCACHE_SEG_INFO_SIZE * cache_seg->info_index;
+
+	return seg_info_addr;
+}
+
+static void cache_seg_info_write(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_segment_info *seg_info_addr;
+	struct pcache_segment_info *seg_info = &cache_seg->cache_seg_info;
+
+	mutex_lock(&cache_seg->info_lock);
+	seg_info->header.seq++;
+	seg_info->header.crc = pcache_meta_crc(&seg_info->header, sizeof(struct pcache_segment_info));
+
+	seg_info_addr = get_seg_info_addr(cache_seg);
+	memcpy_flushcache(seg_info_addr, seg_info, sizeof(struct pcache_segment_info));
+	pmem_wmb();
+
+	cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;
+	mutex_unlock(&cache_seg->info_lock);
+}
+
+static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_segment_info *cache_seg_info_addr_base, *cache_seg_info_addr;
+	struct pcache_cache_dev *cache_dev = cache_seg->cache->cache_dev;
+	struct dm_pcache *pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	u32 seg_id = cache_seg->segment.seg_id;
+	int ret = 0;
+
+	cache_seg_info_addr_base = CACHE_DEV_SEGMENT(cache_dev, seg_id);
+
+	mutex_lock(&cache_seg->info_lock);
+	cache_seg_info_addr = pcache_meta_find_latest(&cache_seg_info_addr_base->header,
+						sizeof(struct pcache_segment_info),
+						PCACHE_SEG_INFO_SIZE,
+						&cache_seg->cache_seg_info);
+	if (IS_ERR(cache_seg_info_addr)) {
+		ret = PTR_ERR(cache_seg_info_addr);
+		goto out;
+	} else if (!cache_seg_info_addr) {
+		ret = -EIO;
+		goto out;
+	}
+	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
+out:
+	mutex_unlock(&cache_seg->info_lock);
+
+	if (ret)
+		pcache_dev_err(pcache, "can't read segment info of segment: %u, ret: %d\n",
+			      cache_seg->segment.seg_id, ret);
+	return ret;
+}
+
+static int cache_seg_ctrl_load(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+	struct pcache_cache_seg_gen cache_seg_gen, *cache_seg_gen_addr;
+	int ret = 0;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen_addr = pcache_meta_find_latest(&cache_seg_ctrl->gen->header,
+					     sizeof(struct pcache_cache_seg_gen),
+					     sizeof(struct pcache_cache_seg_gen),
+					     &cache_seg_gen);
+	if (IS_ERR(cache_seg_gen_addr)) {
+		ret = PTR_ERR(cache_seg_gen_addr);
+		goto out;
+	}
+
+	if (!cache_seg_gen_addr) {
+		cache_seg->gen = 0;
+		cache_seg->gen_seq = 0;
+		cache_seg->gen_index = 0;
+		goto out;
+	}
+
+	cache_seg->gen = cache_seg_gen.gen;
+	cache_seg->gen_seq = cache_seg_gen.header.seq;
+	cache_seg->gen_index = (cache_seg_gen_addr - cache_seg_ctrl->gen);
+out:
+	mutex_unlock(&cache_seg->ctrl_lock);
+
+	return ret;
+}
+
+static inline struct pcache_cache_seg_gen *get_cache_seg_gen_addr(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+
+	return (cache_seg_ctrl->gen + cache_seg->gen_index);
+}
+
+static void cache_seg_ctrl_write(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_gen cache_seg_gen;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen.gen = cache_seg->gen;
+	cache_seg_gen.header.seq = ++cache_seg->gen_seq;
+	cache_seg_gen.header.crc = pcache_meta_crc(&cache_seg_gen.header,
+						 sizeof(struct pcache_cache_seg_gen));
+
+	memcpy_flushcache(get_cache_seg_gen_addr(cache_seg), &cache_seg_gen, sizeof(struct pcache_cache_seg_gen));
+	pmem_wmb();
+
+	cache_seg->gen_index = (cache_seg->gen_index + 1) % PCACHE_META_INDEX_MAX;
+	mutex_unlock(&cache_seg->ctrl_lock);
+}
+
+static void cache_seg_ctrl_init(struct pcache_cache_segment *cache_seg)
+{
+	cache_seg->gen = 0;
+	cache_seg->gen_seq = 0;
+	cache_seg->gen_index = 0;
+	cache_seg_ctrl_write(cache_seg);
+}
+
+static int cache_seg_meta_load(struct pcache_cache_segment *cache_seg)
+{
+	int ret;
+
+	ret = cache_seg_info_load(cache_seg);
+	if (ret)
+		goto err;
+
+	ret = cache_seg_ctrl_load(cache_seg);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	return ret;
+}
+
+/**
+ * cache_seg_set_next_seg - Sets the ID of the next segment
+ * @cache_seg: Pointer to the cache segment structure.
+ * @seg_id: The segment ID to set as the next segment.
+ *
+ * A pcache_cache allocates multiple cache segments, which are linked together
+ * through next_seg. When loading a pcache_cache, the first cache segment can
+ * be found using cache->seg_id, which allows access to all the cache segments.
+ */
+void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id)
+{
+	cache_seg->cache_seg_info.flags |= PCACHE_SEG_INFO_FLAGS_HAS_NEXT;
+	cache_seg->cache_seg_info.next_seg = seg_id;
+	cache_seg_info_write(cache_seg);
+}
+
+int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache)
+{
+	struct pcache_cache_dev *cache_dev = cache->cache_dev;
+	struct pcache_cache_segment *cache_seg = &cache->segments[cache_seg_id];
+	struct pcache_segment_init_options seg_options = { 0 };
+	struct pcache_segment *segment = &cache_seg->segment;
+	int ret;
+
+	cache_seg->cache = cache;
+	cache_seg->cache_seg_id = cache_seg_id;
+	spin_lock_init(&cache_seg->gen_lock);
+	atomic_set(&cache_seg->refs, 0);
+	mutex_init(&cache_seg->info_lock);
+	mutex_init(&cache_seg->ctrl_lock);
+
+	/* init pcache_segment */
+	seg_options.type = PCACHE_SEGMENT_TYPE_CACHE_DATA;
+	seg_options.data_off = PCACHE_CACHE_SEG_CTRL_OFF + PCACHE_CACHE_SEG_CTRL_SIZE;
+	seg_options.seg_id = seg_id;
+	seg_options.seg_info = &cache_seg->cache_seg_info;
+	pcache_segment_init(cache_dev, segment, &seg_options);
+
+	cache_seg->cache_seg_ctrl = CACHE_DEV_SEGMENT(cache_dev, seg_id) + PCACHE_CACHE_SEG_CTRL_OFF;
+
+	if (new_cache) {
+		cache_dev_zero_range(cache_dev, CACHE_DEV_SEGMENT(cache_dev, seg_id),
+				     PCACHE_SEG_INFO_SIZE * PCACHE_META_INDEX_MAX +
+				     PCACHE_CACHE_SEG_CTRL_SIZE);
+
+		cache_seg_ctrl_init(cache_seg);
+
+		cache_seg->info_index = 0;
+		cache_seg_info_write(cache_seg);
+
+		/* clear outdated kset in segment */
+		memcpy_flushcache(segment->data, &pcache_empty_kset, sizeof(struct pcache_cache_kset_onmedia));
+		pmem_wmb();
+	} else {
+		ret = cache_seg_meta_load(cache_seg);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	return ret;
+}
+
+/**
+ * get_cache_segment - Retrieves a free cache segment from the cache.
+ * @cache: Pointer to the cache structure.
+ *
+ * This function attempts to find a free cache segment that can be used.
+ * It locks the segment map and checks for the next available segment ID.
+ * If a free segment is found, it initializes it and returns a pointer to the
+ * cache segment structure. Returns NULL if no segments are available.
+ */
+struct pcache_cache_segment *get_cache_segment(struct pcache_cache *cache)
+{
+	struct pcache_cache_segment *cache_seg;
+	u32 seg_id;
+
+	spin_lock(&cache->seg_map_lock);
+again:
+	seg_id = find_next_zero_bit(cache->seg_map, cache->n_segs, cache->last_cache_seg);
+	if (seg_id == cache->n_segs) {
+		/* reset the hint of ->last_cache_seg and retry */
+		if (cache->last_cache_seg) {
+			cache->last_cache_seg = 0;
+			goto again;
+		}
+		cache->cache_full = true;
+		spin_unlock(&cache->seg_map_lock);
+		return NULL;
+	}
+
+	/*
+	 * found an available cache_seg, mark it used in seg_map
+	 * and update the search hint ->last_cache_seg
+	 */
+	set_bit(seg_id, cache->seg_map);
+	cache->last_cache_seg = seg_id;
+	spin_unlock(&cache->seg_map_lock);
+
+	cache_seg = &cache->segments[seg_id];
+	cache_seg->cache_seg_id = seg_id;
+
+	return cache_seg;
+}
+
+static void cache_seg_gen_increase(struct pcache_cache_segment *cache_seg)
+{
+	spin_lock(&cache_seg->gen_lock);
+	cache_seg->gen++;
+	spin_unlock(&cache_seg->gen_lock);
+
+	cache_seg_ctrl_write(cache_seg);
+}
+
+void cache_seg_get(struct pcache_cache_segment *cache_seg)
+{
+	atomic_inc(&cache_seg->refs);
+}
+
+static void cache_seg_invalidate(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache *cache;
+
+	cache = cache_seg->cache;
+	cache_seg_gen_increase(cache_seg);
+
+	spin_lock(&cache->seg_map_lock);
+	if (cache->cache_full)
+		cache->cache_full = false;
+	clear_bit(cache_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+
+	pcache_defer_reqs_kick(CACHE_TO_PCACHE(cache));
+	/* clean_work will clean the bad key in key_tree*/
+	queue_work(cache_get_wq(cache), &cache->clean_work);
+}
+
+void cache_seg_put(struct pcache_cache_segment *cache_seg)
+{
+	if (atomic_dec_and_test(&cache_seg->refs))
+		cache_seg_invalidate(cache_seg);
+}
-- 
2.43.0

