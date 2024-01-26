Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28507475;
	Fri, 26 Jan 2024 02:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235395; cv=none; b=p+1/KrTnBgAQypzJDJDyDOv/oZNdNZaSXMOwJKgwSMpIHsyCJL51hM1B/oaD67dSa234jAjXosh1KH//9zWd/ojLetDIfJOrQB5VB3qpr2DMbYMnWm0UHP35j1pLA9QgzuPJu3znbd3ciy+p06syLBLmWyyGwZXXJ4f9awmThyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235395; c=relaxed/simple;
	bh=nx7RLX+uhl79JjIWdTs9rFmr3Wfe6gM2BfnjrEFTzUQ=;
	h=Date:To:From:Subject:Message-Id; b=h18kwFsdP/anDc12DvtTw3bpbzj57DeFggTQBgWffwYNyLJJJvbswFteqBPngfyVyfXKi4ehUuGssQuS7SsBcmH7vKqe5C/dD2d3fRZ1cTTZDSHaueb3bfpOA3jfxU507Nx9YZEJBymVAZ1ayQEcGmer1DEXVzMnumjDvjFEUfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JWwTh5ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JWwTh5ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2815C43390;
	Fri, 26 Jan 2024 02:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235395;
	bh=nx7RLX+uhl79JjIWdTs9rFmr3Wfe6gM2BfnjrEFTzUQ=;
	h=Date:To:From:Subject:From;
	b=JWwTh5macJRo0n6Yx338xdfbx+l0RiFBAt2FFzfePk3gvO4cvLAtEG23QBvr5sfel
	 Mrn4+vnv+7AUFu45wJ3cAk/4OAULA01MgJN/9w2DvuV4WCMERfnZ4wmAvCGGsDF34X
	 z4SNpC/9fhbeJsZwjwnM8jyh1eST4maAVXPbzeAo=
Date: Thu, 25 Jan 2024 18:16:32 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,osalvador@suse.de,nvdimm@lists.linux.dev,mhocko@suse.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,akpm@linux-foundation.org,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch added to mm-unstable branch
Message-Id: <20240126021634.E2815C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>


The patch titled
     Subject: mm/memory_hotplug: export mhp_supports_memmap_on_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: mm/memory_hotplug: export mhp_supports_memmap_on_memory()
Date: Wed, 24 Jan 2024 12:03:49 -0800

In preparation for adding sysfs ABI to toggle memmap_on_memory semantics
for drivers adding memory, export the mhp_supports_memmap_on_memory()
helper. This allows drivers to check if memmap_on_memory support is
available before trying to request it, and display an appropriate
message if it isn't available. As part of this, remove the size argument
to this - with recent updates to allow memmap_on_memory for larger
ranges, and the internal splitting of altmaps into respective memory
blocks, the size argument is meaningless.

Link: https://lkml.kernel.org/r/20240124-vv-dax_abi-v7-4-20d16cb8d23d@intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <nvdimm@lists.linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    6 ++++++
 mm/memory_hotplug.c            |   17 ++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-export-mhp_supports_memmap_on_memory
+++ a/include/linux/memory_hotplug.h
@@ -137,6 +137,7 @@ struct mhp_params {
 
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
 struct range mhp_get_pluggable_range(bool need_mapping);
+bool mhp_supports_memmap_on_memory(void);
 
 /*
  * Zone resizing functions
@@ -277,6 +278,11 @@ static inline bool movable_node_is_enabl
 {
 	return false;
 }
+
+static bool mhp_supports_memmap_on_memory(void)
+{
+	return false;
+}
 
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
--- a/mm/memory_hotplug.c~mm-memory_hotplug-export-mhp_supports_memmap_on_memory
+++ a/mm/memory_hotplug.c
@@ -1337,7 +1337,7 @@ static inline bool arch_supports_memmap_
 }
 #endif
 
-static bool mhp_supports_memmap_on_memory(unsigned long size)
+bool mhp_supports_memmap_on_memory(void)
 {
 	unsigned long vmemmap_size = memory_block_memmap_size();
 	unsigned long memmap_pages = memory_block_memmap_on_memory_pages();
@@ -1346,17 +1346,11 @@ static bool mhp_supports_memmap_on_memor
 	 * Besides having arch support and the feature enabled at runtime, we
 	 * need a few more assumptions to hold true:
 	 *
-	 * a) We span a single memory block: memory onlining/offlinin;g happens
-	 *    in memory block granularity. We don't want the vmemmap of online
-	 *    memory blocks to reside on offline memory blocks. In the future,
-	 *    we might want to support variable-sized memory blocks to make the
-	 *    feature more versatile.
-	 *
-	 * b) The vmemmap pages span complete PMDs: We don't want vmemmap code
+	 * a) The vmemmap pages span complete PMDs: We don't want vmemmap code
 	 *    to populate memory from the altmap for unrelated parts (i.e.,
 	 *    other memory blocks)
 	 *
-	 * c) The vmemmap pages (and thereby the pages that will be exposed to
+	 * b) The vmemmap pages (and thereby the pages that will be exposed to
 	 *    the buddy) have to cover full pageblocks: memory onlining/offlining
 	 *    code requires applicable ranges to be page-aligned, for example, to
 	 *    set the migratetypes properly.
@@ -1368,7 +1362,7 @@ static bool mhp_supports_memmap_on_memor
 	 *       altmap as an alternative source of memory, and we do not exactly
 	 *       populate a single PMD.
 	 */
-	if (!mhp_memmap_on_memory() || size != memory_block_size_bytes())
+	if (!mhp_memmap_on_memory())
 		return false;
 
 	/*
@@ -1391,6 +1385,7 @@ static bool mhp_supports_memmap_on_memor
 
 	return arch_supports_memmap_on_memory(vmemmap_size);
 }
+EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
 static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
@@ -1526,7 +1521,7 @@ int __ref add_memory_resource(int nid, s
 	 * Self hosted memmap array
 	 */
 	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
-	    mhp_supports_memmap_on_memory(memory_block_size_bytes())) {
+	    mhp_supports_memmap_on_memory()) {
 		ret = create_altmaps_and_memory_blocks(nid, group, start, size, mhp_flags);
 		if (ret)
 			goto error;
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

dax-busc-replace-driver-core-lock-usage-by-a-local-rwsem.patch
dax-busc-replace-several-sprintf-with-sysfs_emit.patch
documentatiion-abi-add-abi-documentation-for-sys-bus-dax.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch
dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch

