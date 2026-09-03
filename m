Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C016490C1B
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 12:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438123; cv=none; b=pcmtCBSzHrNpIsBFuyfZVT/y5bhjjJe1yW0HpAl3ecA5imo8C/14yAUVLcKcjcFDK+RM+d0FoaZdcdGrxEHknJmf4yiJgI2vZnqlL8FP4Sg6ro4x9xAoqqIZUvEri8UZ+RjThUnfOwRsmeOWIh09XalenWFmxJpjGCqDQt1Z+X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438123; c=relaxed/simple;
	bh=G8uv8NqcjN/pJXcO5D6thq5P01P4lWTMPeOJansg2MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6d6VZWZ44qwq4HVQbMkBElm7IM+15sNDe/7adbazmGXQMqkvFcTab9cOQHfuLUDJpeNBPUPy7NFDAFQTfxiPN3AzoibRFl6QP4avj6xHiM/1zbgBzjKaXTkiTWbQL3rek/sSRECMYIEAqtNSxvQZJVkZqfeio6p2HRw8RpkM5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Mrl6TNAt; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Mrl6TNAt"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-85c9a79590aso2616265b3a.1
        for <nvdimm@lists.linux.dev>; Thu, 03 Sep 2026 05:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438118; x=1789042918; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6oJC5ERX01rpyohZHkG07vcg33WWq46jJVtIFvSG5mY=;
        b=Mrl6TNAtG/licdpB7zArocBLuVtgqdEBVgHvPdz/WkQTfhk0XSGOZZDRF3uPlExcNe
         stEzdS3GkZ6P4Z629qUh5gfqu/L/s9x3+EGMSEZjVzlNnEoVQLR/8o2hwzb34AdOu7hy
         6fCuOPZa7vFRkxaY9tYD/i3IYZY/NU+8h5tIfGhOctB995jxY3OyvAPe+YHz2od6st8l
         yunPp3UvloXlnQqZNINYfIWeZel/q0DCJT914GeE/Hc6wT+ieos++tGEYg6K7aDjIeJx
         odn0mU+NnxOvG61SBxyyefCkfMM5gjoDRMPKmwR1Qau6oMg+KB3nZgZGfmyz1z8/kDT0
         UIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438118; x=1789042918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6oJC5ERX01rpyohZHkG07vcg33WWq46jJVtIFvSG5mY=;
        b=ltwz0p7KCPhGzJcLLidECI3LkiCqbfbAPdPgQSpryFZ0zSe5i6Ui5VNsW6qK2wpKdQ
         WLNq84XX5aHeJE/4agCFf6b8wbY/hcQulpFgJHqIN7Uya7nVcGkXzqy+7GnnP40C1RSF
         r/Y7TWb51ZaCkKg1MP5QDYK9BmqxyYGsiY8ZjcRzi6N2Dn049Um7r97tg5f8FxYxvuV8
         +ELT7s5kZvKmNogDUijoaLlKDoEB7hVGLRW5AREYaR/T5pQpmfmBfG9krFlLKWueUSn5
         auke2nQH6ne6g5jcElTh/udSAZeePrwAg7W2b0J9eopgWeP1G/0EdQSLEm/qbsYOdt0x
         9baQ==
X-Forwarded-Encrypted: i=1; AKwUvBxYF/RPpaFFbgWS8SbWBaSh7i6TIQyX6QrbWj0zP8woaY1cJD2U1uklisTYRjRC0ZXfp06MkM0=@lists.linux.dev
X-Gm-Message-State: AFuF++mujNkPO+30INwFRvAmSjhT9hLmzEGw0sCkXKeyfSJ81umX1quf
	FMVsbWd9ATsbyP70i+1r+I3depAxAH4lE7BLAg3XO3fT0KwGM/9Rpk7D6vz6k5Dlj4g=
