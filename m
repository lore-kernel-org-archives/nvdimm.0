Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 3/5] dax: improve documentation for fsync/msync
Date: Thu, 21 Jan 2016 10:46:02 -0700
Message-Id: <1453398364-22537-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Several of the subtleties and assumptions of the DAX fsync/msync
implementation are not immediately obvious, so document them with comments.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index d589113..55ae394 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -350,6 +350,13 @@ static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
 
 		if (!pmd_entry || type == RADIX_DAX_PMD)
 			goto dirty;
+
+		/*
+		 * We only insert dirty PMD entries into the radix tree.  This
+		 * means we don't need to worry about removing a dirty PTE
+		 * entry and inserting a clean PMD entry, thus reducing the
+		 * range we would flush with a follow-up fsync/msync call.
+		 */
 		radix_tree_delete(&mapping->page_tree, index);
 		mapping->nrexceptional--;
 	}
@@ -912,6 +919,21 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		}
 		dax_unmap_atomic(bdev, &dax);
 
+		/*
+		 * For PTE faults we insert a radix tree entry for reads, and
+		 * leave it clean.  Then on the first write we dirty the radix
+		 * tree entry via the dax_pnf_mkwrite() path.  This sequence
+		 * allows the dax_pfn_mkwrite() call to be simpler and avoid a
+		 * call into get_block() to translate the pgoff to a sector in
+		 * order to be able to create a new radix tree entry.
+		 *
+		 * The PMD path doesn't have an equivalent to
+		 * dax_pfn_mkwrite(), though, so for a read followed by a
+		 * write we traverse all the way through __dax_pmd_fault()
+		 * twice.  This means we can just skip inserting a radix tree
+		 * entry completely on the initial read and just wait until
+		 * the write to insert a dirty entry.
+		 */
 		if (write) {
 			error = dax_radix_entry(mapping, pgoff, dax.sector,
 					true, true);
@@ -985,6 +1007,14 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 
+	/*
+	 * We pass NO_SECTOR to dax_radix_entry() because we expect that a
+	 * RADIX_DAX_PTE entry already exists in the radix tree from a
+	 * previous call to __dax_fault().  We just want to look up that PTE
+	 * entry using vmf->pgoff and make sure the dirty tag is set.  This
+	 * saves us from having to make a call to get_block() here to look
+	 * up the sector.
+	 */
 	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
 	return VM_FAULT_NOPAGE;
 }
-- 
2.5.0
