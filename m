Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 3/3] dax: temporarily disable DAX PMD fault path
Date: Mon,  5 Oct 2015 14:32:54 -0600
Message-Id: <1444077174-22016-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1444077174-22016-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1444077174-22016-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

There is currently a deadlock in the DAX PMD fault path because it ends up
taking the same mapping->i_mmap_rwsem twice.  The first take is a
i_mmap_lock_read() near the beginning of __dax_pmd_fault(), and the second
is __dax_pmd_fault() -> unmap_mapping_range() -> i_mmap_lock_write().

We are re-working the way that DAX does its locking for v4.4, so for now
just disable DAX PMD faults and fall back to PAGE_SIZE faults to make sure
we don't hit this deadlock.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index f364c90..d42217d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -534,6 +534,13 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	unsigned long pfn;
 	int result = 0;
 
+	/*
+	 * There is currently a deadlock in the DAX PMD fault path.  Disable
+	 * this path and fall back to the normal dax_fault() path for now
+	 * while we rework locking.
+	 */
+	return VM_FAULT_FALLBACK;
+
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED))
 		return VM_FAULT_FALLBACK;
-- 
2.1.0

