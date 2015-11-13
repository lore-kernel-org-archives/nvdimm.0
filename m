Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH] dax: fix __dax_pmd_fault crash
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Nov 2015 18:57:45 -0800
Message-ID: <20151113025706.13868.1679.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Since 4.3 introduced devm_memremap_pages() the pfns handled by DAX may
optionally have a struct page backing.  When a mapped pfn reaches
vmf_insert_pfn_pmd() it fails with a crash signature like the following:

 kernel BUG at mm/huge_memory.c:905!
 [..]
 Call Trace:
  [<ffffffff812a73ba>] __dax_pmd_fault+0x2ea/0x5b0
  [<ffffffffa01a4182>] xfs_filemap_pmd_fault+0x92/0x150 [xfs]
  [<ffffffff811fbe02>] handle_mm_fault+0x312/0x1b50

Fix this by falling back to 4K mappings in the pfn_valid() case.  Longer
term, vmf_insert_pfn_pmd() needs to grow support for architectures that
can provide a 'pmd_special' capability.

Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 131fd35ae39d..bff20cc56130 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -627,6 +627,13 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
 			goto fallback;
 
+		/*
+		 * TODO: teach vmf_insert_pfn_pmd() to support
+		 * 'pte_special' for pmds
+		 */
+		if (pfn_valid(pfn))
+			goto fallback;
+
 		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
 			int i;
 			for (i = 0; i < PTRS_PER_PMD; i++)