X-Gm-Gg: AYBFou0Yb1iV2QhSw0NklPCbm4B7GjYJMsRS2U23bCXb5tvAV98W4ePHE9XEC6UTWKN
	MnO/6bNFedwbGPp55IBHK4d8vMm56oE4AjQ9V45OBYpkzgUTJnxv7TPk5BkH+zudGfZ9QwV7zp2
	NieQiMPTESfgwSukRL3Wn1fa5q3vRjR565JzlFR1m+yTc5xmK1Z/BXnnwaP2mJDVtLj91ntMLvJ
	qJI9pPPHTZqwG17cH0eAk0rm4kuHa6P8DLUbd/8UpZNW6vecYT57AkGdnh/d0o1D4B4rbkIAT7Y
	XrGKVijtiGAb+lCbEOrVYvFB0G3hayUwxOLC/HwB3aa9zfhjG6YimQZMiLmBY0/bnvztTfMSrcC
	eYMQV6VyS2Lz5ZmXbWapZ1A/6PZa2cHjt9Fc1u6lSiUSYEjBNU+Zvrsx1bclTK7PithAXclbDUQ
	cvaFsRUA91kWVMvWJgxyKgwVDanhgsFoT6MsH9Q92VOm6MswOWgqSjMEdnZNhU2VN1/L0J2MlpC
	awVKm3crjnXludGvUhAHDwJIg==
X-Received: by 2002:a05:6a00:4601:b0:84f:a7bf:8fb9 with SMTP id d2e1a72fcca58-85ed7743221mr15576091b3a.3.1788438117860;
        Thu, 03 Sep 2026 05:21:57 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:21:57 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Date: Thu,  3 Sep 2026 20:21:26 +0800
Message-ID: <20260903122128.12264-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903122128.12264-1-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FS-DAX registers persistent-memory ranges as ZONE_DEVICE memory, and the
kernel normally allocates and initializes vmemmap storage for every
advertised PFN up front. Sparse pmem images and workloads that only use the
DAX direct-access path may never need writable per-PFN state for most of
that range, but still pay the memory and initialization cost.

Add an opt-in dev_pagemap mode that populates FS-DAX vmemmap PTEs from a
shared read-only metadata page. The shared page is initialized with the
common ZONE_DEVICE and dev_pagemap state, so every PFN still has a valid
struct page representation while private metadata allocation is deferred.

This relies on sizeof(struct page) being a power of two, so each vmemmap
page contains a naturally aligned and repeatable set of struct page slots.
It also requires architecture support for runtime vmemmap remapping,
because shared mappings must be replaced with private writable pages before
a PFN can enter userspace mappings.

The initial implementation is deliberately limited to a single
memory-block-aligned range. That is not a fundamental requirement, but keeps
the registration and teardown paths simple; support for multiple ranges or
less strict alignment can be added later.

Provide vmemmap_materialize_page() to replace shared mappings in the
requested metadata range with private writable copies. A later patch will
call it from the FS-DAX fault path.

No caller enables the mode yet.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memremap.h | 11 ++++++-
 mm/memremap.c            | 38 ++++++++++++++++++++++--
 mm/mm_init.c             | 11 +++++++
 mm/sparse-vmemmap.c      | 64 +++++++++++++++++++++++++++++++++++++---
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e3c2ccf872a8..21c9b6aeef67 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -9,6 +9,7 @@
 
 struct resource;
 struct device;
