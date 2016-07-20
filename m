Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 27B621A1E25
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 23:56:34 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] radix-tree: fix comment about "exceptional" bits
Date: Wed, 20 Jul 2016 00:55:31 -0600
Message-Id: <1468997731-2155-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Konstantin Khlebnikov <koct9i@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

The bottom two bits of radix tree entries are reserved for special use by
the radix tree code itself.  A comment detailing their usage was added by:

commit 3bcadd6fa6c4 ("radix-tree: free up the bottom bit of exceptional
entries for reuse")

This comment states that if the bottom two bits are '11', this means that
this is a locked exceptional entry.

It turns out that this bit combination was never actually used.  Radix tree
locking for DAX was indeed implemented, but it actually used the third LSB:

  /* We use lowest available exceptional entry bit for locking */
  #define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)

This locking code was also made specific to the DAX code instead of being
generally implemented in radix-tree.h.

So, fix the comment.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/radix-tree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index cb4b7e8..f0fb327 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -35,7 +35,7 @@
  * 00 - data pointer
  * 01 - internal entry
  * 10 - exceptional entry
- * 11 - locked exceptional entry
+ * 11 - this bit combination is currently unused/reserved
  *
  * The internal entry may be a pointer to the next level in the tree, a
  * sibling entry, or an indicator that the entry in this slot has been moved
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
