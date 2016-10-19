Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77AE71A1E6E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 12:34:50 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v8 13/16] dax: move put_(un)locked_mapping_entry() in dax.c
Date: Wed, 19 Oct 2016 13:34:32 -0600
Message-Id: <1476905675-32581-14-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1476905675-32581-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1476905675-32581-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

No functional change.

The static functions put_locked_mapping_entry() and
put_unlocked_mapping_entry() will soon be used in error cases in
grab_mapping_entry(), so move their definitions above this function.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c45cc4d..0582c7c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -382,6 +382,31 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 	}
 }
 
+static void put_locked_mapping_entry(struct address_space *mapping,
+				     pgoff_t index, void *entry)
+{
+	if (!radix_tree_exceptional_entry(entry)) {
+		unlock_page(entry);
+		put_page(entry);
+	} else {
+		dax_unlock_mapping_entry(mapping, index);
+	}
+}
+
+/*
+ * Called when we are done with radix tree entry we looked up via
+ * get_unlocked_mapping_entry() and which we didn't lock in the end.
+ */
+static void put_unlocked_mapping_entry(struct address_space *mapping,
+				       pgoff_t index, void *entry)
+{
+	if (!radix_tree_exceptional_entry(entry))
+		return;
+
+	/* We have to wake up next waiter for the radix tree entry lock */
+	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+}
+
 /*
  * Find radix tree entry at given index. If it points to a page, return with
  * the page locked. If it points to the exceptional entry, return with the
@@ -486,31 +511,6 @@ void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
-static void put_locked_mapping_entry(struct address_space *mapping,
-				     pgoff_t index, void *entry)
-{
-	if (!radix_tree_exceptional_entry(entry)) {
-		unlock_page(entry);
-		put_page(entry);
-	} else {
-		dax_unlock_mapping_entry(mapping, index);
-	}
-}
-
-/*
- * Called when we are done with radix tree entry we looked up via
- * get_unlocked_mapping_entry() and which we didn't lock in the end.
- */
-static void put_unlocked_mapping_entry(struct address_space *mapping,
-				       pgoff_t index, void *entry)
-{
-	if (!radix_tree_exceptional_entry(entry))
-		return;
-
-	/* We have to wake up next waiter for the radix tree entry lock */
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
-}
-
 /*
  * Delete exceptional DAX entry at @index from @mapping. Wait for radix tree
  * entry to get unlocked before deleting it.
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
