Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FB971A1E40
 for <linux-nvdimm@lists.01.org>; Wed, 24 Aug 2016 15:15:21 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2] mm: silently skip readahead for DAX inodes
Date: Wed, 24 Aug 2016 16:14:29 -0600
Message-Id: <20160824221429.21158-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20160824134212.e9b50aa36523fbfcbcfe2f55@linux-foundation.org>
References: <20160824134212.e9b50aa36523fbfcbcfe2f55@linux-foundation.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

For DAX inodes we need to be careful to never have page cache pages in the
mapping->page_tree.  This radix tree should be composed only of DAX
exceptional entries and zero pages.

ltp's readahead02 test was triggering a warning because we were trying to
insert a DAX exceptional entry but found that a page cache page had
already been inserted into the tree.  This page was being inserted into the
radix tree in response to a readahead(2) call.

Readahead doesn't make sense for DAX inodes, but we don't want it to report
a failure either.  Instead, we just return success and don't do any work.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
---

Changes from v1:
 - Added a comment so readers don't have to go putzing around in the git
   tree to understand why we're doing what we're doing. :)  (akpm)

---
 mm/readahead.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/readahead.c b/mm/readahead.c
index 65ec288..c8a955b 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/dax.h>
 #include <linux/gfp.h>
 #include <linux/export.h>
 #include <linux/blkdev.h>
@@ -544,6 +545,14 @@ do_readahead(struct address_space *mapping, struct file *filp,
 	if (!mapping || !mapping->a_ops)
 		return -EINVAL;
 
+	/*
+	 * Readahead doesn't make sense for DAX inodes, but we don't want it
+	 * to report a failure either.  Instead, we just return success and
+	 * don't do any work.
+	 */
+	if (dax_mapping(mapping))
+		return 0;
+
 	return force_page_cache_readahead(mapping, filp, index, nr);
 }
 
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
