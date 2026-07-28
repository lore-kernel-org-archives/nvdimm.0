Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357DA438486;
	Tue, 28 Jul 2026 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785243991; cv=none; b=k9lw4YsFf+acKCn2oRYpYoqspGJonTjR9y6TBwlSj6fywem3ey746hwAROtCYbFJDoTzXS1/Udr9kroXfjE8VkFdx+4166rvzSKUhQ+Q5JD2L8iPlmAUMwZy88rSeX/q5yEmY6RHH3yH2gUshHCnF1j89I1NC8hAw+FDKjcAwXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785243991; c=relaxed/simple;
	bh=MK+yK9+EsVncu5D9TN0NZpFtspr4HNPCuhfq6/Zc4TI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=G6D+5XhokJgrjPWpL0oXZtHlCu5bJTxlfRA5Xjp0mM6GV2Esz9qVQXe9xssv8nHXzgVjFo00UJ0hBIdDZTLuQCy6yG6lBoQd7gGqK6E2JFNuMBt3/ngMfhNCyzZBUTSpTaewCdNkRlKMk4xGtD4kK+OIJTJiaQq7K9A5UAfdwFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMYlrLRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMYlrLRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1816A1F000E9;
	Tue, 28 Jul 2026 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785243988;
	bh=H8HBeZjYAXygsZtNwha3vzJ3eIo+6LKmNv8ReWtsU1w=;
	h=From:Date:Subject:To:Cc;
	b=ZMYlrLRJbOYxYGNKwd59Rwpbz8tDTVNFxFtjj64q5x31XW/JX7fbCwHGtO4cPZLRw
	 m85KZJCbep+2EWy9+aMBoeJ876GoxZjT1wq+Wdf4BqKp8AJck6lfL2Wuc1Dxi1j0SN
	 FH2NAB286FQeavN2Q9vGf/1Mly7GRjDFgX+G/XBEaXAvGLgqnT3/Twcp8bOAWxY8Gm
	 oPmRH3NCv4tbSpwVUwWWs+NNo4U/+7mIw8mfVkcRqaIrw7u17FVakAuhW9CY3qO19o
	 3XtHbRDu2pz4Wcg2bzayo53+uuUGKc2rHCmWZ6VXR1a9zIw3P/D2XtUSQtQcnPZ9Yi
	 9VO7vkXq+6qhA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 28 Jul 2026 14:06:03 +0100
Subject: [PATCH RFC] mm/huge_memory: eliminate reference-counted huge zero
 folio
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-persist-huge-zero-folio-v1-1-e7b604eaf416@kernel.org>
X-B4-Tracking: v=1; b=H4sIADqpaGoC/yWMQQ6CQAxFr0K6tslMSRDdmngAt8aFDAVqDENaM
 ATC3R1l+f7PeysYq7DBOVtB+SMmsU/gDxmE7tm3jFInBnJUuCOVOLCa2IjdlL6FNWIT3xKxyn1
 wzlN+KgiSPSg3Mv/Ld7hdL/DYR5uqF4fx14Rt+wJ70YYngAAAAA==
X-Change-ID: 20260728-persist-huge-zero-folio-b31c00123962
To: ljs@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, Pankaj Raghav <pankaj.raghav@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=19722; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MK+yK9+EsVncu5D9TN0NZpFtspr4HNPCuhfq6/Zc4TI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIyVtopHXs2q43zaNfacxMZ3myLeKd2qpiRgXueYJtLp
 eG8a/cvdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiqu0MfyViK5l+RZ7SWlk/
 /0KlRVv0sRStXQL6tvyt0aFlrk1cixgZ5nFmTjy2fvma72X3PtgcrAtTXHfYQa3lxe2HDiGL9nD
 +4QYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

The reference-counted huge zero folio is problematic - it's prone to subtle
races, it can introduce allocation latency and it is confusing and
complicated code.

Commit 2d8bd8049e89 ("mm: add persistent huge zero folio") significantly
improved this situation by introducing CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
which provides a single huge PMD-sized folio at boot which is used
consistently as the huge zero folio.

