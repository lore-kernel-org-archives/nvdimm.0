Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: fix deadlock in __dax_fault
Date: Wed, 23 Sep 2015 14:40:00 -0600
Message-Id: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fix the deadlock exposed by xfstests generic/075.  Here is the sequence
that was causing us to deadlock:

1) enter __dax_fault()
2) page = find_get_page() gives us a page, so skip
	i_mmap_lock_write(mapping)
3) if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page)
	passes, enter this block
4) if (vmf->flags & FAULT_FLAG_WRITE) fails, so do the else case and
	i_mmap_unlock_write(mapping);
	return dax_load_hole(mapping, page, vmf);

This causes us to up_write() a semaphore that we weren't holding.

The up_write() on a semaphore we didn't down_write() happens twice in
a row, and then the next time we try and i_mmap_lock_write(), we hang.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7ae6df7..df1b0ac 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -405,7 +405,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			if (error)
 				goto unlock;
 		} else {
-			i_mmap_unlock_write(mapping);
+			if (!page)
+				i_mmap_unlock_write(mapping);
 			return dax_load_hole(mapping, page, vmf);
 		}
 	}
-- 
2.1.0

