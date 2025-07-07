Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2309927AC48
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871567; cv=none; b=dhO5TFyk4ZmbburAiRr9CMWfWWF0dVvNg+hnOpNIkl4LFRVeuZSbYh81YhUt2X5CfZQPcow0xVSNMZt7ArMMc6yT8uxVHD3jKcsfJ24AEZR0fzLwqjH6Q48hHl11lbcqZiG98YQh7Wxov6zj/AQfOLJHNZbZr7SaiWJq3jDQSgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871567; c=relaxed/simple;
	bh=U1vG9YFz/LMeT2DX2gCRhEUstQxsHzCQbL9Uv6F+tcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tq8QfyMcL3sp1ghAgrprDYNGIQoVCNZNwInqTqec4MrtzAjolH47eVq+xLg75vi511ch86kRAczZnVtyRnuFdqVY/mGwH6Zbw2xEuU0AUFD2bfOTAsDcbVi/ZYNdEW0j1sq6R2E7Wz6JIggBcJf+kJRvr6V5SLliKQ3JI+qe0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hh4hzmYC; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hh4hzmYC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751871562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71FSp/3gAvGvU7pG5CkfVtSLgnIV+rDY08DhAR052jQ=;
	b=Hh4hzmYCkz9Haoh7kU4HkyWmHw7AyJ2XdT14aKn9U36h2ir2hf9n+/mW9kYkUJ0y51aKKd
	Myx4CCwb8UDWrWfnsiqzHXpm6KLM2ZoGxR51uPNHQsgQZIjJXFE6kMHapftp7SQ2EGVI4H
	TsF3Vr7Svvme3OmDvs3qWHAFmm5Fvmg=
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
Subject: [PATCH v2 09/11] dm-pcache: add cache_req
Date: Mon,  7 Jul 2025 06:58:07 +0000
Message-ID: <20250707065809.437589-10-dongsheng.yang@linux.dev>
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

Introduce cache_req.c, the high-level engine that
drives I/O requests through dm-pcache. It decides whether data is served
from the cache or fetched from the backing device, allocates new cache
space on writes, and flushes dirty ksets when required.

* Read path
  - Traverses the striped RB-trees to locate cached extents.
  - Generates backing READ requests for gaps and inserts placeholder
    “empty” keys to avoid duplicate fetches.
  - Copies valid data directly from pmem into the caller’s bio; CRC and
    generation checks guard against stale segments.

* Write path
  - Allocates space in the current data segment via cache_data_alloc().
  - Copies data from the bio into pmem, then inserts or updates keys,
    splitting or trimming overlapped ranges as needed.
  - Adds each new key to the active kset; forces kset close when FUA is
    requested or the kset is full.

* Miss handling
  - create_cache_miss_req() builds a backing READ, optionally attaching
    an empty key.
  - miss_read_end_req() replaces the placeholder with real data once the
    READ completes, or deletes it on error.

* Flush support
  - cache_flush() iterates over all ksets and forces them to close,
    ensuring data durability when REQ_PREFLUSH is received.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_req.c | 840 +++++++++++++++++++++++++++++++
 1 file changed, 840 insertions(+)
 create mode 100644 drivers/md/dm-pcache/cache_req.c

diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
new file mode 100644
index 000000000000..3309a593cacc
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -0,0 +1,840 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cache.h"
+#include "backing_dev.h"
+#include "cache_dev.h"
+#include "dm_pcache.h"
+
+static int cache_data_head_init(struct pcache_cache *cache)
+{
+	struct pcache_cache_segment *next_seg;
+	struct pcache_cache_data_head *data_head;
+
+	data_head = get_data_head(cache);
+	next_seg = get_cache_segment(cache);
+	if (!next_seg)
+		return -EBUSY;
+
+	cache_seg_get(next_seg);
+	data_head->head_pos.cache_seg = next_seg;
+	data_head->head_pos.seg_off = 0;
+
+	return 0;
+}
+
+/**
+ * cache_data_alloc - Allocate data for a cache key.
+ * @cache: Pointer to the cache structure.
+ * @key: Pointer to the cache key to allocate data for.
+ *
+ * This function tries to allocate space from the cache segment specified by the
+ * data head. If the remaining space in the segment is insufficient to allocate
+ * the requested length for the cache key, it will allocate whatever is available
+ * and adjust the key's length accordingly. This function does not allocate
+ * space that crosses segment boundaries.
+ */
+static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	struct pcache_cache_data_head *data_head;
+	struct pcache_cache_pos *head_pos;
+	struct pcache_cache_segment *cache_seg;
+	u32 seg_remain;
+	u32 allocated = 0, to_alloc;
+	int ret = 0;
+
+	preempt_disable();
+	data_head = get_data_head(cache);
+again:
+	if (!data_head->head_pos.cache_seg) {
+		seg_remain = 0;
+	} else {
+		cache_pos_copy(&key->cache_pos, &data_head->head_pos);
+		key->seg_gen = key->cache_pos.cache_seg->gen;
+
+		head_pos = &data_head->head_pos;
+		cache_seg = head_pos->cache_seg;
+		seg_remain = cache_seg_remain(head_pos);
+		to_alloc = key->len - allocated;
+	}
+
+	if (seg_remain > to_alloc) {
+		/* If remaining space in segment is sufficient for the cache key, allocate it. */
+		cache_pos_advance(head_pos, to_alloc);
+		allocated += to_alloc;
+		cache_seg_get(cache_seg);
+	} else if (seg_remain) {
+		/* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
+		cache_pos_advance(head_pos, seg_remain);
+		key->len = seg_remain;
+
+		/* Get for key: obtain a reference to the cache segment for the key. */
+		cache_seg_get(cache_seg);
+		/* Put for head_pos->cache_seg: release the reference for the current head's segment. */
+		cache_seg_put(head_pos->cache_seg);
+		head_pos->cache_seg = NULL;
+	} else {
+		/* Initialize a new data head if no segment is available. */
+		ret = cache_data_head_init(cache);
+		if (ret)
+			goto out;
+
+		goto again;
+	}
+
+out:
+	preempt_enable();
+
+	return ret;
+}
+
+static int cache_copy_from_req_bio(struct pcache_cache *cache, struct pcache_cache_key *key,
+				struct pcache_request *pcache_req, u32 bio_off)
+{
+	struct pcache_cache_pos *pos = &key->cache_pos;
+	struct pcache_segment *segment;
+
+	segment = &pos->cache_seg->segment;
+
+	return segment_copy_from_bio(segment, pos->seg_off, key->len, pcache_req->bio, bio_off);
+}
+
+static int cache_copy_to_req_bio(struct pcache_cache *cache, struct pcache_request *pcache_req,
+			    u32 bio_off, u32 len, struct pcache_cache_pos *pos, u64 key_gen)
+{
+	struct pcache_cache_segment *cache_seg = pos->cache_seg;
+	struct pcache_segment *segment = &cache_seg->segment;
+	int ret;
+
+	spin_lock(&cache_seg->gen_lock);
+	if (key_gen < cache_seg->gen) {
+		spin_unlock(&cache_seg->gen_lock);
+		return -EINVAL;
+	}
+
+	ret = segment_copy_to_bio(segment, pos->seg_off, len, pcache_req->bio, bio_off);
+	spin_unlock(&cache_seg->gen_lock);
+
+	return ret;
+}
+
+/**
+ * miss_read_end_req - Handle the end of a miss read request.
+ * @backing_req: Pointer to the request structure.
+ * @read_ret: Return value of read.
+ *
+ * This function is called when a backing request to read data from
+ * the backing_dev is completed. If the key associated with the request
+ * is empty (a placeholder), it allocates cache space for the key,
+ * copies the data read from the bio into the cache, and updates
+ * the key's status. If the key has been overwritten by a write
+ * request during this process, it will be deleted from the cache
+ * tree and no further action will be taken.
+ */
+static void miss_read_end_req(struct pcache_backing_dev_req *backing_req, int read_ret)
+{
+	void *priv_data = backing_req->priv_data;
+	struct pcache_request *pcache_req = backing_req->req.upper_req;
+	struct pcache_cache *cache = backing_req->backing_dev->cache;
+	int ret;
+
+	if (priv_data) {
+		struct pcache_cache_key *key;
+		struct pcache_cache_subtree *cache_subtree;
+
+		key = (struct pcache_cache_key *)priv_data;
+		cache_subtree = key->cache_subtree;
+
+		/* if this key was deleted from cache_subtree by a write, key->flags should be cleared,
+		 * so if cache_key_empty() return true, this key is still in cache_subtree
+		 */
+		spin_lock(&cache_subtree->tree_lock);
+		if (cache_key_empty(key)) {
+			/* Check if the backing request was successful. */
+			if (read_ret) {
+				cache_key_delete(key);
+				goto unlock;
+			}
+
+			/* Allocate cache space for the key and copy data from the backing_dev. */
+			ret = cache_data_alloc(cache, key);
+			if (ret) {
+				cache_key_delete(key);
+				goto unlock;
+			}
+
+			ret = cache_copy_from_req_bio(cache, key, pcache_req, backing_req->req.bio_off);
+			if (ret) {
+				cache_seg_put(key->cache_pos.cache_seg);
+				cache_key_delete(key);
+				goto unlock;
+			}
+			key->flags &= ~PCACHE_CACHE_KEY_FLAGS_EMPTY;
+			key->flags |= PCACHE_CACHE_KEY_FLAGS_CLEAN;
+
+			/* Append the key to the cache. */
+			ret = cache_key_append(cache, key, false);
+			if (ret) {
+				cache_seg_put(key->cache_pos.cache_seg);
+				cache_key_delete(key);
+				goto unlock;
+			}
+		}
+unlock:
+		spin_unlock(&cache_subtree->tree_lock);
+		cache_key_put(key);
+	}
+}
+
+/**
+ * submit_cache_miss_req - Submit a backing request when cache data is missing
+ * @cache: The cache context that manages cache operations
+ * @backing_req: The cache request containing information about the read request
+ *
+ * This function is used to handle cases where a cache read request cannot locate
+ * the required data in the cache. When such a miss occurs during `cache_subtree_walk`,
+ * it triggers a backing read request to fetch data from the backing storage.
+ *
+ * If `pcache_req->priv_data` is set, it points to a `pcache_cache_key`, representing
+ * a new cache key to be inserted into the cache. The function calls `cache_key_insert`
+ * to attempt adding the key. On insertion failure, it releases the key reference and
+ * clears `priv_data` to avoid further processing.
+ */
+static void submit_cache_miss_req(struct pcache_cache *cache, struct pcache_backing_dev_req *backing_req)
+{
+	int ret;
+
+	if (backing_req->priv_data) {
+		struct pcache_cache_key *key;
+
+		/* Attempt to insert the key into the cache if priv_data is set */
+		key = (struct pcache_cache_key *)backing_req->priv_data;
+		ret = cache_key_insert(&cache->req_key_tree, key, true);
+		if (ret) {
+			/* Release the key if insertion fails */
+			cache_key_put(key);
+			backing_req->priv_data = NULL;
+		}
+	}
+	backing_dev_req_submit(backing_req, false);
+}
+
+static struct pcache_backing_dev_req *cache_miss_req_alloc(struct pcache_cache *cache, struct pcache_request *parent)
+{
+	struct pcache_backing_dev *backing_dev = cache->backing_dev;
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache_key *key = NULL;
+	struct pcache_backing_dev_req_opts req_opts = { 0 };
+
+	req_opts.type = BACKING_DEV_REQ_TYPE_REQ;
+	req_opts.req.upper_req = parent;
+
+	backing_req = backing_dev_req_alloc(backing_dev, &req_opts);
+	if (!backing_req)
+		goto out;
+
+	key = cache_key_alloc(&cache->req_key_tree);
+	if (!key) {
+		backing_req->ret = -ENOMEM;
+		goto end_req;
+	}
+
+	cache_key_get(key);
+	backing_req->priv_data = key;
+
+	return backing_req;
+end_req:
+	backing_dev_req_end(backing_req);
+out:
+	return NULL;
+}
+
+static void cache_miss_req_init(struct pcache_cache *cache,
+				struct pcache_backing_dev_req *backing_req,
+				struct pcache_request *parent,
+				u32 off, u32 len, bool insert_key)
+{
+	struct pcache_cache_key *key;
+	struct pcache_backing_dev_req_opts req_opts = { 0 };
+
+	req_opts.type = BACKING_DEV_REQ_TYPE_REQ;
+	req_opts.req.upper_req = parent;
+	req_opts.req.req_off = off;
+	req_opts.req.len = len;
+	req_opts.end_fn = miss_read_end_req;
+
+	backing_dev_req_init(backing_req, &req_opts);
+
+	if (insert_key) {
+		key = backing_req->priv_data;
+		key->off = parent->off + off;
+		key->len = len;
+		key->flags |= PCACHE_CACHE_KEY_FLAGS_EMPTY;
+	} else {
+		key = backing_req->priv_data;
+		backing_req->priv_data = NULL;
+		cache_key_put(key);
+	}
+}
+
+/*
+ * In the process of walking the cache tree to locate cached data, this
+ * function handles the situation where the requested data range lies
+ * entirely before an existing cache node (`key_tmp`). This outcome
+ * signifies that the target data is absent from the cache (cache miss).
+ *
+ * To fulfill this portion of the read request, the function creates a
+ * backing request (`backing_req`) for the missing data range represented
+ * by `key`. It then appends this request to the submission list in the
+ * `ctx`, which will later be processed to retrieve the data from backing
+ * storage. After setting up the backing request, `req_done` in `ctx` is
+ * updated to reflect the length of the handled range, and the range
+ * in `key` is adjusted by trimming off the portion that is now handled.
+ *
+ * The scenario handled here:
+ *
+ *	  |--------|			  key_tmp (existing cached range)
+ * |====|					   key (requested range, preceding key_tmp)
+ *
+ * Since `key` is before `key_tmp`, it signifies that the requested data
+ * range is missing in the cache (cache miss) and needs retrieval from
+ * backing storage.
+ */
+static int read_before(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+
+	/*
+	 * In this scenario, `key` represents a range that precedes `key_tmp`,
+	 * meaning the requested data range is missing from the cache tree
+	 * and must be retrieved from the backing_dev.
+	 */
+	if (!ctx->pre_alloc_req)
+		return SUBTREE_WALK_RET_NEED_REQ;
+
+	backing_req = ctx->pre_alloc_req;
+	ctx->pre_alloc_req = NULL;
+
+	cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, key->len, true);
+
+	list_add(&backing_req->node, ctx->submit_req_list);
+	ctx->req_done += key->len;
+	cache_key_cutfront(key, key->len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ * During cache_subtree_walk, this function manages a scenario where part of the
+ * requested data range overlaps with an existing cache node (`key_tmp`).
+ *
+ *	 |----------------|  key_tmp (existing cached range)
+ * |===========|		   key (requested range, overlapping the tail of key_tmp)
+ */
+static int read_overlap_tail(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	u32 io_len;
+	int ret;
+
+	/*
+	 * Calculate the length of the non-overlapping portion of `key`
+	 * before `key_tmp`, representing the data missing in the cache.
+	 */
+	io_len = cache_key_lstart(key_tmp) - cache_key_lstart(key);
+	if (io_len) {
+		if (!ctx->pre_alloc_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, true);
+
+		list_add(&backing_req->node, ctx->submit_req_list);
+		ctx->req_done += io_len;
+		cache_key_cutfront(key, io_len);
+	}
+
+	/*
+	 * Handle the overlapping portion by calculating the length of
+	 * the remaining data in `key` that coincides with `key_tmp`.
+	 */
+	io_len = cache_key_lend(key) - cache_key_lstart(key_tmp);
+	if (cache_key_empty(key_tmp)) {
+		if (!ctx->pre_alloc_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					io_len, &key_tmp->cache_pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ *    |----|          key_tmp (existing cached range)
+ * |==========|       key (requested range)
+ */
+static int read_overlap_contain(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	u32 io_len;
+	int ret;
+
+	/*
+	 * Calculate the non-overlapping part of `key` before `key_tmp`
+	 * to identify the missing data length.
+	 */
+	io_len = cache_key_lstart(key_tmp) - cache_key_lstart(key);
+	if (io_len) {
+		if (!ctx->pre_alloc_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, true);
+
+		list_add(&backing_req->node, ctx->submit_req_list);
+
+		ctx->req_done += io_len;
+		cache_key_cutfront(key, io_len);
+	}
+
+	/*
+	 * Handle the overlapping portion between `key` and `key_tmp`.
+	 */
+	io_len = key_tmp->len;
+	if (cache_key_empty(key_tmp)) {
+		if (!ctx->pre_alloc_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					io_len, &key_tmp->cache_pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ *	 |-----------|		key_tmp (existing cached range)
+ *	   |====|			key (requested range, fully within key_tmp)
+ *
+ * If `key_tmp` contains valid cached data, this function copies the relevant
+ * portion to the request's bio. Otherwise, it sends a backing request to
+ * fetch the required data range.
+ */
+static int read_overlap_contained(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache_pos pos;
+	int ret;
+
+	/*
+	 * Check if `key_tmp` is empty, indicating a miss. If so, initiate
+	 * a backing request to fetch the required data for `key`.
+	 */
+	if (cache_key_empty(key_tmp)) {
+		if (!ctx->pre_alloc_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, key->len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		cache_pos_copy(&pos, &key_tmp->cache_pos);
+		cache_pos_advance(&pos, cache_key_lstart(key) - cache_key_lstart(key_tmp));
+
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					key->len, &pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += key->len;
+	cache_key_cutfront(key, key->len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ *	 |--------|		  key_tmp (existing cached range)
+ *	   |==========|	  key (requested range, overlapping the head of key_tmp)
+ */
+static int read_overlap_head(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache_pos pos;
+	u32 io_len;
+	int ret;
+
+	io_len = cache_key_lend(key_tmp) - cache_key_lstart(key);
+
+	if (cache_key_empty(key_tmp)) {
+		if (!ctx->pre_alloc_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		cache_pos_copy(&pos, &key_tmp->cache_pos);
+		cache_pos_advance(&pos, cache_key_lstart(key) - cache_key_lstart(key_tmp));
+
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					io_len, &pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/**
+ * read_walk_finally - Finalizes the cache read tree walk by submitting any
+ *					 remaining backing requests
+ * @ctx:	Context structure holding information about the cache,
+ *		read request, and submission list
+ * @ret:	the return value after this walk.
+ *
+ * This function is called at the end of the `cache_subtree_walk` during a
+ * cache read operation. It completes the walk by checking if any data
+ * requested by `key` was not found in the cache tree, and if so, it sends
+ * a backing request to retrieve that data. Then, it iterates through the
+ * submission list of backing requests created during the walk, removing
+ * each request from the list and submitting it.
+ *
+ * The scenario managed here includes:
+ * - Sending a backing request for the remaining length of `key` if it was
+ *   not fulfilled by existing cache entries.
+ * - Iterating through `ctx->submit_req_list` to submit each backing request
+ *   enqueued during the walk.
+ *
+ * This ensures all necessary backing requests for cache misses are submitted
+ * to the backing storage to retrieve any data that could not be found in
+ * the cache.
+ */
+static int read_walk_finally(struct pcache_cache_subtree_walk_ctx *ctx, int ret)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req, *next_req;
+	struct pcache_cache_key *key = ctx->key;
+
+	list_for_each_entry_safe(backing_req, next_req, ctx->submit_req_list, node) {
+		list_del_init(&backing_req->node);
+		submit_cache_miss_req(ctx->cache_tree->cache, backing_req);
+	}
+
+	if (ret != SUBTREE_WALK_RET_OK)
+		return ret;
+
+	if (key->len) {
+		if (!ctx->pre_alloc_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, key->len, true);
+		submit_cache_miss_req(cache, backing_req);
+		ctx->req_done += key->len;
+	}
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ * This function is used within `cache_subtree_walk` to determine whether the
+ * read operation has covered the requested data length. It compares the
+ * amount of data processed (`ctx->req_done`) with the total data length
+ * specified in the original request (`ctx->pcache_req->data_len`).
+ *
+ * If `req_done` meets or exceeds the required data length, the function
+ * returns `true`, indicating the walk is complete. Otherwise, it returns `false`,
+ * signaling that additional data processing is needed to fulfill the request.
+ */
+static bool read_walk_done(struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	return (ctx->req_done >= ctx->pcache_req->data_len);
+}
+
+/**
+ * cache_read - Process a read request by traversing the cache tree
+ * @cache:	 Cache structure holding cache trees and related configurations
+ * @pcache_req:   Request structure with information about the data to read
+ *
+ * This function attempts to fulfill a read request by traversing the cache tree(s)
+ * to locate cached data for the requested range. If parts of the data are missing
+ * in the cache, backing requests are generated to retrieve the required segments.
+ *
+ * The function operates by initializing a key for the requested data range and
+ * preparing a context (`walk_ctx`) to manage the cache tree traversal. The context
+ * includes pointers to functions (e.g., `read_before`, `read_overlap_tail`) that handle
+ * specific conditions encountered during the traversal. The `walk_finally` and `walk_done`
+ * functions manage the end stages of the traversal, while the `delete_key_list` and
+ * `submit_req_list` lists track any keys to be deleted or requests to be submitted.
+ *
+ * The function first calculates the requested range and checks if it fits within the
+ * current cache tree (based on the tree's size limits). It then locks the cache tree
+ * and performs a search to locate any matching keys. If there are outdated keys,
+ * these are deleted, and the search is restarted to ensure accurate data retrieval.
+ *
+ * If the requested range spans multiple cache trees, the function moves on to the
+ * next tree once the current range has been processed. This continues until the
+ * entire requested data length has been handled.
+ */
+static int cache_read(struct pcache_cache *cache, struct pcache_request *pcache_req)
+{
+	struct pcache_cache_key key_data = { .off = pcache_req->off, .len = pcache_req->data_len };
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key_tmp = NULL, *key_next;
+	struct rb_node *prev_node = NULL;
+	struct pcache_cache_key *key = &key_data;
+	struct pcache_cache_subtree_walk_ctx walk_ctx = { 0 };
+	struct pcache_backing_dev_req *backing_req, *next_req;
+	LIST_HEAD(delete_key_list);
+	LIST_HEAD(submit_req_list);
+	int ret;
+
+	walk_ctx.cache_tree = &cache->req_key_tree;
+	walk_ctx.req_done = 0;
+	walk_ctx.pcache_req = pcache_req;
+	walk_ctx.before = read_before;
+	walk_ctx.overlap_tail = read_overlap_tail;
+	walk_ctx.overlap_head = read_overlap_head;
+	walk_ctx.overlap_contain = read_overlap_contain;
+	walk_ctx.overlap_contained = read_overlap_contained;
+	walk_ctx.walk_finally = read_walk_finally;
+	walk_ctx.walk_done = read_walk_done;
+	walk_ctx.delete_key_list = &delete_key_list;
+	walk_ctx.submit_req_list = &submit_req_list;
+
+next:
+	key->off = pcache_req->off + walk_ctx.req_done;
+	key->len = pcache_req->data_len - walk_ctx.req_done;
+	if (key->len > PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK))
+		key->len = PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK);
+
+	cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+	spin_lock(&cache_subtree->tree_lock);
+search:
+	prev_node = cache_subtree_search(cache_subtree, key, NULL, NULL, &delete_key_list);
+	if (!list_empty(&delete_key_list)) {
+		list_for_each_entry_safe(key_tmp, key_next, &delete_key_list, list_node) {
+			list_del_init(&key_tmp->list_node);
+			cache_key_delete(key_tmp);
+		}
+		goto search;
+	}
+
+	walk_ctx.start_node = prev_node;
+	walk_ctx.key = key;
+
+	ret = cache_subtree_walk(&walk_ctx);
+	if (ret == SUBTREE_WALK_RET_RESEARCH)
+		goto search;
+	spin_unlock(&cache_subtree->tree_lock);
+
+	if (ret == SUBTREE_WALK_RET_ERR) {
+		ret = walk_ctx.ret;
+		goto out;
+	}
+
+	if (ret == SUBTREE_WALK_RET_NEED_REQ) {
+		walk_ctx.pre_alloc_req = cache_miss_req_alloc(cache, pcache_req);
+		if (!walk_ctx.pre_alloc_req) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
+	if (walk_ctx.req_done < pcache_req->data_len)
+		goto next;
+	ret = 0;
+out:
+	if (walk_ctx.pre_alloc_req)
+		backing_dev_req_end(walk_ctx.pre_alloc_req);
+
+	list_for_each_entry_safe(backing_req, next_req, &submit_req_list, node) {
+		list_del_init(&backing_req->node);
+		backing_dev_req_end(backing_req);
+	}
+
+	return ret;
+}
+
+static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache_req)
+{
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key;
+	u64 offset = pcache_req->off;
+	u32 length = pcache_req->data_len;
+	u32 io_done = 0;
+	int ret;
+
+	while (true) {
+		if (io_done >= length)
+			break;
+
+		key = cache_key_alloc(&cache->req_key_tree);
+		if (!key) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		key->off = offset + io_done;
+		key->len = length - io_done;
+		if (key->len > PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK))
+			key->len = PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK);
+
+		ret = cache_data_alloc(cache, key);
+		if (ret) {
+			cache_key_put(key);
+			goto err;
+		}
+
+		ret = cache_copy_from_req_bio(cache, key, pcache_req, io_done);
+		if (ret) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_put(key);
+			goto err;
+		}
+
+		cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+		spin_lock(&cache_subtree->tree_lock);
+		ret = cache_key_insert(&cache->req_key_tree, key, true);
+		if (ret) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_put(key);
+			goto unlock;
+		}
+
+		ret = cache_key_append(cache, key, pcache_req->bio->bi_opf & REQ_FUA);
+		if (ret) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_delete(key);
+			goto unlock;
+		}
+
+		io_done += key->len;
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+
+	return 0;
+unlock:
+	spin_unlock(&cache_subtree->tree_lock);
+err:
+	return ret;
+}
+
+/**
+ * cache_flush - Flush all ksets to persist any pending cache data
+ * @cache: Pointer to the cache structure
+ *
+ * This function iterates through all ksets associated with the provided `cache`
+ * and ensures that any data marked for persistence is written to media. For each
+ * kset, it acquires the kset lock, then invokes `cache_kset_close`, which handles
+ * the persistence logic for that kset.
+ *
+ * If `cache_kset_close` encounters an error, the function exits immediately with
+ * the respective error code, preventing the flush operation from proceeding to
+ * subsequent ksets.
+ */
+int cache_flush(struct pcache_cache *cache)
+{
+	struct pcache_cache_kset *kset;
+	u32 i, ret;
+
+	for (i = 0; i < cache->n_ksets; i++) {
+		kset = get_kset(cache, i);
+
+		spin_lock(&kset->kset_lock);
+		ret = cache_kset_close(cache, kset);
+		spin_unlock(&kset->kset_lock);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req)
+{
+	struct bio *bio = pcache_req->bio;
+
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH))
+		return cache_flush(cache);
+
+	if (bio_data_dir(bio) == READ)
+		return cache_read(cache, pcache_req);
+
+	return cache_write(cache, pcache_req);
+}
-- 
2.43.0