This was made optional to account for systems which have constrained
memory.

However the existence of this folio is predicated on
CONFIG_TRANSPARENT_HUGEPAGE, which already implies higher memory
requirements (if THP, as it defaults to, is globally enabled to any degree
memory reserves are already significantly increased by
set_recommended_min_free_kbytes()).

So memory-constrained systems should already not set
CONFIG_TRANSPARENT_HUGEPAGE, and it is reasonable to consider this
configuration option gating us from embedded systems that are cautious
about this.

The huge zero folio becomes much larger in systems with larger page
size (with 64 KiB arm64 systems having 512 MiB PMDs), however the same
argument regarding the reserves applies there, and arbitrarily allocating
512 MiB on a THP read fault is equally problematic.

In the case that we cannot allocate the huge zero folio at startup, THP is
disabled using the TRANSPARENT_HUGEPAGE_UNSUPPORTED flag.

The benefits of enabling this by default are:

* Significant reduction in code complexity (and lots of code deleted).

* Elimination of any class of bug relating to huge zero folio memory
  ordering.

* Elimination of latency on huge page read fault.

* Huge zero shrinker is completely removed.

* do_huge_pmd_anonymous_page() no longer ever falls back to non-THP on
  read fault and the logic is simplified.

* copy_huge_pmd() simplified.

* Frees up an mm flag (MMF_HUGE_ZERO_FOLIO no longer required).

largest_zero_folio() needs some care - the callers of this function may
have !CONFIG_TRANSPARENT_HUGEPAGE so update it to reflect that and document
it.

Therefore, remove CONFIG_PERSISTENT_HUGE_ZERO_FOLIO and enable the
functionality by default.

The boot-time allocation is accounted via the existing thp_zero_page_alloc
vmstat counter (now counted at most once, at boot) and the transhuge.rst
description of the zero page counters is updated accordingly.

Note that the small-memory (<512MiB) default-off path in hugepage_init()
retains TRANSPARENT_HUGEPAGE_UNSUPPORTED should the boot-time allocation
have failed.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
NOTE: This RFC is dependent on [0]
[0]:https://lore.kernel.org/linux-mm/20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org/

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: "Liam R. Howlett" <liam@infradead.org>
To: Nico Pache <nico.pache@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Heiko Carstens <hca@linux.ibm.com>
To: Vasily Gorbik <gor@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Sven Schnelle <svens@linux.ibm.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Dan Williams <djbw@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <kees@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Ben Segall <bsegall@google.com>
To: Mel Gorman <mgorman@suse.de>
To: Valentin Schneider <vschneid@redhat.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>
---
 Documentation/admin-guide/mm/transhuge.rst |   8 +-
 arch/s390/configs/debug_defconfig          |   1 -
 arch/s390/configs/defconfig                |   1 -
 fs/dax.c                                   |  14 ++-
 include/linux/huge_mm.h                    |  42 ++------
 include/linux/mm_types.h                   |   2 -
 kernel/fork.c                              |   1 -
 mm/Kconfig                                 |  16 ---
 mm/huge_memory.c                           | 163 ++---------------------------
 9 files changed, 32 insertions(+), 216 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 16f37135ed80..0d8010936c02 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -618,13 +618,13 @@ thp_split_pmd
 	page table entry.
 
 thp_zero_page_alloc
-	is incremented every time a huge zero page used for thp is
-	successfully allocated. Note, it doesn't count every map of
+	is incremented when the huge zero folio is successfully
+	allocated at boot. Note, it doesn't count every map of
 	the huge zero page, only its allocation.
 
 thp_zero_page_alloc_failed
-	is incremented if kernel fails to allocate
-	huge zero page and falls back to using small pages.
+	is incremented if the kernel fails to allocate the huge zero
+	folio at boot, in which case THP is disabled.
 
 thp_swpout
 	is incremented every time a huge page is swapout in one
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 54637be87fb7..cec61569da14 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -105,7 +105,6 @@ CONFIG_SLUB_STATS=y
 CONFIG_MEMORY_HOTPLUG=y
 CONFIG_MEMORY_HOTREMOVE=y
 CONFIG_KSM=y
-CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_CMA_DEBUGFS=y
 CONFIG_CMA_SYSFS=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 5f5114a253cf..0e40419f05c8 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -98,7 +98,6 @@ CONFIG_SLAB_BUCKETS=y
 CONFIG_MEMORY_HOTPLUG=y
 CONFIG_MEMORY_HOTREMOVE=y
 CONFIG_KSM=y
-CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_CMA_SYSFS=y
 CONFIG_CMA_AREAS=7
diff --git a/fs/dax.c b/fs/dax.c
index 4ea3384ecefd..c941fff3aeff 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1413,22 +1413,20 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
-	struct folio *zero_folio;
 	vm_fault_t ret;
 
-	zero_folio = mm_get_huge_zero_folio(vmf->vma->vm_mm);
-
-	if (unlikely(!zero_folio)) {
-		trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
+	if (unlikely(!huge_zero_folio)) {
+		trace_dax_pmd_load_hole_fallback(inode, vmf, huge_zero_folio, *entry);
 		return VM_FAULT_FALLBACK;
 	}
 
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, folio_pfn(zero_folio),
+	*entry = dax_insert_entry(xas, vmf, iter, *entry,
+				  folio_pfn(huge_zero_folio),
 				  DAX_PMD | DAX_ZERO_PAGE);
 
-	ret = vmf_insert_folio_pmd(vmf, zero_folio, false);
+	ret = vmf_insert_folio_pmd(vmf, huge_zero_folio, false);
 	if (ret == VM_FAULT_NOPAGE)
-		trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
+		trace_dax_pmd_load_hole(inode, vmf, huge_zero_folio, *entry);
 	return ret;
 }
 #else
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..e43dffac37f9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -572,20 +572,6 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 	return pmd_present(pmd) && is_huge_zero_pfn(pmd_pfn(pmd));
 }
 
-struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
-void mm_put_huge_zero_folio(struct mm_struct *mm);
-
-static inline struct folio *get_persistent_huge_zero_folio(void)
-{
-	if (!IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
-		return NULL;
-
-	if (unlikely(!huge_zero_folio))
-		return NULL;
-
-	return huge_zero_folio;
-}
-
 static inline bool thp_migration_supported(void)
 {
 	return IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES);
@@ -769,11 +755,6 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 	return false;
 }
 
