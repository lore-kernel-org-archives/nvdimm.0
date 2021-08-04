Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DDE349D
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:43 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433073"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433073"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:38 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702708"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:38 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 13/18] memremap_pages: Add access protection via supervisor Protection Keys (PKS)
Date: Tue,  3 Aug 2021 21:32:26 -0700
Message-Id: <20210804043231.2655537-14-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20210804043231.2655537-1-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

The persistent memory (PMEM) driver uses the memremap_pages facility to
provide 'struct page' metadata (vmemmap) for PMEM.  Given that PMEM
capacity maybe orders of magnitude higher capacity than System RAM it
presents a large vulnerability surface to stray writes.  Unlike stray
writes to System RAM, which may result in a crash or other undesirable
behavior, stray writes to PMEM additionally are more likely to result in
permanent data loss. Reboot is not a remediation for PMEM corruption
like it is for System RAM.

Given that PMEM access from the kernel is limited to a constrained set
of locations (PMEM driver, Filesystem-DAX, and direct-I/O to a DAX
page), it is amenable to supervisor pkey protection.  Set up an
infrastructure for thread local access protection. Then implement the
protection using the new Protection Keys Supervisor (PKS) on
architectures that support it.

To enable this extra protection memremap_pages users should check for
protection support via pgmap_protection_enabled() and if enabled specify
(PGMAP_PROTECTION) in (struct dev_pagemap)->flags to request that
access protection.

NOTE: The name of pgmap_protection_enable() and PGMAP_PROTECTION were
specifically chosen to isolate the implementation of the protection from
higher level users.

Kernel code intending to access this memory can do so through 4 new
calls.  pgmap_mk_{readwrite,noaccess}() and
__pgmap_mk_{readwrite,noaccess}() calls.

The pgmap_mk_*() take a page parameter and the __pgmap_mk_*() calls
directly take the dev_pagemap objects.  pgmap_mk_*() take care of
checking if the page is a page map managed page and are safe to any user
who has a reference on the page.

All changes in the protections must be through the above calls.  They
abstract the protection implementation (currently the PKS api) from the
upper layer users.

Furthermore, the calls are nestable by the use of a per task reference
count.  This ensures that the first call to re-enable protection does
not 'break' the last access of the device memory.

NOTE: There are no code paths which directly nest these calls.  For this
reason multiple reviewers, including Dan and Thomas, asked why this
reference counting was needed at this level rather than in a higher
level call such as kmap_{atomic,local_page}().  The reason is that
pmgmap_mk_read_write() can nest with kmap_{atomic,local_page}().
Therefore push this reference counting to the lower level.

Access to device memory during exceptions (#PF) is expected only from
user faults.  Therefore there is no need to maintain the reference count
when entering or exiting exceptions.  However, reference counting will
occur during the exception.  Recall that protection is automatically
enabled during exceptions by the PKS core.[1]

A default of (NVDIMM_PFN && ARCH_HAS_SUPERVISOR_PKEYS) was suggested but
logically that is the same as saying default 'yes' because both
NVDIMM_PFN and ARCH_HAS_SUPERVISOR_PKEYS are required.  Therefore a
default of 'yes' was used.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

[1] https://lore.kernel.org/lkml/20210401225833.566238-9-ira.weiny@intel.com/

---
Changes for V7
	Add __pgmap_mk_*() calls to allow users who have a dev_pagemap
		to call directly into that layer of the API
	Add pgmap_protection_enabled() and fail memremap_pages() if
		protection is requested and pgmap_protection_enabled()
		is false
	s/PGMAP_PKEY_PROTECT/PGMAP_PROTECTION
		This helps to isolate the implementation details of the
		protection from the higher layers.
	s/dev_page_access_ref/pgmap_prot_count
	s/DEV_PAGEMAP_PROTECTION/DEVMAP_ACCESS_PROTECTION
	Adjust Kconfig dependency and default
	Address feedback from Dan Williams
		Add requirement comment to devmap_protected
		Make pgmap_mk_* static inline
		Change to devmap_protected
		Change config to DEV_PAGEMAP_PROTECTION
	Remove dynamic key use from memremap
		This greatly simplifies turning on PKS when requested by
		the remapping code
		#define a static key for pmem use
---
 arch/x86/mm/pkeys.c      |  3 +-
 include/linux/memremap.h |  1 +
 include/linux/mm.h       | 62 ++++++++++++++++++++++++++++++++++
 include/linux/pkeys.h    |  1 +
 include/linux/sched.h    |  7 ++++
 init/init_task.c         |  3 ++
 kernel/fork.c            |  3 ++
 mm/Kconfig               | 18 ++++++++++
 mm/memremap.c            | 73 ++++++++++++++++++++++++++++++++++++++++
 9 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index f0166725a128..cdebc2018888 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -294,7 +294,8 @@ static int __init create_initial_pkrs_value(void)
 	};
 	int i;
 