+struct page;
 
 /**
  * struct vmem_altmap - pre-allocated storage for vmemmap_populate
@@ -108,7 +109,8 @@ struct dev_pagemap_ops {
 	void (*folio_split)(struct folio *head, struct folio *tail);
 };
 
-#define PGMAP_ALTMAP_VALID	(1 << 0)
+#define PGMAP_ALTMAP_VALID				BIT(0)
+#define PGMAP_VMEMMAP_OPTIMIZATION			BIT(1)
 
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
@@ -122,6 +124,7 @@ struct dev_pagemap_ops {
  *	A zero value (default) uses base pages as the vmemmap metadata
  *	representation. A bigger value will set up compound struct pages
  *	of the requested order value.
+ * @vmemmap_shared_page: shared read-only vmemmap page for optimized FS-DAX
  * @ops: method table
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
@@ -137,6 +140,7 @@ struct dev_pagemap {
 	enum memory_type type;
 	unsigned int flags;
 	unsigned long vmemmap_shift;
+	struct page *vmemmap_shared_page;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
 	int nr_range;
@@ -232,6 +236,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
+int vmemmap_materialize_page(struct page *page, unsigned int order);
 
 unsigned long memremap_compat_align(void);
 
@@ -307,4 +312,8 @@ static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
 		percpu_ref_put(&pgmap->ref);
 }
 
+static inline bool pgmap_vmemmap_optimizable(struct dev_pagemap *pgmap)
+{
+	return pgmap && pgmap->vmemmap_shared_page != NULL;
+}
 #endif /* _LINUX_MEMREMAP_H_ */
diff --git a/mm/memremap.c b/mm/memremap.c
index accba23aef28..a53d09b84eaa 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -3,6 +3,7 @@
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/kasan.h>
+#include <linux/memory.h>
 #include <linux/memory_hotplug.h>
 #include <linux/memremap.h>
 #include <linux/swap.h>
@@ -83,6 +84,30 @@ static unsigned long pfn_len(struct dev_pagemap *pgmap, unsigned long range_id)
 		pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift;
 }
 
+static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap *pgmap, int nid)
+{
+	const struct range *range = &pgmap->range;
+
+	if (!is_power_of_2(sizeof(struct page)) ||
+	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_VMEMMAP_REMAP) ||
+	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
+		return 0;
+
+	if (pgmap->nr_range != 1 ||
+	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
+		return 0;
+
+	pgmap->vmemmap_shared_page = alloc_pages_node(nid, GFP_KERNEL, 0);
+
+	return pgmap->vmemmap_shared_page ? 0 : -ENOMEM;
+}
+
+static inline void pgmap_vmemmap_shared_page_free(struct dev_pagemap *pgmap)
+{
+	if (pgmap->vmemmap_shared_page)
+		put_page(pgmap->vmemmap_shared_page);
+}
+
 static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 {
 	struct range *range = &pgmap->ranges[range_id];
@@ -93,8 +118,9 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 
 	/* pages are dead and unused, undo the arch mapping */
 	mem_hotplug_begin();
-	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(range->start),
-				   PHYS_PFN(range_len(range)));
+	if (!pgmap_vmemmap_optimizable(pgmap))
+		remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(range->start),
+					   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
 			       PHYS_PFN(range_len(range)), NULL, pgmap);
@@ -123,6 +149,7 @@ void memunmap_pages(struct dev_pagemap *pgmap)
 
 	for (i = 0; i < pgmap->nr_range; i++)
 		pageunmap_range(pgmap, i);
+	pgmap_vmemmap_shared_page_free(pgmap);
 	percpu_ref_exit(&pgmap->ref);
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
@@ -310,6 +337,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 		break;
 	case MEMORY_DEVICE_FS_DAX:
 		params.pgprot = pgprot_decrypted(params.pgprot);
+		error = pgmap_vmemmap_shared_page_alloc(pgmap, nid);
+		if (error)
+			return ERR_PTR(error);
 		break;
 	case MEMORY_DEVICE_GENERIC:
 		break;
@@ -324,8 +354,10 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 	init_completion(&pgmap->done);
 	error = percpu_ref_init(&pgmap->ref, dev_pagemap_percpu_release, 0,
 				GFP_KERNEL);
