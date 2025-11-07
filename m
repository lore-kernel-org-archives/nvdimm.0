Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CC1339707
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 22:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762555833; cv=none; b=jKABcTfnlpIqPefFyWte7F+FuLOiaksF4SW9rD8pAdHSDtxmvrTVP/cIITn5EYnNGaXY8IP9CqYnuYFCA2tv+lYY3/iBNZkmQMRL/YiFZvLxtGRFyfXZhfnLNal84H/wwqKuA2bthLo8QKRdnu9xcdbN9gTLghgFVD8yxxDiyms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762555833; c=relaxed/simple;
	bh=OKl0yBHUY2HDyHAzrayh15w08hguionxpa8ckFMJLi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7p5G5JRwKLQqhQzOPPl1W8lfysSfl7W7ANLnxNd6bYFtJZjtKOACLCSysZUtFAa+wouS4J8st01ldPAD4J89e05fchyRoh11LDN11PucRl9SD258oqO0GTtPXHA2VkeP4WF3lqtx5bcU7AZrtreALAqVS/lZvIinScVa2EZayQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=gTPlQx63; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="gTPlQx63"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ed75832448so18721021cf.2
        for <nvdimm@lists.linux.dev>; Fri, 07 Nov 2025 14:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555830; x=1763160630; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9lQPmHHEcXtG9PcD1wB7xt838yvOXXROIsvBhfuZzo=;
        b=gTPlQx63ElFdz5/Em+2QADh4LKc1Ad5jpVXCDBmxvu+fBXUMxDHi1MFy5ogO4Tmflz
         3BiMNfTSYAWPp3Z9oGBRLx3fnhGXr8OZOLAjL3pH71K9CB+qQ6ucQ7iuPUkFbzCXzYnd
         G/xTVSHaBl4gBljX1pgpbSRID8K64K/GUBHTzvwe8AGz8UrKTgpKNCpfkLK8CrobrIdN
         HP27gnTRaWEIFb3LZahA0/6OBEgSHC3HQHpXBi027eG/i/j8gcmAjP42Cdepm3z6tcRC
         yeABbF8N+PW+exDPJM/P7jAv5FPRceb30KaArhotJYPNWU2iVx4qRKC3xLH+bXy2Gz6f
         kmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555830; x=1763160630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t9lQPmHHEcXtG9PcD1wB7xt838yvOXXROIsvBhfuZzo=;
        b=bKTPf/wNsDbAgwpCUMpvlIKfvb10n15rJj8d3JcB7n9h0ANBLMB0d9IFQY321Q2sPi
         HecXJErDpDY21Xik2Bt0yhhyrwGSdJVNdrSCzUlcwoelnjanpfmTC0x0zJgaP8iKhVJ4
         7JNZXjDK2vwW04o2boc07QFbkuLnGlaIReBF4c6fR9xqymLOtYjlh8loqXd4H6SJ+wbR
         wlqFsMeWiJe8pWxaEQO2utPVs/Swl0epG/EqydoVHJ1tGxiGY3C4kdJ0ZaY7cBM0n+UE
         nqdt6kZNXwbuVDqwqpeVz+sBA9CKnbyOIydx+K1AlpiVWDgWZgP1XdHHxiGJ4AlBpVB6
         eEnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcmcWvzOA6KE4nKE0wKhFhHP6DH4OL4o2LtdkALaSWVWiSZiOTz4Wuw79E1qE6LvyRdhqt/NI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2zkQuvsr5FQRBTMAJKKB6wD3GJHkn6k8cjfSS1ZCpazQrbfmK
	s84ZwA9h+5kPsQq79GVtiVvGXwonHNugXi20VvlsSUzdVdUe7fn9yjUMO5dXviotSNLNaEq2iiT
	3eRpU
X-Gm-Gg: ASbGnctz1rp7kVlvaK8mHgh3t9xrMtXmEhzTRprM7+B310J1HpSt8lS+SFoXt6BfFH+
	jGzN/tPmpVrGfElb79cx9yc6bs4r33ifSp8f+EcKjKPU33grFRLRcRZ6DuSB8oO9wiRy23hBZmA
	qbTAXM3guaKz1ctsjfkM01MhVFxmcP0Ne32yH78lKhayVJAsk4o9D+WnQ3Xym7ZMF6ZOyRBa3Ni
	qYeKozNnaBAn6eIw2bptJqUIrYzOMxxskGgB2N3gcXzFcqUI1XHTnBJY3Yr33MgIxlXv8rh5nOj
	LQI1acrBWgMS8nyGjdIn71jOAjO23S6C7xrgrTg6w0eEq+5UavG+RSoR1PS07JugePvTdtLU5xU
	ZSVqpMEgYF8kYOvo4+Q6JmdJwG5ekrCswzEOr0XPorpnMCeKOkHSkzWBNdjfw1xedV+U7Ljvl2B
	5AvUhJZkQO8f657uyIVCA5yv2AdWERzqTkccstGM3DB8oMFWaC6aVnteBNT4b60g9L7Q7wjFO1N
	4h0F3fPigsHUw==
