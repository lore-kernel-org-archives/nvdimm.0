Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4783FB1D
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxgFs2EY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696530722; x=1728066722;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=YjfMcrhNvXHMJFZBqykeVf1EucGf0umzz4JhkLD/Qkk=;
  b=WxgFs2EY1MMMzq/57rwiXY8uDjNbigGK+mgRXf0958fYPxmWElO6lIY5
   qHRsuWz3Vp4juB3cCH8j9NGqHG7o/RoibDYbFB6awJBfZfp1qFLvEBMNS
   3enFI9QYtX9RAINKqIfZAyS9/yBA6b44aD1meIkDZwVXnxfsPEQyQurQ0
   TK1VTdwd37NcsWMRPjUi8ZBQdZfq7RDm9c7ReP1dmWWZgMag47lRREdXM
   FTvG6ztPZH4CrDqcBPG0eHRQY/1eUn/KH/SXx8/ubKXf2UbgQWyVfw3Ao
   I4JfRPOnVJrQt7fxyJqiUNjK8HkbIa56FVXaKAaZ2RuLB7u3p1xkRDYzh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="363860733"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="363860733"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 11:31:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="781342828"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="781342828"
Received: from amykuo-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.12.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 11:31:53 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 05 Oct 2023 12:31:39 -0600
Subject: [PATCH v5 1/2] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231005-vv-kmem_memmap-v5-1-a54d1981f0a3@intel.com>
References: <20231005-vv-kmem_memmap-v5-0-a54d1981f0a3@intel.com>
In-Reply-To: <20231005-vv-kmem_memmap-v5-0-a54d1981f0a3@intel.com>
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
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8397;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=YjfMcrhNvXHMJFZBqykeVf1EucGf0umzz4JhkLD/Qkk=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKnyjBJBclPPXj5WJ9n00skx2Nnbcs2GS9KRlhWtZq++T
 wx+vrCyo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABO5ksjwv840ZvXXpHb/uGd+
 V5R/Zp9v9xZqTf16WiFg1e9arjUW+xgZ3mbzL1uzNHTCrsr5mpUrDbtMa13sVv3Nn8TFrinFwWX
 ABwA=
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

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 mm/memory_hotplug.c | 162 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 99 insertions(+), 63 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index f8d3e7427e32..77ec6f15f943 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1380,6 +1380,44 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
 	return arch_supports_memmap_on_memory(vmemmap_size);
 }
 
+static int add_memory_create_devices(int nid, struct memory_group *group,
+				     u64 start, u64 size, mhp_t mhp_flags)
+{
+	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	struct vmem_altmap mhp_altmap = {
+		.base_pfn =  PHYS_PFN(start),
+		.end_pfn  =  PHYS_PFN(start + size - 1),
+	};
+	int ret;
+
+	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY)) {
+		mhp_altmap.free = memory_block_memmap_on_memory_pages();
+		params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
+		if (!params.altmap)
+			return -ENOMEM;
+
+		memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
+	}
+
+	/* call arch's memory hotadd */
+	ret = arch_add_memory(nid, start, size, &params);
+	if (ret < 0)
+		goto error;
+
+	/* create memory block devices after memory was added */
+	ret = create_memory_block_devices(start, size, params.altmap, group);
+	if (ret)
+		goto err_bdev;
+
+	return 0;
+
+err_bdev:
+	arch_remove_memory(start, size, NULL);
+error:
+	kfree(params.altmap);
+	return ret;
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1388,14 +1426,10 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
  */
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
-	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	unsigned long memblock_size = memory_block_size_bytes();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
-	struct vmem_altmap mhp_altmap = {
-		.base_pfn =  PHYS_PFN(res->start),
-		.end_pfn  =  PHYS_PFN(res->end),
-	};
 	struct memory_group *group = NULL;
-	u64 start, size;
+	u64 start, size, cur_start;
 	bool new_node = false;
 	int ret;
 
@@ -1436,28 +1470,21 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	/*
 	 * Self hosted memmap array
 	 */