-	if (error)
+	if (error) {
+		pgmap_vmemmap_shared_page_free(pgmap);
 		return ERR_PTR(error);
+	}
 
 	/*
 	 * Clear the pgmap nr_range as it will be incremented for each
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2ed17cc707ed..7dd03b8a8d28 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -33,6 +33,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/memremap.h>
 #include "internal.h"
 #include "mm_init.h"
 #include "page_alloc.h"
@@ -1133,6 +1134,15 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	if (!nr_pages)
 		return;
 
+	if (pgmap_vmemmap_optimizable(pgmap)) {
+		struct page *page = page_address(pgmap->vmemmap_shared_page);
+
+		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+			__init_zone_device_page(page + i, start_pfn + i,
+						ZONE_DEVICE, nid, pgmap);
+		goto pageblock_init;
+	}
+
 	/*
 	 * Seed the reusable head-page template from the first real struct
 	 * page. The normal page-init and refcount helpers must operate on
@@ -1164,6 +1174,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
+pageblock_init:
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
 					 /* isolate */ false, /* atomic */ false);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e62e6aa07f12..4dc7f020ed10 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -37,6 +37,8 @@
  */
 /* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
 #define VMEMMAP_POPULATE_PAGEREF	0x0001
+/* Read-only shared vmemmap mappings for FS-DAX base pages */
+#define VMEMMAP_POPULATE_FSDAX_SHARED	0x0002
 
 #include "internal.h"
 #include "mm_init.h"
@@ -262,10 +264,11 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (flags & (VMEMMAP_POPULATE_PAGEREF | VMEMMAP_POPULATE_FSDAX_SHARED))
 				get_page(pfn_to_page(ptpfn));
 		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		entry = pfn_pte(ptpfn, flags & VMEMMAP_POPULATE_FSDAX_SHARED ?
+				PAGE_KERNEL_RO : PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
@@ -379,6 +382,54 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
 }
 
+#ifdef CONFIG_ZONE_DEVICE
+static int __vmemmap_materialize_page(struct page *page)
+{
+	unsigned long addr = PAGE_ALIGN_DOWN((unsigned long)page);
+	struct dev_pagemap *pgmap = page_pgmap(page);
+	struct page *candidate, *template = pgmap->vmemmap_shared_page;
+	pte_t *pte = virt_to_kpte(addr);
+
+	if (pte_page(ptep_get(pte)) != template)
+		return 0;
+
+	candidate = alloc_pages_node(page_to_nid(page), GFP_KERNEL, 0);
+	if (!candidate)
+		return -ENOMEM;
+	copy_page(page_address(candidate), page_address(template));
+
+	spin_lock(&init_mm.page_table_lock);
+	if (pte_page(ptep_get(pte)) != template) {
+		__free_page(candidate);
+		goto out;
+	}
+	/* Make the copied struct page contents visible before the PTE update. */
+	smp_wmb();
+	set_pte_at(&init_mm, addr, pte, mk_pte(candidate, PAGE_KERNEL));
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	put_page(template);
+out:
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+int vmemmap_materialize_page(struct page *page, unsigned int order)
+{
+	struct dev_pagemap *pgmap = page_pgmap(page);
+	unsigned long end = (unsigned long)(page + (1UL << order));
+
+	if (!pgmap_vmemmap_optimizable(pgmap))
+		return 0;
+
+	for (unsigned long addr = (unsigned long)page; addr < end; addr += PAGE_SIZE)
+		if (__vmemmap_materialize_page((struct page *)addr))
+			return -ENOMEM;
+
+	return 0;
+}
+#endif /* CONFIG_ZONE_DEVICE */
+
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
@@ -581,7 +632,11 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
+	if (pgmap_vmemmap_optimizable(pgmap))
+		r = vmemmap_populate_range(start, end, nid, NULL,
+					   page_to_pfn(pgmap->vmemmap_shared_page),
+					   VMEMMAP_POPULATE_FSDAX_SHARED);
+	else if (vmemmap_can_optimize(altmap, pgmap))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
@@ -887,7 +942,8 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!pgmap_vmemmap_optimizable(pgmap))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
-- 
2.54.0