-static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
-{
-	return;
-}
-
 static inline bool thp_migration_supported(void)
 {
 	return false;
@@ -828,26 +809,25 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
 	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /**
  * largest_zero_folio - Get the largest zero size folio available
  *
- * This function shall be used when mm_get_huge_zero_folio() cannot be
- * used as there is no appropriate mm lifetime to tie the huge zero folio
- * from the caller.
+ * If CONFIG_TRANSPARENT_HUGEPAGE is enabled, this is the huge zero folio,
+ * provided its boot-time allocation succeeded.
  *
- * Deduce the size of the folio with folio_size instead of assuming the
- * folio size.
+ * Otherwise, this is the single page zero folio.
  *
- * Return: pointer to PMD sized zero folio if CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
- * is enabled or a single page sized zero folio
+ * Return: pointer to the largest sized zero folio available.
  */
 static inline struct folio *largest_zero_folio(void)
 {
-	struct folio *folio = get_persistent_huge_zero_folio();
-
-	if (folio)
-		return folio;
-
+	return huge_zero_folio ?: page_folio(ZERO_PAGE(0));
+}
+#else
+static inline struct folio *largest_zero_folio(void)
+{
 	return page_folio(ZERO_PAGE(0));
 }
+#endif
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b5d4cd3b067b..36451119e857 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1965,8 +1965,6 @@ enum {
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when mm is available for khugepaged */
 
-#define MMF_HUGE_ZERO_FOLIO	18      /* mm has ever used the global huge zero folio */
-
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a9a5..e0bae09fb6c2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1185,7 +1185,6 @@ static inline void __mmput(struct mm_struct *mm)
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
-	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
 	if (!list_empty(&mm->mmlist)) {
 		spin_lock(&mmlist_lock);
diff --git a/mm/Kconfig b/mm/Kconfig
index c52ab6afcb15..5adf705a2ad3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -810,22 +810,6 @@ config ARCH_WANT_GENERAL_HUGETLB
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
-config PERSISTENT_HUGE_ZERO_FOLIO
-	bool "Allocate a PMD sized folio for zeroing"
-	depends on TRANSPARENT_HUGEPAGE
-	help
-	  Enable this option to reduce the runtime refcounting overhead
-	  of the huge zero folio and expand the places in the kernel
-	  that can use huge zero folios. For instance, block I/O benefits
-	  from access to large folios for zeroing memory.
-
-	  With this option enabled, the huge zero folio is allocated
-	  once and never freed. One full huge page's worth of memory shall
-	  be used.
-
-	  Say Y if your system has lots of memory. Say N if you are
-	  memory constrained.
-
 config MM_ID
 	def_bool n
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ac108955299c..aaa2aa6f9402 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -81,11 +81,6 @@ static bool split_underused_thp = true;
 #define HUGE_ZERO_UNSET_PFN (~0UL)
 struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = HUGE_ZERO_UNSET_PFN;
-#ifndef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
-static atomic_t huge_zero_refcount;
-static DEFINE_SPINLOCK(huge_zero_lock);
-static struct shrinker *huge_zero_folio_shrinker;
-#endif
 
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
@@ -243,141 +238,18 @@ static struct folio *alloc_huge_zero_folio(void)
 	return zero_folio;
 }
 
-#ifdef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
-static int __init huge_zero_init(void)
+static void __init huge_zero_init(void)
 {
 	huge_zero_folio = alloc_huge_zero_folio();
 	if (!huge_zero_folio) {
-		pr_warn("Allocating persistent huge zero folio failed\n");
-	} else {
-		huge_zero_pfn = folio_pfn(huge_zero_folio);
-		count_vm_event(THP_ZERO_PAGE_ALLOC);
-	}
-	return 0;
-}
-
-static void __init huge_zero_shrinker_exit(void)
-{
-}
-
-struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
-{
-	return huge_zero_folio;
-}
-
-void mm_put_huge_zero_folio(struct mm_struct *mm)
-{
-}
-#else
-static bool get_huge_zero_folio(void)
-{
-	struct folio *zero_folio;
-
-	/* Paired with atomic_set_release(). */
-	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return true;
-
-	zero_folio = alloc_huge_zero_folio();
-	if (unlikely(!zero_folio))
-		return false;
-
-	/* Paired with critical section in shrink_huge_zero_folio_scan(). */
-	spin_lock(&huge_zero_lock);
-	if (huge_zero_folio) {
-		/* Somebody else already installed it. */
-		atomic_inc(&huge_zero_refcount);
-		spin_unlock(&huge_zero_lock);
-		folio_put(zero_folio);
-		return true;
+		pr_warn("huge zero folio alloc failed, disabling THP\n");
+		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
+		return;
 	}
-	WRITE_ONCE(huge_zero_folio, zero_folio);
-	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
-	/* Paired with atomic_inc_not_zero(). +1 for shrinker pin. */
-	atomic_set_release(&huge_zero_refcount, 2);
-	spin_unlock(&huge_zero_lock);
-
+	huge_zero_pfn = folio_pfn(huge_zero_folio);
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
-	return true;
 }
 
-static void put_huge_zero_folio(void)
-{
-	/*
-	 * Counter should never go to zero here. Only shrinker can put
-	 * last reference.
-	 */
-	WARN_ON_ONCE(atomic_dec_and_test(&huge_zero_refcount));
-}
-
-static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
-						  struct shrink_control *sc)
-{
-	/* we can free zero page only if last reference remains */
-	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
-}
-
-static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
-						 struct shrink_control *sc)
-{
-	struct folio *zero_folio;
-
-	/* Paired with critical section in get_huge_zero_folio(). */
-	scoped_guard(spinlock, &huge_zero_lock) {
-		/* Paired with atomic_inc_not_zero() in get_huge_zero_folio(). */
-		if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) != 1)
-			return 0;
-
-		zero_folio = huge_zero_folio;
-		VM_WARN_ON_ONCE(!huge_zero_folio);
-		WRITE_ONCE(huge_zero_folio, NULL);
-		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
-	}
-
-	folio_put(zero_folio);
-	return HPAGE_PMD_NR;
-}
-
-static int __init huge_zero_init(void)
-{
-	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_folio_shrinker) {
-		shrinker_free(deferred_split_shrinker);
-		list_lru_destroy(&deferred_split_lru);
-		return -ENOMEM;
-	}
-
-	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
-	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
-	shrinker_register(huge_zero_folio_shrinker);
-	return 0;
-}
-
-static void __init huge_zero_shrinker_exit(void)
-{
-	shrinker_free(huge_zero_folio_shrinker);
-}
-
-struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
-{
-	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
-		return READ_ONCE(huge_zero_folio);
-
-	if (!get_huge_zero_folio())
-		return NULL;
-
-	if (mm_flags_test_and_set(MMF_HUGE_ZERO_FOLIO, mm))
-		put_huge_zero_folio();
-
-	return READ_ONCE(huge_zero_folio);
-}
-
-void mm_put_huge_zero_folio(struct mm_struct *mm)
-{
-	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
-		put_huge_zero_folio();
-}
-#endif /* CONFIG_PERSISTENT_HUGE_ZERO_FOLIO */
-
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
 			    struct kobj_attribute *attr, char *buf)