X-Google-Smtp-Source: AGHT+IGiz0rmAqkF080s48owgkrlhIDOgmhn7Uh2wWe1SA/ZeGElIvqZ5FF6lfn2BTWxOTuvNIrg9w==
X-Received: by 2002:ac8:5e47:0:b0:4e8:9683:3a35 with SMTP id d75a77b69052e-4eda4d392e9mr11493571cf.0.1762555830443;
        Fri, 07 Nov 2025 14:50:30 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:29 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH 9/9] [HACK] mm/zswap: compressed ram integration example
Date: Fri,  7 Nov 2025 17:49:54 -0500
Message-ID: <20251107224956.477056-10-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is an example of how you might use a protected memory node.

We hack in an mt_compressed_nodelist to memory-tiers.c as a standin
for a proper compressed-ram component, and use that nodelist to
determine if compressed ram is available in the zswap_compress
function.

If there is compressed ram available, we skip the entire software
compression process and shunt memcpy directly to a compressed memory
folio, and store the newly allocated compressed memory page as the
zswap entry->handle.

On decompress we do the opposite: copy directly from the stored
compressed page to the new destination, and free the compressed
memory page.

Note: We do not integrate any compressed memory device checks at
this point because this is a stand-in to demonstrate how the protected
node allocation mechanism works.  See the "TODO" comment in
`zswap_compress_direct()` for more details on how that would work.

In reality, we would want to make this mechanism out of zswap into
its own component (cram.c?), and enable a more direct migrate_page()
call that actually re-maps the page read-only into any mappings, and
then provides a write-fault handler which promotes the page on write.

This prevents any run-away compression ratio failures, since the
compression ratio would be checked on allocation, rather than allowed
to silently decrease on writes until the device becomes unstable.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory-tiers.h |  1 +
 mm/memory-tiers.c            |  3 ++
 mm/memory_hotplug.c          |  2 ++
 mm/zswap.c                   | 65 +++++++++++++++++++++++++++++++++++-
 4 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 3d3f3687d134..ff2ab7990e8f 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -42,6 +42,7 @@ extern nodemask_t default_dram_nodes;
 extern nodemask_t default_sysram_nodelist;
 #define default_sysram_nodes (nodes_empty(default_sysram_nodelist) ? NULL : \
 			      &default_sysram_nodelist)
+extern nodemask_t mt_compressed_nodelist;
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index b2ee4f73ad54..907635611f17 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -51,6 +51,9 @@ nodemask_t default_dram_nodes = NODE_MASK_NONE;
 /* default_sysram_nodelist is the list of nodes with RAM at __init time */
 nodemask_t default_sysram_nodelist = NODE_MASK_NONE;
 
+/* compressed memory nodes */
+nodemask_t mt_compressed_nodelist = NODE_MASK_NONE;
+
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
 	.dev_name = "memory_tier",
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ceab56b7231d..8fcd894de93c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1592,6 +1592,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	/* At this point if not protected, we can add node to sysram nodes */
 	if (!(mhp_flags & MHP_PROTECTED_MEMORY))
 		node_set(nid, *default_sysram_nodes);
+	else /* HACK: We would create a proper interface for something like this */
+		node_set(nid, mt_compressed_nodelist);
 
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..09010ba2440c 100644
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
+	int nid = first_node(mt_compressed_nodelist);
+	struct page *dst;
+	gfp_t gfp;
+
+	if (nid == NUMA_NO_NODE)
+		return NULL;
+
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE |
+	      __GFP_PROTECTED;
+	dst = __alloc_pages(gfp, 0, nid, &mt_compressed_nodelist);
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
+	if (!nodes_empty(mt_compressed_nodelist)) {
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
@@ -939,6 +992,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
+	/* compressed ram page */
+	if (entry->direct) {
+		struct page *src = (struct page*)entry->handle;
+		struct folio *zfolio = page_folio(src);
+		memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
+		__free_page(src);
+		goto direct_done;
+	}
+
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
 
@@ -972,6 +1034,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
+direct_done:
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
 
-- 
2.51.1

