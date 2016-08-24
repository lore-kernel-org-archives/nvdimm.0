Return-Path: <owner-linux-mm@kvack.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] mm: silently skip readahead for DAX inodes
Date: Wed, 24 Aug 2016 14:37:12 -0600
Message-Id: <20160824203712.4580-1-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For DAX inodes we need to be careful to never have page cache pages in the
mapping->page_tree.  This radix tree should be composed only of DAX
exceptional entries and zero pages.

ltp's readahead02 test was triggering a warning because we were trying to
insert a DAX exceptional entry but found that a page cache page had already
been inserted into the tree.  This page was being inserted into the radix
tree in response to a readahead(2) call.

Readahead doesn't make sense for DAX inodes, but we don't want it to report
a failure either.  Instead, we just return success and don't do any work.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: stable@vger.kernel.org
---
 mm/readahead.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/readahead.c b/mm/readahead.c
index 65ec288..a9ba1be 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/dax.h>
 #include <linux/gfp.h>
 #include <linux/export.h>
 #include <linux/blkdev.h>
@@ -544,6 +545,9 @@ do_readahead(struct address_space *mapping, struct file *filp,
 	if (!mapping || !mapping->a_ops)
 		return -EINVAL;
 
+	if (dax_mapping(mapping))
+		return 0;
+
 	return force_page_cache_readahead(mapping, filp, index, nr);
 }
 
-- 
2.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
