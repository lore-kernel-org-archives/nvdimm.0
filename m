Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A279286424
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871552; cv=none; b=H/+oHOkEXA+yywyruROVkhYplJ7nFbipuPKL/bwgLaBAr/rYxNFph6jsGgkDZ8aMlTNYrSjQxBsyzKBqmpqGGsx036eOfuPtO8Ca50vYRPxWhoKrR4RyDYiY+5hwdfUkCAEsyooJy1G/F+HVHVRHWUhBi0I8AhRcNmlsTkRCSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871552; c=relaxed/simple;
	bh=sapfkLMRKNwpfsdsTudqKZq5ETePA40uI1yuNPBo4Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+QFurekTSaByUQ7G9x4LLFjiqiGTVXha6eX1YZj9e7ehUf4SVAeh/d2fBBJsUi9+33/gihJBz6rx0ELptQCQvTUNFPEbl2vNhI6hbX/uBQpiCy9bagPt4E56hLnSxsC13xhvRNY13q4HCwReRlz436vv/iPxkJzRHI4ClFusxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lLLx9Ift; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lLLx9Ift"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751871546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nkqkQYAithhpTWZlh9XirR86YYEEZCMT9zwHDmTjKQI=;
	b=lLLx9IftpsEX74Fc8RiTDevu4Pc2UHBtQeBPIdKOcRmuRn6Hj+7yaqLlKHoMrfG/QoIHp5
	vA1c/Lvd9UWnupN6wWKEHTAPVMvjEj98roPS73Rs3cCndhGRUNAdw8V5yH9VVksKMqr30Y
	fEPRmBhuao0E//mAINj2MAbWsdmbzKs=
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
Subject: [PATCH v2 06/11] dm-pcache: add cache_writeback
Date: Mon,  7 Jul 2025 06:58:04 +0000
Message-ID: <20250707065809.437589-7-dongsheng.yang@linux.dev>
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

Introduce cache_writeback.c, which implements the asynchronous write-back
path for pcache.  The new file is responsible for detecting dirty data,
organising it into an in-memory tree, issuing bios to the backing block
device, and advancing the cache’s *dirty tail* pointer once data has
been safely persisted.

* Dirty-state detection
  - `__is_cache_clean()` reads the kset header at `dirty_tail`, checks
    magic and CRC, and thus decides whether there is anything to flush.

* Write-back scheduler
  - `cache_writeback_work` is queued on the cache task-workqueue and
    re-arms itself at `PCACHE_CACHE_WRITEBACK_INTERVAL`.
  - Uses an internal spin-protected `writeback_key_tree` to batch keys
    belonging to the same stripe before IO.

* Key processing
  - `cache_kset_insert_tree()` decodes each key inside the on-media
    kset, allocates an in-memory key object, and inserts it into the
    writeback_key_tree.
  - `cache_key_writeback()` builds a *KMEM-type* backing request that
    maps the persistent-memory range directly into a WRITE bio and
    submits it with `submit_bio_noacct()`.
  - After all keys from the writeback_key_tree have been flushed,
    `backing_dev_flush()` issues a single FLUSH to ensure durability.

* Tail advancement
  - Once a kset is written back, `cache_pos_advance()` moves
    `cache->dirty_tail` by the exact on-disk size and the new position is
    persisted via `cache_encode_dirty_tail()`.
  - When the `PCACHE_KSET_FLAGS_LAST` flag is seen, the write-back
    engine switches to the next segment indicated by `next_cache_seg_id`.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_writeback.c | 279 +++++++++++++++++++++++++
 1 file changed, 279 insertions(+)
 create mode 100644 drivers/md/dm-pcache/cache_writeback.c

diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
new file mode 100644
index 000000000000..970536187daa
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/bio.h>
+
+#include "cache.h"
+#include "backing_dev.h"
+#include "cache_dev.h"
+#include "dm_pcache.h"
+
+static void writeback_ctx_end(struct pcache_cache *cache, int ret)
+{
+	if (ret && !cache->writeback_ctx.ret) {
+		pcache_dev_err(CACHE_TO_PCACHE(cache), "writeback error: %d", ret);
+		cache->writeback_ctx.ret = ret;
+	}
+
+	if (!atomic_dec_and_test(&cache->writeback_ctx.pending))
+		return;
+
+	if (!cache->writeback_ctx.ret) {
+		backing_dev_flush(cache->backing_dev);
+
+		mutex_lock(&cache->dirty_tail_lock);
+		cache_pos_advance(&cache->dirty_tail, cache->writeback_ctx.advance);
+		cache_encode_dirty_tail(cache);
+		mutex_unlock(&cache->dirty_tail_lock);
+	}
+	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
+}
+
+static void writeback_end_req(struct pcache_backing_dev_req *backing_req, int ret)
+{
+	struct pcache_cache *cache = backing_req->priv_data;
+
+	mutex_lock(&cache->writeback_lock);
+	writeback_ctx_end(cache, ret);
+	mutex_unlock(&cache->writeback_lock);
+}
+
+static inline bool is_cache_clean(struct pcache_cache *cache, struct pcache_cache_pos *dirty_tail)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 to_copy;
+	void *addr;
+	int ret;
+
+	addr = cache_pos_addr(dirty_tail);
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->wb_kset_onmedia_buf;
+
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - dirty_tail->seg_off);
+	ret = copy_mc_to_kernel(kset_onmedia, addr, to_copy);
+	if (ret) {
+		pcache_dev_err(pcache, "error to read kset: %d", ret);
+		return true;
+	}
+
+	/* Check if the magic number matches the expected value */
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
+		pcache_dev_debug(pcache, "dirty_tail: %u:%u magic: %llx, not expected: %llx\n",
+				dirty_tail->cache_seg->cache_seg_id, dirty_tail->seg_off,
+				kset_onmedia->magic, PCACHE_KSET_MAGIC);
+		return true;
+	}
+
+	/* Verify the CRC checksum for data integrity */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		pcache_dev_debug(pcache, "dirty_tail: %u:%u crc: %x, not expected: %x\n",
+				dirty_tail->cache_seg->cache_seg_id, dirty_tail->seg_off,
+				cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return true;
+	}
+
+	return false;
+}
+
+void cache_writeback_exit(struct pcache_cache *cache)
+{
+	cancel_delayed_work_sync(&cache->writeback_work);
+	cache_tree_exit(&cache->writeback_key_tree);
+}
+
+int cache_writeback_init(struct pcache_cache *cache)
+{
+	int ret;
+
+	ret = cache_tree_init(cache, &cache->writeback_key_tree, 1);
+	if (ret)
+		goto err;
+
+	atomic_set(&cache->writeback_ctx.pending, 0);
+
+	/* Queue delayed work to start writeback handling */
+	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
+
+	return 0;
+err:
+	return ret;
+}
+
+static int cache_key_writeback(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	struct pcache_backing_dev_req *writeback_req;
+	struct pcache_backing_dev_req_opts writeback_req_opts = { 0 };
+	struct pcache_cache_pos *pos;
+	void *addr;
+	u32 seg_remain;
+	u64 off;
+
+	if (cache_key_clean(key))
+		return 0;
+
+	pos = &key->cache_pos;
+
+	seg_remain = cache_seg_remain(pos);
+	BUG_ON(seg_remain < key->len);
+
+	addr = cache_pos_addr(pos);
+	off = key->off;
+
+	writeback_req_opts.type = BACKING_DEV_REQ_TYPE_KMEM;
+	writeback_req_opts.end_fn = writeback_end_req;
+	writeback_req_opts.priv_data = cache;
+
+	writeback_req_opts.kmem.data = addr;
+	writeback_req_opts.kmem.opf = REQ_OP_WRITE;
+	writeback_req_opts.kmem.len = key->len;
+	writeback_req_opts.kmem.backing_off = off;
+
+	writeback_req = backing_dev_req_create(cache->backing_dev, &writeback_req_opts);
+	if (!writeback_req)
+		return -EIO;
+
+	atomic_inc(&cache->writeback_ctx.pending);
+	backing_dev_req_submit(writeback_req, true);
+
+	return 0;
+}
+
+static int cache_wb_tree_writeback(struct pcache_cache *cache, u32 advance)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_tree *cache_tree = &cache->writeback_key_tree;
+	struct pcache_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct pcache_cache_key *key;
+	int ret = 0;
+	u32 i;
+
+	cache->writeback_ctx.ret = 0;
+	cache->writeback_ctx.advance = advance;
+	atomic_set(&cache->writeback_ctx.pending, 1);
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		cache_subtree = &cache_tree->subtrees[i];
+
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+
+			ret = cache_key_writeback(cache, key);
+			if (ret) {
+				pcache_dev_err(pcache, "writeback error: %d\n", ret);
+				goto release;
+			}
+
+			cache_key_delete(key);
+		}
+	}
+release:
+	writeback_ctx_end(cache, ret);
+
+	return ret;
+}
+
+static int cache_kset_insert_tree(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key;
+	int ret;
+	u32 i;
+
+	/* Iterate through all keys in the kset and write each back to storage */
+	for (i = 0; i < kset_onmedia->key_num; i++) {
+		key_onmedia = &kset_onmedia->data[i];
+
+		key = cache_key_alloc(&cache->writeback_key_tree);
+		if (!key)
+			return -ENOMEM;
+
+		ret = cache_key_decode(cache, key_onmedia, key);
+		if (ret) {
+			cache_key_put(key);
+			return ret;
+		}
+
+		cache_subtree = get_subtree(&cache->writeback_key_tree, key->off);
+		spin_lock(&cache_subtree->tree_lock);
+		ret = cache_key_insert(&cache->writeback_key_tree, key, true);
+		spin_unlock(&cache_subtree->tree_lock);
+		if (ret) {
+			cache_key_put(key);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void last_kset_writeback(struct pcache_cache *cache,
+		struct pcache_cache_kset_onmedia *last_kset_onmedia)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_segment *next_seg;
+
+	pcache_dev_debug(pcache, "last kset, next: %u\n", last_kset_onmedia->next_cache_seg_id);
+
+	next_seg = &cache->segments[last_kset_onmedia->next_cache_seg_id];
+
+	mutex_lock(&cache->dirty_tail_lock);
+	cache->dirty_tail.cache_seg = next_seg;
+	cache->dirty_tail.seg_off = 0;
+	cache_encode_dirty_tail(cache);
+	mutex_unlock(&cache->dirty_tail_lock);
+}
+
+void cache_writeback_fn(struct work_struct *work)
+{
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, writeback_work.work);
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_pos dirty_tail;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 delay;
+	int ret;
+
+	mutex_lock(&cache->writeback_lock);
+	if (atomic_read(&cache->writeback_ctx.pending))
+		goto unlock;
+
+	if (pcache_is_stopping(pcache))
+		goto unlock;
+
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->wb_kset_onmedia_buf;
+
+	mutex_lock(&cache->dirty_tail_lock);
+	cache_pos_copy(&dirty_tail, &cache->dirty_tail);
+	mutex_unlock(&cache->dirty_tail_lock);
+
+	if (is_cache_clean(cache, &dirty_tail)) {
+		delay = PCACHE_CACHE_WRITEBACK_INTERVAL;
+		goto queue_work;
+	}
+
+	if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+		last_kset_writeback(cache, kset_onmedia);
+		delay = 0;
+		goto queue_work;
+	}
+
+	ret = cache_kset_insert_tree(cache, kset_onmedia);
+	if (ret) {
+		delay = PCACHE_CACHE_WRITEBACK_INTERVAL;
+		goto queue_work;
+	}
+
+	ret = cache_wb_tree_writeback(cache, get_kset_onmedia_size(kset_onmedia));
+	if (ret) {
+		delay = PCACHE_CACHE_WRITEBACK_INTERVAL;
+		goto queue_work;
+	}
+
+	delay = 0;
+queue_work:
+	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, delay);
+unlock:
+	mutex_unlock(&cache->writeback_lock);
+}
-- 
2.43.0