-	consumer_defaults[PKS_KEY_DEFAULT] = PKR_RW_BIT;
+	consumer_defaults[PKS_KEY_DEFAULT]          = PKR_RW_BIT;
+	consumer_defaults[PKS_KEY_PGMAP_PROTECTION] = PKR_AD_BIT;
 
 	/* Ensure the number of consumers is less than the number of keys */
 	BUILD_BUG_ON(PKS_KEY_NR_CONSUMERS > PKS_NUM_PKEYS);
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index c0e9d35889e8..53dc97823418 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -90,6 +90,7 @@ struct dev_pagemap_ops {
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
+#define PGMAP_PROTECTION	(1 << 1)
 
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7ca22e6e694a..d3c1a3ecca87 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1198,6 +1198,68 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
 }
 
+#ifdef CONFIG_DEVMAP_ACCESS_PROTECTION
+DECLARE_STATIC_KEY_FALSE(dev_pgmap_protection_static_key);
+
+/*
+ * devmap_protected() requires a reference on the page to ensure there is no
+ * races with dev_pagemap tear down.
+ */
+static inline bool devmap_protected(struct page *page)
+{
+	if (!static_branch_unlikely(&dev_pgmap_protection_static_key))
+		return false;
+	if (!is_zone_device_page(page))
+		return false;
+	if (page->pgmap->flags & PGMAP_PROTECTION)
+		return true;
+	return false;
+}
+
+void __pgmap_mk_readwrite(struct dev_pagemap *pgmap);
+void __pgmap_mk_noaccess(struct dev_pagemap *pgmap);
+
+static inline bool pgmap_check_pgmap_prot(struct page *page)
+{
+	if (!devmap_protected(page))
+		return false;
+
+	/*
+	 * There is no known use case to change permissions in an irq for pgmap
+	 * pages
+	 */
+	lockdep_assert_in_irq();
+	return true;
+}
+
+static inline void pgmap_mk_readwrite(struct page *page)
+{
+	if (!pgmap_check_pgmap_prot(page))
+		return;
+	__pgmap_mk_readwrite(page->pgmap);
+}
+static inline void pgmap_mk_noaccess(struct page *page)
+{
+	if (!pgmap_check_pgmap_prot(page))
+		return;
+	__pgmap_mk_noaccess(page->pgmap);
+}
+
+bool pgmap_protection_enabled(void);
+
+#else
+
+static inline void __pgmap_mk_readwrite(struct dev_pagemap *pgmap) { }
+static inline void __pgmap_mk_noaccess(struct dev_pagemap *pgmap) { }
+static inline void pgmap_mk_readwrite(struct page *page) { }
+static inline void pgmap_mk_noaccess(struct page *page) { }
+static inline bool pgmap_protection_enabled(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_DEVMAP_ACCESS_PROTECTION */
+
 /* 127: arbitrary random number, small enough to assemble well */
 #define page_ref_zero_or_close_to_overflow(page) \
 	((unsigned int) page_ref_count(page) + 127u <= 127u)
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index 549fa01d7da3..c06b47264c5d 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -49,6 +49,7 @@ static inline bool arch_pkeys_enabled(void)
 #ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
 enum pks_pkey_consumers {
 	PKS_KEY_DEFAULT = 0, /* Must be 0 for default PTE values */
+	PKS_KEY_PGMAP_PROTECTION,
 	PKS_KEY_NR_CONSUMERS
 };
 extern u32 pkrs_init_value;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec8d07d88641..2d035d9981b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1400,6 +1400,13 @@ struct task_struct {
 	struct llist_head               kretprobe_instances;
 #endif
 
+#ifdef CONFIG_DEVMAP_ACCESS_PROTECTION
+	/*
+	 * NOTE: pgmap_prot_count is modified within a single thread of
+	 * execution.  So it does not need to be atomic_t.
+	 */
+	u32                             pgmap_prot_count;
+#endif
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
diff --git a/init/init_task.c b/init/init_task.c
index 562f2ef8d157..f628ad552ee3 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -213,6 +213,9 @@ struct task_struct init_task
 #ifdef CONFIG_SECCOMP_FILTER
 	.seccomp	= { .filter_count = ATOMIC_INIT(0) },
 #endif
+#ifdef CONFIG_DEVMAP_ACCESS_PROTECTION
+	.pgmap_prot_count = 0,
+#endif
 };
 EXPORT_SYMBOL(init_task);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index bc94b2cc5995..7f7b946f4f2e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -956,6 +956,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 
 #ifdef CONFIG_MEMCG
 	tsk->active_memcg = NULL;
+#endif
+#ifdef CONFIG_DEVMAP_ACCESS_PROTECTION
+	tsk->pgmap_prot_count = 0;
 #endif
 	return tsk;
 
diff --git a/mm/Kconfig b/mm/Kconfig
index ea6ffee69f55..201d41269a36 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -790,6 +790,24 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
+config DEVMAP_ACCESS_PROTECTION
+	bool "Access protection for memremap_pages()"
+	depends on NVDIMM_PFN
+	depends on ARCH_HAS_SUPERVISOR_PKEYS
+	select GENERAL_PKS_USER
+	default y
+
+	help
+	  Enable extra protections on device memory.  This protects against
+	  unintended access to devices such as a stray writes.  This feature is
+	  particularly useful to protect against corruption of persistent
+	  memory.
+
+	  This depends on architecture support of supervisor PKeys and has no
+	  overhead if the architecture does not support them.
+
+	  If you have persistent memory say 'Y'.
+
 config DEV_PAGEMAP_OPS
 	bool
 
diff --git a/mm/memremap.c b/mm/memremap.c
index 15a074ffb8d7..a05de8714916 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -6,6 +6,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
 #include <linux/pfn_t.h>
+#include <linux/pkeys.h>
 #include <linux/swap.h>
 #include <linux/mmzone.h>
 #include <linux/swapops.h>
@@ -63,6 +64,68 @@ static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
 }
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
+#ifdef CONFIG_DEVMAP_ACCESS_PROTECTION
+/*
+ * Note; all devices which have asked for protections share the same key.  The
+ * key may, or may not, have been provided by the core.  If not, protection
+ * will be disabled.  The key acquisition is attempted when the first ZONE
+ * DEVICE requests it and freed when all zones have been unmapped.
+ *
+ * Also this must be EXPORT_SYMBOL rather than EXPORT_SYMBOL_GPL because it is
+ * intended to be used in the kmap API.
+ */
+DEFINE_STATIC_KEY_FALSE(dev_pgmap_protection_static_key);
+EXPORT_SYMBOL(dev_pgmap_protection_static_key);
+
+static void devmap_protection_enable(void)
+{
+	static_branch_inc(&dev_pgmap_protection_static_key);
+}
+
+static pgprot_t devmap_protection_adjust_pgprot(pgprot_t prot)
+{
+	pgprotval_t val;
+
+	val = pgprot_val(prot);
+	return __pgprot(val | _PAGE_PKEY(PKS_KEY_PGMAP_PROTECTION));
+}
+
+static void devmap_protection_disable(void)
+{
+	static_branch_dec(&dev_pgmap_protection_static_key);
+}
+
+void __pgmap_mk_readwrite(struct dev_pagemap *pgmap)
+{
+	if (!current->pgmap_prot_count++)
+		pks_mk_readwrite(PKS_KEY_PGMAP_PROTECTION);
+}
+EXPORT_SYMBOL_GPL(__pgmap_mk_readwrite);
+
+void __pgmap_mk_noaccess(struct dev_pagemap *pgmap)
+{
+	if (!--current->pgmap_prot_count)
+		pks_mk_noaccess(PKS_KEY_PGMAP_PROTECTION);
+}
+EXPORT_SYMBOL_GPL(__pgmap_mk_noaccess);
+
+bool pgmap_protection_enabled(void)
+{
+	return pks_enabled();
+}
+EXPORT_SYMBOL_GPL(pgmap_protection_enabled);
+
+#else /* !CONFIG_DEVMAP_ACCESS_PROTECTION */
+
+static void devmap_protection_enable(void) { }
+static void devmap_protection_disable(void) { }
+
+static pgprot_t devmap_protection_adjust_pgprot(pgprot_t prot)
+{
+	return prot;
+}
+#endif /* CONFIG_DEVMAP_ACCESS_PROTECTION */
+
 static void pgmap_array_delete(struct range *range)
 {
 	xa_store_range(&pgmap_array, PHYS_PFN(range->start), PHYS_PFN(range->end),
@@ -181,6 +244,9 @@ void memunmap_pages(struct dev_pagemap *pgmap)
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
 	devmap_managed_enable_put(pgmap);
+
+	if (pgmap->flags & PGMAP_PROTECTION)
+		devmap_protection_disable();
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
 
@@ -329,6 +395,13 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
 		return ERR_PTR(-EINVAL);
 
+	if (pgmap->flags & PGMAP_PROTECTION) {
+		if (!pgmap_protection_enabled())
+			return ERR_PTR(-EINVAL);
+		devmap_protection_enable();
+		params.pgprot = devmap_protection_adjust_pgprot(params.pgprot);
+	}
+
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 		if (!IS_ENABLED(CONFIG_DEVICE_PRIVATE)) {
-- 
2.28.0.rc0.12.gb6a658bd00c9

