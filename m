Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C203114274
	for <nvdimm@lists.linux.dev>; Wed,  1 Nov 2023 22:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tr6Mg9Ce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698879147; x=1730415147;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=BJVpsauM2TFedbmnVw8A0R+ub3n3nKsAxG13LldkcLQ=;
  b=Tr6Mg9CelKH7W6nP+ScxbVcWtQM+zH0GAKZ3rlduHUsIRAHjLqRkJe/M
   4UzA9yNjUkY8Lb6rIvxeMY5L7rBECFeR4+TQFwFsfd2S+erhX95VvmnOT
   L5bntQkwR3cZ9sqhGHd8lFYMkh3yNSXZ+QZ+LmPwEWPe5FZ3qEcy8bkPI
   DB7d/8dB5p5T1srTx++8TRasLdzya0MWQTitBum5rlv2lkVUGr5RbhF9I
   oC+hT0R7/Ddod0KmA5TjG+aaobT9NNY6V8fU+yD5xaRNY/Ku+jJ3f8oZV
   oodzH92O9/KwV6XpCKOL5MD0OhbZ2DnaKL9ivrk6M/WapfyS9k6J3PL2+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="10133620"
X-IronPort-AV: E=Sophos;i="6.03,269,1694761200"; 
   d="scan'208";a="10133620"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 15:52:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="796033560"
X-IronPort-AV: E=Sophos;i="6.03,269,1694761200"; 
   d="scan'208";a="796033560"
Received: from dgopalan-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.98.103])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 15:52:24 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 01 Nov 2023 16:51:52 -0600
Subject: [PATCH v8 2/3] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231101-vv-kmem_memmap-v8-2-5e4a83331388@intel.com>
References: <20231101-vv-kmem_memmap-v8-0-5e4a83331388@intel.com>
In-Reply-To: <20231101-vv-kmem_memmap-v8-0-5e4a83331388@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=9997;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=BJVpsauM2TFedbmnVw8A0R+ub3n3nKsAxG13LldkcLQ=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKlO15aW76v3ijU/JueX8Xdj51lPnkr2sOPGN1YzR9o3B
 HLZ34jrKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwERydjAyHOxeY6nlMmcDX+lX
 b41bj8ob500vsbYtCf17gfnESV/x84wMu1XSu0oZFYTNZBd+FNl85M20/jc9cV/q9oerm7/8Wt/
 EAwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The MHP_MEMMAP_ON_MEMORY flag for hotplugged memory is restricted to
'memblock_size' chunks of memory being added. Adding a larger span of
memory precludes memmap_on_memory semantics.

For users of hotplug such as kmem, large amounts of memory might get
added from the CXL subsystem. In some cases, this amount may exceed the
available 'main memory' to store the memmap for the memory being added.
In this case, it is useful to have a way to place the memmap on the
memory being added, even if it means splitting the addition into
memblock-sized chunks.

Change add_memory_resource() to loop over memblock-sized chunks of
memory if caller requested memmap_on_memory, and if other conditions for
it are met. Teach try_remove_memory() to also expect that a memory
range being removed might have been split up into memblock sized chunks,
and to loop through those as needed.

This does preclude being able to use PUD mappings in the direct map; a
proposal to how this could be optimized in the future is laid out
here[1].

[1]: https://lore.kernel.org/linux-mm/b6753402-2de9-25b2-36e9-eacd49752b19@redhat.com/

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 mm/memory_hotplug.c | 213 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 138 insertions(+), 75 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6be7de9efa55..d242e49d7f7b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1380,6 +1380,84 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
 	return arch_supports_memmap_on_memory(vmemmap_size);
 }
 
