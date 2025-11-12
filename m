Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449FC35470D
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 19:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975826; cv=none; b=JYtcVpmWYbeUQtCmzjc7apUiOOcnVUmFomPvJ0cqGOV/giei4iGYA0nsJffLGAY8L2yH2fBk2ie/rQ3WEw7b9RDDCEOgZ/wsrlYZcVF/SUbQKogMSXaDlfgPPRZUyBfVTLv69BY/6wKEX9F8gDzUWiijRMe4VJE4DHU5wI6vUTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975826; c=relaxed/simple;
	bh=rQ2kHp6lPREv3YxzvbPdgaiaRh8JzJ1empdCPfgiMYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3VvrDibUXJiLLtm/xkOamwtnrBJ0zBdsKlOBP7v3ncXmJ8rJPDjI0eRYBgakDJ3ARmf6LR9w3SvFs+AayuxG6CcfpVkignZpQp7gs1sYxXVkWpTL5GpNiQNeFYvsXf52sO2Dpu6a8lLhC8OXJReSerE2bGby5m+B1zZhNBqHcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KM4cMDhj; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KM4cMDhj"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4e88cacc5d9so9855121cf.0
        for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 11:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975822; x=1763580622; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EE3olEnyRjl52kAEWnA02JLmmLDlTmwS9hIpIeJT8kY=;
        b=KM4cMDhjgk9Y+KE/DmMetXyL8v2pTN+hiiypC8g4Prz0Tt3B1LlqTdOLBEvRsAV0Ek
         jBJkNa2ZNq/n2/HLOWXX1Gn3yH1ImFOfn4t0d05HgKfHXlzDYP6xyZplYWWm5RCQNvWk
         Qy+yATN8R0fKwD8EQhyfEoVE1TYlDWLZPf8TAsWBSwlleUFh3q5uTiSTjIGT83s9hdL4
         d+RIL9jWrVLq0D734BHdbYWvaz3H64zn+usoyIjIO1VwWmyAPVaMK9F4pvGKFycUKIv4
         CNeqDB8VIX2ZKVFPqsim601QlciupjIqwT/Vgc6e96wICIWyBuI74k6H04rFZHCMVjvo
         9FjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975822; x=1763580622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EE3olEnyRjl52kAEWnA02JLmmLDlTmwS9hIpIeJT8kY=;
        b=mexIs4MXNKbqmD788+xcFzscIfh7HqkHeWL7muCwmw68BV5k2qfEqW5wO3+E9wusAR
         5YvgvsnquC1n622m2LY+jqrW/KAdhTmJ0UyFAKLlDYbUzpbVZ1Mi6PRUFIPoADpoRD0z
         mXSk82I4Jqh0AAIEQS563b/1nDNCsx0Q4bIjFIs2JsRVjtbcwKab0AHDHWncTRAnJvA4
         Ib1qVG7XqBHeVk5vvh3VM1ZHYfKBu77iu3vql4JlKTmBZFzcodzZyGGib/EKjXyg7wuf
         5jLyVbkGZkaBGC9Qh/9HhF1mp8G53MEKrW0j5Wj5e8TS+QuWAWFr4XU+vzngXATqRVd5
         dCjg==
X-Forwarded-Encrypted: i=1; AJvYcCVvq5spuwJ4zXzAeOKhCRCsknypkhI2MTbFdJ+UFXXw8OiIHx/xQ48wanUoS2VVk7U8MjqBqJ8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya1W9aF3A185dAB8jyd3PqCacxGPzOKsxlDtjiPpCBr7W69+W1
	sQpvQOskM65fBLPcZufHN611bf5P27hn5tJqQnRHLCYNltixFzSQ6XYcB6diJo06W3M=
X-Gm-Gg: ASbGncsHQgMBywv3whuALqFT+khT15g6/9ZfPYrGZb6RFj3JWqhymGgob9DBpSHZisJ
	GgycM/clebbZn/1rQk6/b6obQRxLl4GGqE4GgwDEcqqVDDIirJSNKECxLhOM1Qu3cUtEz163BF6
	0WltLkpC/CHR56ygLz+YSYMnTiFvZZ+0OOfhpjPFGxZlQAcAhpkTh3RGb77UfiSMpCksZflg0lQ
	He4QhGqm92/5gTGSRClcVZ5P+0WXDmirYV/C86mrlAcLLR1YkfDw3XRcOQCGLnAIMgYsO9Z5hJD
	B7krVyrX6IaJ5IKbp6YjrOwQU60Ma478FgGr8pS7sWoKQZPeHJ40QJOZSsIYFv6IL42wmDKg9pl
	ntW7noItDiHO11bxGhfxfe1qIbYd2GYefhDPFwNh6saIUrgotqPrGOM1Pf+TyyJys2dIrJxb+zY
	11UVXINh1o4lSMSDlERYWJ/1gr6mIlfveBsuX39eMeNq/xJgcziTK21mQl4+ICQd8c
X-Google-Smtp-Source: AGHT+IEpkA9sHRf+vDkvWZyRaV+z+4MD09rdo9Mmp9OjAhV3qhp/e6NAADZhOGarPgun9sbSz0rc+w==
X-Received: by 2002:a05:622a:14f:b0:4e8:b980:4792 with SMTP id d75a77b69052e-4eddbcb30a2mr55332141cf.37.1762975821965;
        Wed, 12 Nov 2025 11:30:21 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:21 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 11/11] [HACK] mm/zswap: compressed ram integration example
Date: Wed, 12 Nov 2025 14:29:27 -0500
Message-ID: <20251112192936.2574429-12-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is an example of how you might use a SPM memory node.

If there is compressed ram available (in this case, a bit present
in mt_spm_nodelist), we skip the entire software compression process
and memcpy directly to a compressed memory folio, and store the newly
allocated compressed memory page as the zswap entry->handle.

On decompress we do the opposite: copy directly from the stored
page to the destination, and free the compressed memory page.

Note: We do not integrate any compressed memory device checks at
this point because this is a stand-in to demonstrate how the SPM
node allocation mechanism works.

See the "TODO" comment in `zswap_compress_direct()` for more details

In reality, we would want to move this mechanism out of zswap into
its own component (cram.c?), and enable a more direct migrate_page()
call that actually re-maps the page read-only into any mappings, and
then provides a write-fault handler which promotes the page on write.

(Similar to a NUMA Hint Fault, but only on write-access)

This prevents any run-away compression ratio failures, since the
compression ratio would be checked on allocation, rather than allowed
to silently decrease on writes until the device becomes unstable.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/zswap.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..e6f48a4e90f1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -25,6 +25,7 @@
 #include <linux/scatterlist.h>
 #include <linux/mempolicy.h>
 #include <linux/mempool.h>
+#include <linux/memory-tiers.h>
 #include <crypto/acompress.h>
 #include <linux/zswap.h>
 #include <linux/mm_types.h>
@@ -191,6 +192,7 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
+	bool direct;
 	struct zswap_pool *pool;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
@@ -717,7 +719,8 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 static void zswap_entry_free(struct zswap_entry *entry)
 {
 	zswap_lru_del(&zswap_list_lru, entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
+	if (!entry->direct)
+		zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
@@ -851,6 +854,43 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
 	mutex_unlock(&acomp_ctx->mutex);
 }
 
+static struct page *zswap_compress_direct(struct page *src,
+					  struct zswap_entry *entry)
+{
+	int nid = first_node(mt_spm_nodelist);
+	struct page *dst;
+	gfp_t gfp;
+
+	if (nid == NUMA_NO_NODE)
+		return NULL;
+
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE |
+	      __GFP_SPM_NODE;
+	dst = __alloc_pages(gfp, 0, nid, &mt_spm_nodelist);
+	if (!dst)
+		return NULL;
+
+	/*
+	 * TODO: check that the page is safe to use
+	 *
+	 * In a real implementation, we would not be using ZSWAP to demonstrate this
+	 * and instead would implement a new component (compressed_ram, cram.c?)
+	 *
+	 * At this point we would check via some callback that the device's memory
+	 * is actually safe to use - and if not, free the page (without writing to
+	 * it), and kick off kswapd for that node to make room.
+	 *
+	 * Alternatively, if the compressed memory device(s) report a watermark
+	 * crossing via interrupt, a flag can be set that is checked here rather
+	 * that calling back into a device driver.
+	 *
+	 * In this case, we're testing with normal memory, so the memory is always
+	 * safe to use (i.e. no compression ratio to worry about).
+	 */
+	copy_mc_highpage(dst, src);
+	return dst;
+}
+
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -862,6 +902,19 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
+	struct page *zpage;
+
+	/* Try to shunt directly to compressed ram */
+	if (!nodes_empty(mt_spm_nodelist)) {
+		zpage = zswap_compress_direct(page, entry);
+		if (zpage) {
+			entry->handle = (unsigned long)zpage;
+			entry->length = PAGE_SIZE;
+			entry->direct = true;
+			return true;
+		}
+		/* otherwise fallback to normal zswap */
+	}
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	dst = acomp_ctx->buffer;
@@ -939,6 +992,16 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
+	/* compressed ram page */
+	if (entry->direct) {
+		struct page *src = (struct page *)entry->handle;
+		struct folio *zfolio = page_folio(src);
+
+		memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
+		__free_page(src);
+		goto direct_done;
+	}
+
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
 
@@ -972,6 +1035,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
+direct_done:
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
 
-- 
2.51.1

