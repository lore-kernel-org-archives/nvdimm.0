Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E4C321BADAB2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 16:26:14 -0800 (PST)
Subject: [PATCH] dax: Fix Xarray conversion of dax_unlock_mapping_entry()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Nov 2018 16:13:46 -0800
Message-ID: <154353682674.1676897.15440708268545845062.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

Internal to dax_unlock_mapping_entry(), dax_unlock_entry() is used to
store a replacement entry in the Xarray at the given xas-index with the
DAX_LOCKED bit clear. When called, dax_unlock_entry() expects the unlocked
value of the entry relative to the current Xarray state to be specified.

In most contexts dax_unlock_entry() is operating in the same scope as
the matched dax_lock_entry(). However, in the dax_unlock_mapping_entry()
case the implementation needs to recall the original entry. In the case
where the original entry is a 'pmd' entry it is possible that the pfn
performed to do the lookup is misaligned to the value retrieved in the
Xarray.

When creating the 'unlocked' entry be sure to align it to the expected
size as reflected by the DAX_PMD flag. Otherwise, future lookups become
confused by finding a 'pte' aligned value at an index that should return
a 'pmd' aligned value. This mismatch results in failure signatures like
the following:

 WARNING: CPU: 38 PID: 1396 at fs/dax.c:340 dax_insert_entry+0x2b2/0x2d0
 RIP: 0010:dax_insert_entry+0x2b2/0x2d0
 [..]
 Call Trace:
  dax_iomap_pte_fault.isra.41+0x791/0xde0
  ext4_dax_huge_fault+0x16f/0x1f0
  ? up_read+0x1c/0xa0
  __do_fault+0x1f/0x160
  __handle_mm_fault+0x1033/0x1490
  handle_mm_fault+0x18b/0x3d0

...and potential corruption of nearby page state as housekeeping
routines, like dax_disassociate_entry(), may overshoot their expected
bounds starting at the wrong page.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Fixes: 9f32d221301c ("dax: Convert dax_lock_mapping_entry to XArray")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 3f592dc18d67..6c5f8f345b1a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -59,6 +59,7 @@ static inline unsigned int pe_order(enum page_entry_size pe_size)
 
 /* The order of a PMD entry */
 #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
+#define PMD_ORDER_MASK	~((1UL << PMD_ORDER) - 1)
 
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
@@ -93,9 +94,13 @@ static unsigned long dax_to_pfn(void *entry)
 	return xa_to_value(entry) >> DAX_SHIFT;
 }
 
-static void *dax_make_entry(pfn_t pfn, unsigned long flags)
+static void *dax_make_entry(pfn_t pfn_t, unsigned long flags)
 {
-	return xa_mk_value(flags | (pfn_t_to_pfn(pfn) << DAX_SHIFT));
+	unsigned long pfn = pfn_t_to_pfn(pfn_t);
+
+	if (flags & DAX_PMD)
+		pfn &= PMD_ORDER_MASK;
+	return xa_mk_value(flags | (pfn << DAX_SHIFT));
 }
 
 static bool dax_is_locked(void *entry)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