-	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
-		if (mhp_supports_memmap_on_memory(size)) {
-			mhp_altmap.free = memory_block_memmap_on_memory_pages();
-			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
-			if (!params.altmap)
+	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
+	    mhp_supports_memmap_on_memory(memblock_size)) {
+		for (cur_start = start; cur_start < start + size;
+		     cur_start += memblock_size) {
+			ret = add_memory_create_devices(nid, group, cur_start,
+							memblock_size,
+							mhp_flags);
+			if (ret)
 				goto error;
-
-			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
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
+	} else {
+		ret = add_memory_create_devices(nid, group, start, size,
+						mhp_flags);
+		if (ret)
+			goto error;
 	}
 
 	if (new_node) {
@@ -1494,8 +1521,6 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		walk_memory_blocks(start, size, NULL, online_memory_block);
 
 	return ret;
-error_free:
-	kfree(params.altmap);
 error:
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
@@ -2146,12 +2171,41 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
-static int __ref try_remove_memory(u64 start, u64 size)
+static void __ref remove_memory_block_and_altmap(int nid, u64 start, u64 size)
 {
+	int rc = 0;
 	struct memory_block *mem;
-	int rc = 0, nid = NUMA_NO_NODE;
 	struct vmem_altmap *altmap = NULL;
 
+	rc = walk_memory_blocks(start, size, &mem, test_has_altmap_cb);
+	if (rc) {
+		altmap = mem->altmap;
+		/*
+		 * Mark altmap NULL so that we can add a debug
+		 * check on memblock free.
+		 */
+		mem->altmap = NULL;
+	}
+
+	/*
+	 * Memory block device removal under the device_hotplug_lock is
+	 * a barrier against racing online attempts.
+	 */
+	remove_memory_block_devices(start, size);
+
+	arch_remove_memory(start, size, altmap);
+
+	/* Verify that all vmemmap pages have actually been freed. */
+	if (altmap) {
+		WARN(altmap->alloc, "Altmap not fully unmapped");
+		kfree(altmap);
+	}
+}
+
+static int __ref try_remove_memory(u64 start, u64 size)
+{
+	int rc, nid = NUMA_NO_NODE;
+
 	BUG_ON(check_hotplug_memory_range(start, size));
 
 	/*
@@ -2167,47 +2221,28 @@ static int __ref try_remove_memory(u64 start, u64 size)
 	if (rc)
 		return rc;
 
+	mem_hotplug_begin();
+
 	/*
-	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
-	 * the same granularity it was added - a single memory block.
+	 * For memmap_on_memory, the altmaps could have been added on
+	 * a per-memblock basis. Loop through the entire range if so,
+	 * and remove each memblock and its altmap.
 	 */
 	if (mhp_memmap_on_memory()) {
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
+		unsigned long memblock_size = memory_block_size_bytes();
+		u64 cur_start;
+
+		for (cur_start = start; cur_start < start + size;
+		     cur_start += memblock_size)
+			remove_memory_block_and_altmap(nid, cur_start,
+						       memblock_size);
+	} else {
+		remove_memory_block_and_altmap(nid, start, size);
 	}
 
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
-	/*
-	 * Memory block device removal under the device_hotplug_lock is
-	 * a barrier against racing online attempts.
-	 */
-	remove_memory_block_devices(start, size);
-
-	mem_hotplug_begin();
-
-	arch_remove_memory(start, size, altmap);
-
-	/* Verify that all vmemmap pages have actually been freed. */
-	if (altmap) {
-		WARN(altmap->alloc, "Altmap not fully unmapped");
-		kfree(altmap);
-	}
-
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		memblock_phys_free(start, size);
 		memblock_remove(start, size);
@@ -2219,6 +2254,7 @@ static int __ref try_remove_memory(u64 start, u64 size)
 		try_offline_node(nid);
 
 	mem_hotplug_done();
+
 	return 0;
 }
 

-- 
2.41.0

