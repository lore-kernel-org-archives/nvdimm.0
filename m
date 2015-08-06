Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/6] x86: add clwb_cache_range()
Date: Thu,  6 Aug 2015 11:43:17 -0600
Message-Id: <1438883000-9011-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>, Toshi Kani <toshi.kani@hp.com>, "Luis R. Rodriguez" <mcgrof@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Add support for writing back a cache range using CLWB instead of just
flushing it using CLFLUSH or CLFLUSHOPT.  This allows you to ensure that
your data has become durable on your DIMM, but potentially leaves a
clean version in the processor cache hierarchy for future loads.

This will be used in DAX to write back stores to persistent memory.

Details on CLWB can be found here:

https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/x86/include/asm/cacheflush.h |  1 +
 arch/x86/mm/pageattr.c            | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index ae00766..490b3d6 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -88,6 +88,7 @@ int set_pages_rw(struct page *page, int numpages);
 
 
 void clflush_cache_range(void *addr, unsigned int size);
+void clwb_cache_range(void *addr, size_t size);
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 727158c..ce84d05 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -144,6 +144,29 @@ void clflush_cache_range(void *vaddr, unsigned int size)
 }
 EXPORT_SYMBOL_GPL(clflush_cache_range);
 
+/**
+ * clwb_cache_range - write back a cache range with clwb
+ * @vaddr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * clwb is an unordered instruction which needs fencing with mfence or sfence
+ * to avoid ordering issues.
+ */
+void clwb_cache_range(void *vaddr, size_t size)
+{
+	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
+	unsigned long clflush_mask = x86_clflush_size - 1;
+	char *vend = (char *)vaddr + size;
+	char *p;
+
+	for (p = (char *)((unsigned long)vaddr & ~clflush_mask);
+	     p < vend; p += x86_clflush_size)
+		clwb(p);
+
+	wmb();
+}
+EXPORT_SYMBOL_GPL(clwb_cache_range);
+
 static void __cpa_flush_all(void *arg)
 {
 	unsigned long cache = (unsigned long)arg;
-- 
2.1.0

