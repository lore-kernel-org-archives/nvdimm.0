Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A54E3624BC
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781160464; cv=none; b=KKKRBosBuP+5A/LiAwSqGg0IdUpLINICOehD93YKIAm2dnnmt5T3IYOa49hjxoWZZrHzGnwXUsOsfRok3GqouWXDVqFm8bji+Xy5+AtgMp7QwYGyYGgMiGa9aDz+AxsEBtV2KNiK0EBmhATClGPW2pBozUZldfdKPZZwvt5jamA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781160464; c=relaxed/simple;
	bh=6Z8g1aKEb20QIlsuTPzMKT4oAaz6opjg2ssdEUfk2rU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o0iYKEgpagvpQ5sjC1sBDzjrp65oAV4TQsmHFfBFwg/nTqZh9TsWPrlBucucAw0rzFtkX7B3+ZWtd6235FY5RL9dERio9m132k2nlRd2g0uRJI1nECQL0/6zap4ZkCwGbyIpL/KgqArNHcxDO8kslN2R1x/oG9Hn6oNzwKTWtDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbv747zz1dd8h;
	Thu, 11 Jun 2026 14:21:47 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbv3FYwz1dd8h;
	Thu, 11 Jun 2026 14:21:47 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 164A430004DB;
	Thu, 11 Jun 2026 14:20:22 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:21:41 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>
CC: <surenb@google.com>, <mjguzik@gmail.com>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <shakeel.butt@linux.dev>,
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux@armlinux.org.uk>, <dinguyen@kernel.org>,
	<schuster.simon@siemens-energy.com>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <djbw@kernel.org>, <willy@infradead.org>,
	<peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
	<namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH v2 2/4] mm: use get_i_mmap_root to access the file's i_mmap
Date: Thu, 11 Jun 2026 14:18:58 +0800
Message-ID: <20260611061915.2354307-3-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

Do not access the file's i_mmap directly, use get_i_mmap_root()
to access it. This patch makes preparations for later patch.

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 arch/arm/mm/fault-armv.c   |  3 ++-
 arch/arm/mm/flush.c        |  3 ++-
 arch/nios2/mm/cacheflush.c |  3 ++-
 arch/parisc/kernel/cache.c |  4 +++-
 fs/dax.c                   |  3 ++-
 fs/hugetlbfs/inode.c       |  6 +++---
 include/linux/fs.h         |  5 +++++
 include/linux/mm.h         |  1 +
 kernel/events/uprobes.c    |  3 ++-
 mm/hugetlb.c               |  7 +++++--
 mm/khugepaged.c            |  6 ++++--
 mm/memory-failure.c        |  8 +++++---
 mm/memory.c                |  4 ++--
 mm/mmap.c                  |  2 +-
 mm/nommu.c                 |  9 +++++----
 mm/pagewalk.c              |  2 +-
 mm/rmap.c                  |  2 +-
 mm/vma.c                   | 14 ++++++++------
 18 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