+static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
+{
+	unsigned long memblock_size = memory_block_size_bytes();
+	u64 cur_start;
+
+	/*
+	 * For memmap_on_memory, the altmaps were added on a per-memblock
+	 * basis; we have to process each individual memory block.
+	 */
+	for (cur_start = start; cur_start < start + size;
+	     cur_start += memblock_size) {
+		struct vmem_altmap *altmap = NULL;
+		struct memory_block *mem;
+
+		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(cur_start)));
+		WARN_ON_ONCE(!mem);
+		if (!mem)
+			continue;
+
+		altmap = mem->altmap;
+		mem->altmap = NULL;
+
+		remove_memory_block_devices(cur_start, memblock_size);
+
+		arch_remove_memory(cur_start, memblock_size, altmap);
+
+		/* Verify that all vmemmap pages have actually been freed. */
+		WARN(altmap->alloc, "Altmap not fully unmapped");
+		kfree(altmap);
+	}
+}
+
+static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
+					    u64 start, u64 size)
+{
+	unsigned long memblock_size = memory_block_size_bytes();
+	u64 cur_start;
+	int ret;
+
+	for (cur_start = start; cur_start < start + size;
+	     cur_start += memblock_size) {
+		struct mhp_params params = { .pgprot =
+						     pgprot_mhp(PAGE_KERNEL) };
+		struct vmem_altmap mhp_altmap = {
+			.base_pfn = PHYS_PFN(cur_start),
+			.end_pfn = PHYS_PFN(cur_start + memblock_size - 1),
+		};
+
+		mhp_altmap.free = memory_block_memmap_on_memory_pages();
+		params.altmap = kmemdup(&mhp_altmap, sizeof(struct vmem_altmap),
+					GFP_KERNEL);
+		if (!params.altmap)
+			return -ENOMEM;
+
+		/* call arch's memory hotadd */
+		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
+		if (ret < 0) {
+			kfree(params.altmap);
+			goto out;
+		}
+
+		/* create memory block devices after memory was added */
+		ret = create_memory_block_devices(cur_start, memblock_size,
+						  params.altmap, group);
+		if (ret) {
+			arch_remove_memory(cur_start, memblock_size, NULL);
+			kfree(params.altmap);
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	if (ret && (cur_start != start))
+		remove_memory_blocks_and_altmaps(start, cur_start - start);
+	return ret;
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1390,10 +1468,6 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
-	struct vmem_altmap mhp_altmap = {
-		.base_pfn =  PHYS_PFN(res->start),
-		.end_pfn  =  PHYS_PFN(res->end),
-	};
 	struct memory_group *group = NULL;
 	u64 start, size;
 	bool new_node = false;
@@ -1436,28 +1510,22 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	/*
 	 * Self hosted memmap array
 	 */
-	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
-		if (mhp_supports_memmap_on_memory(size)) {
-			mhp_altmap.free = memory_block_memmap_on_memory_pages();
-			params.altmap = kmemdup(&mhp_altmap,
-						sizeof(struct vmem_altmap),
-						GFP_KERNEL);
-			if (!params.altmap)
-				goto error;
+	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
+	    mhp_supports_memmap_on_memory(memory_block_size_bytes())) {
+		ret = create_altmaps_and_memory_blocks(nid, group, start, size);
+		if (ret)
+			goto error;
+	} else {
+		ret = arch_add_memory(nid, start, size, &params);
+		if (ret < 0)
+			goto error;
+
+		/* create memory block devices after memory was added */
+		ret = create_memory_block_devices(start, size, NULL, group);
+		if (ret) {
+			arch_remove_memory(start, size, NULL);
+			goto error;
 		}
-		/* fallback to not using altmap  */
-	}
-
-	/* call arch's memory hotadd */
-	ret = arch_add_memory(nid, start, size, &params);
-	if (ret < 0)
-		goto error_free;
-
-	/* create memory block devices after memory was added */
-	ret = create_memory_block_devices(start, size, params.altmap, group);
-	if (ret) {
-		arch_remove_memory(start, size, NULL);
-		goto error_free;
 	}
 
 	if (new_node) {
@@ -1494,8 +1562,6 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		walk_memory_blocks(start, size, NULL, online_memory_block);
 
 	return ret;
-error_free:
-	kfree(params.altmap);
 error:
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
@@ -2062,17 +2128,13 @@ static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 	return 0;
 }
 
-static int test_has_altmap_cb(struct memory_block *mem, void *arg)
+static int count_memory_range_altmaps_cb(struct memory_block *mem, void *arg)
 {
-	struct memory_block **mem_ptr = (struct memory_block **)arg;
-	/*
-	 * return the memblock if we have altmap
-	 * and break callback.
-	 */
-	if (mem->altmap) {
-		*mem_ptr = mem;
-		return 1;
-	}
+	u64 *num_altmaps = (u64 *)arg;
+
+	if (mem->altmap)
+		*num_altmaps += 1;
+
 	return 0;
 }
 
@@ -2146,11 +2208,31 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
+static int memory_blocks_have_altmaps(u64 start, u64 size)
+{
+	u64 num_memblocks = size / memory_block_size_bytes();
+	u64 num_altmaps = 0;
+
+	if (!mhp_memmap_on_memory())
+		return 0;
+
+	walk_memory_blocks(start, size, &num_altmaps,
+			   count_memory_range_altmaps_cb);
+
+	if (num_altmaps == 0)
+		return 0;
+
+	if (num_memblocks != num_altmaps) {
+		WARN_ONCE(1, "Not all memblocks in range have altmaps");
+		return -EINVAL;
+	}
+
+	return 1;
+}
+
 static int __ref try_remove_memory(u64 start, u64 size)
 {
-	struct memory_block *mem;
-	int rc = 0, nid = NUMA_NO_NODE;
-	struct vmem_altmap *altmap = NULL;
+	int rc, nid = NUMA_NO_NODE;
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
@@ -2167,45 +2249,25 @@ static int __ref try_remove_memory(u64 start, u64 size)
 	if (rc)
 		return rc;
 
-	/*
-	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
-	 * the same granularity it was added - a single memory block.
-	 */
-	if (mhp_memmap_on_memory()) {
-		rc = walk_memory_blocks(start, size, &mem, test_has_altmap_cb);
-		if (rc) {
-			if (size != memory_block_size_bytes()) {
-				pr_warn("Refuse to remove %#llx - %#llx,"
-					"wrong granularity\n",
-					start, start + size);
-				return -EINVAL;
-			}
-			altmap = mem->altmap;
-			/*
-			 * Mark altmap NULL so that we can add a debug
-			 * check on memblock free.
-			 */
-			mem->altmap = NULL;
-		}
-	}
-
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
-	/*
-	 * Memory block device removal under the device_hotplug_lock is
-	 * a barrier against racing online attempts.
-	 */
-	remove_memory_block_devices(start, size);
-
 	mem_hotplug_begin();
 
-	arch_remove_memory(start, size, altmap);
-
-	/* Verify that all vmemmap pages have actually been freed. */
-	if (altmap) {
-		WARN(altmap->alloc, "Altmap not fully unmapped");
-		kfree(altmap);
+	rc = memory_blocks_have_altmaps(start, size);
+	if (rc < 0) {
+		goto err;
+	} else if (rc == 0) {
+		/*
+		 * Memory block device removal under the device_hotplug_lock is
+		 * a barrier against racing online attempts.
+		 * No altmaps present, do the removal directly
+		 */
+		remove_memory_block_devices(start, size);
+		arch_remove_memory(start, size, NULL);
+	} else {
+		/* all memblocks in the range have altmaps */
+		remove_memory_blocks_and_altmaps(start, size);
 	}
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
@@ -2218,8 +2280,9 @@ static int __ref try_remove_memory(u64 start, u64 size)
 	if (nid != NUMA_NO_NODE)
 		try_offline_node(nid);
 
+err:
 	mem_hotplug_done();
-	return 0;
+	return (rc < 0 ? rc : 0);
 }
 
 /**

-- 
2.41.0