@@ -1038,14 +910,14 @@ static int __init thp_shrinker_init(void)
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
 	shrinker_register(deferred_split_shrinker);
 
-	return huge_zero_init();
+	huge_zero_init();
+	return 0;
 }
 
 static void __init thp_shrinker_exit(void)
 {
 	shrinker_free(deferred_split_shrinker);
 	list_lru_destroy(&deferred_split_lru);
-	huge_zero_shrinker_exit();
 }
 
 static int __init hugepage_init(void)
@@ -1081,7 +953,8 @@ static int __init hugepage_init(void)
 	 * is likely to save.  The admin can still enable it through /sys.
 	 */
 	if (totalram_pages() < MB_TO_PAGES(512)) {
-		transparent_hugepage_flags = 0;
+		/* Retain boot-time THP disablement on huge zero folio failure. */
+		transparent_hugepage_flags &= 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return 0;
 	}
 
@@ -1534,18 +1407,11 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			!mm_forbids_zeropage(vma->vm_mm) &&
 			transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
-		struct folio *zero_folio;
 		vm_fault_t ret;
 
 		pgtable = pte_alloc_one(vma->vm_mm);
 		if (unlikely(!pgtable))
 			return VM_FAULT_OOM;
-		zero_folio = mm_get_huge_zero_folio(vma->vm_mm);
-		if (unlikely(!zero_folio)) {
-			pte_free(vma->vm_mm, pgtable);
-			count_vm_event(THP_FAULT_FALLBACK);
-			return VM_FAULT_FALLBACK;
-		}
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		ret = 0;
 		if (pmd_none(*vmf->pmd)) {
@@ -1560,7 +1426,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
 				set_huge_zero_folio(pgtable, vma->vm_mm, vma,
-						   haddr, vmf->pmd, zero_folio);
+						   haddr, vmf->pmd, huge_zero_folio);
 				update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 				spin_unlock(vmf->ptl);
 			}
@@ -1967,15 +1833,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * under splitting since we don't split the page itself, only pmd to
 	 * a page table.
 	 */
-	if (is_huge_zero_pmd(pmd)) {
-		/*
-		 * mm_get_huge_zero_folio() will never allocate a new
-		 * folio here, since we already have a zero page to
-		 * copy. It just takes a reference.
-		 */
-		mm_get_huge_zero_folio(dst_mm);
+	if (is_huge_zero_pmd(pmd))
 		goto out_zero_page;
-	}
 
 	src_page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);

---
base-commit: 953c2e668733a3b3c49609ef38eca502a6b5cbfc
change-id: 20260728-persist-huge-zero-folio-b31c00123962

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