index 91e488767783..1b5fe151e805 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -126,6 +126,7 @@ make_coherent(struct address_space *mapping, struct vm_area_struct *vma,
 {
 	const unsigned long pmd_start_addr = ALIGN_DOWN(addr, PMD_SIZE);
 	const unsigned long pmd_end_addr = pmd_start_addr + PMD_SIZE;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *mpnt;
 	unsigned long offset;
@@ -140,7 +141,7 @@ make_coherent(struct address_space *mapping, struct vm_area_struct *vma,
 	 * cache coherency.
 	 */
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(mpnt, root, pgoff, pgoff) {
 		/*
 		 * If we are using split PTE locks, then we need to take the pte
 		 * lock. Otherwise we are using shared mm->page_table_lock which
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 4d7ef5cc36b6..01588df81bfc 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -238,6 +238,7 @@ void __flush_dcache_folio(struct address_space *mapping, struct folio *folio)
 static void __flush_dcache_aliases(struct address_space *mapping, struct folio *folio)
 {
 	struct mm_struct *mm = current->active_mm;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct vm_area_struct *vma;
 	pgoff_t pgoff, pgoff_end;
 
@@ -251,7 +252,7 @@ static void __flush_dcache_aliases(struct address_space *mapping, struct folio *
 	pgoff_end = pgoff + folio_nr_pages(folio) - 1;
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff_end) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff_end) {
 		unsigned long start, offset, pfn;
 		unsigned int nr;
 
diff --git a/arch/nios2/mm/cacheflush.c b/arch/nios2/mm/cacheflush.c
index 8321182eb927..ab6e064fabe2 100644
--- a/arch/nios2/mm/cacheflush.c
+++ b/arch/nios2/mm/cacheflush.c
@@ -78,11 +78,12 @@ static void flush_aliases(struct address_space *mapping, struct folio *folio)
 	unsigned long flags;
 	pgoff_t pgoff;
 	unsigned long nr = folio_nr_pages(folio);
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 
 	pgoff = folio->index;
 
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff + nr - 1) {
 		unsigned long start;
 
 		if (vma->vm_mm != mm)
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 0170b69a21d3..f99dffd6cc22 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -473,6 +473,7 @@ static inline unsigned long get_upa(struct mm_struct *mm, unsigned long addr)
 void flush_dcache_folio(struct folio *folio)
 {
 	struct address_space *mapping = folio_flush_mapping(folio);
+	struct rb_root_cached *root;
 	struct vm_area_struct *vma;
 	unsigned long addr, old_addr = 0;
 	void *kaddr;
@@ -494,6 +495,7 @@ void flush_dcache_folio(struct folio *folio)
 		return;
 
 	pgoff = folio->index;
+	root = get_i_mmap_root(mapping);
 
 	/*
 	 * We have carefully arranged in arch_get_unmapped_area() that
@@ -503,7 +505,7 @@ void flush_dcache_folio(struct folio *folio)
 	 * on machines that support equivalent aliasing
 	 */
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff + nr - 1) {
 		unsigned long offset = pgoff - vma->vm_pgoff;
 		unsigned long pfn = folio_pfn(folio);
 
diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..d402edc3c1b8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1138,6 +1138,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		struct address_space *mapping, void *entry)
 {
 	unsigned long pfn, index, count, end;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	long ret = 0;
 	struct vm_area_struct *vma;
 
@@ -1201,7 +1202,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 
 	/* Walk all mappings of a given index of a file and writeprotect them */
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, end) {
+	vma_interval_tree_foreach(vma, root, index, end) {
 		pfn_mkclean_range(pfn, count, index, vma);
 		cond_resched();
 	}
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..da5b41ea5bdd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -380,7 +380,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 					struct address_space *mapping,
 					struct folio *folio, pgoff_t index)
 {
-	struct rb_root_cached *root = &mapping->i_mmap;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct hugetlb_vma_lock *vma_lock;
 	unsigned long pfn = folio_pfn(folio);
 	struct vm_area_struct *vma;
@@ -615,7 +615,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
 	if (mapping_mapped(mapping))
-		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
+		hugetlb_vmdelete_list(get_i_mmap_root(mapping), pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
@@ -676,7 +676,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
 		if (mapping_mapped(mapping))
-			hugetlb_vmdelete_list(&mapping->i_mmap,
+			hugetlb_vmdelete_list(get_i_mmap_root(mapping),
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfb..cd46615b8f53 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -556,6 +556,11 @@ static inline int mapping_mapped(const struct address_space *mapping)
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
 
+static inline struct rb_root_cached *get_i_mmap_root(struct address_space *mapping)
+{
+	return &mapping->i_mmap;
+}
+
 /*
  * Might pages of this file have been modified in userspace?
  * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 06bbe9eba636..0a45c6a8b9f2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4041,6 +4041,7 @@ struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root_cached *root,
 struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
 				unsigned long start, unsigned long last);
 
+/* Please use get_i_mmap_root() to get the @root */
 #define vma_interval_tree_foreach(vma, root, start, last)		\
 	for (vma = vma_interval_tree_iter_first(root, start, last);	\
 	     vma; vma = vma_interval_tree_iter_next(vma, start, last))
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4084e926e284..d8561a42aec8 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1201,6 +1201,7 @@ static inline struct map_info *free_map_info(struct map_info *info)
 static struct map_info *
 build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 {
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	unsigned long pgoff = offset >> PAGE_SHIFT;
 	struct vm_area_struct *vma;
 	struct map_info *curr = NULL;
@@ -1210,7 +1211,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 
  again:
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4b80b167cc9c..8bc49d57a116 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5360,6 +5360,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;
+	struct rb_root_cached *root;
 	pgoff_t pgoff;
 
 	/*
@@ -5370,6 +5371,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
 			vma->vm_pgoff;
 	mapping = vma->vm_file->f_mapping;
+	root = get_i_mmap_root(mapping);
 
 	/*
 	 * Take the mapping lock for the duration of the table walk. As
@@ -5377,7 +5379,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
 	i_mmap_lock_write(mapping);
-	vma_interval_tree_foreach(iter_vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(iter_vma, root, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
 			continue;
@@ -6850,6 +6852,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
 			vma->vm_pgoff;
 	struct vm_area_struct *svma;
@@ -6858,7 +6861,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	pte_t *pte;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
+	vma_interval_tree_foreach(svma, root, idx, idx) {
 		if (svma == vma)
 			continue;
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..0f577e4a2ccd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1773,10 +1773,11 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct vm_area_struct *vma;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff) {
 		struct mmu_notifier_range range;
 		struct mm_struct *mm;
 		unsigned long addr;
@@ -2194,7 +2195,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * not be able to observe any missing pages due to the
 		 * previously inserted retry entries.
 		 */
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping),
+					start, end) {
 			if (userfaultfd_missing(vma)) {
 				result = SCAN_EXCEED_NONE_PTE;
 				goto immap_locked;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..85196d9bb26c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -598,7 +598,7 @@ static void collect_procs_file(const struct folio *folio,
 
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping), pgoff,
 				      pgoff) {
 			/*
 			 * Send early kill signal to tasks where a vma covers
@@ -650,7 +650,8 @@ static void collect_procs_fsdax(const struct page *page,
 			t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping), pgoff,
+					pgoff) {
 			if (vma->vm_mm == t->mm)
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
@@ -2251,7 +2252,8 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 		t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping),
+					0, ULONG_MAX) {
 			pgoff_t pgoff;
 
 			if (vma->vm_mm == t->mm &&
diff --git a/mm/memory.c b/mm/memory.c
index 5335077765e2..9ea5d6c8ef4d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4387,7 +4387,7 @@ void unmap_mapping_folio(struct folio *folio)
 
 	i_mmap_lock_read(mapping);
 	if (unlikely(mapping_mapped(mapping)))
-		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+		unmap_mapping_range_tree(get_i_mmap_root(mapping), first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
 }
@@ -4417,7 +4417,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 
 	i_mmap_lock_read(mapping);
 	if (unlikely(mapping_mapped(mapping)))
-		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+		unmap_mapping_range_tree(get_i_mmap_root(mapping), first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..d714fdb357e5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1831,7 +1831,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
 			vma_interval_tree_insert_after(tmp, mpnt,
-					&mapping->i_mmap);
+					get_i_mmap_root(mapping));
 			flush_dcache_mmap_unlock(mapping);
 			i_mmap_unlock_write(mapping);
 		}
diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..0f18ffc658e9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -569,7 +569,7 @@ static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, &mapping->i_mmap);
+		vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -585,7 +585,7 @@ static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, &mapping->i_mmap);
+		vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -1804,6 +1804,7 @@ EXPORT_SYMBOL_GPL(copy_remote_vm_str);
 int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 				size_t newsize)
 {
+	struct rb_root_cached *root = get_i_mmap_root(&inode->i_mapping);
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	pgoff_t low, high;
@@ -1816,7 +1817,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	i_mmap_lock_read(inode->i_mapping);
 
 	/* search for VMAs that fall within the dead zone */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, low, high) {
+	vma_interval_tree_foreach(vma, root, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
@@ -1832,7 +1833,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	 * we don't check for any regions that start beyond the EOF as there
 	 * shouldn't be any
 	 */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, 0, ULONG_MAX) {
+	vma_interval_tree_foreach(vma, root, 0, ULONG_MAX) {
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..8df1b5077951 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -810,7 +810,7 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
 		return -EINVAL;
 
 	lockdep_assert_held(&mapping->i_mmap_rwsem);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, first_index,
+	vma_interval_tree_foreach(vma, get_i_mmap_root(mapping), first_index,
 				  first_index + nr - 1) {
 		/* Clip to the vma */
 		vba = vma->vm_pgoff;
diff --git a/mm/rmap.c b/mm/rmap.c
index 99e1b3dc390b..6cfcdb96071f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -3051,7 +3051,7 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 		i_mmap_lock_read(mapping);
 	}
 lookup:
-	vma_interval_tree_foreach(vma, &mapping->i_mmap,
+	vma_interval_tree_foreach(vma, get_i_mmap_root(mapping),
 			pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
 
diff --git a/mm/vma.c b/mm/vma.c
index d90791b00a7b..6159650c1b42 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -234,7 +234,7 @@ static void __vma_link_file(struct vm_area_struct *vma,
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, &mapping->i_mmap);
+	vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -248,7 +248,7 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_remove(vma, &mapping->i_mmap);
+	vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -319,10 +319,11 @@ static void vma_prepare(struct vma_prepare *vp)
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		vma_interval_tree_remove(vp->vma, &vp->mapping->i_mmap);
+		vma_interval_tree_remove(vp->vma,
+					get_i_mmap_root(vp->mapping));
 		if (vp->adj_next)
 			vma_interval_tree_remove(vp->adj_next,
-						 &vp->mapping->i_mmap);
+					get_i_mmap_root(vp->mapping));
 	}
 
 }
@@ -341,8 +342,9 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 	if (vp->file) {
 		if (vp->adj_next)
 			vma_interval_tree_insert(vp->adj_next,
-						 &vp->mapping->i_mmap);
-		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
+					get_i_mmap_root(vp->mapping));
+		vma_interval_tree_insert(vp->vma,
+					get_i_mmap_root(vp->mapping));
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
-- 
2.53.0


