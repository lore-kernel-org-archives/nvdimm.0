Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C127021CB74C1
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 15:01:16 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 4/5] dax: remove DAX code from page_cache_tree_insert()
Date: Wed, 28 Jun 2017 16:01:51 -0600
Message-Id: <20170628220152.28161-5-ross.zwisler@linux.intel.com>
In-Reply-To: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
References: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jonathan Corbet <corbet@lwn.net>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Now that we no longer insert struct page pointers in DAX radix trees we can
remove the special casing for DAX in page_cache_tree_insert().  This also
allows us to make dax_wake_mapping_entry_waiter() local to fs/dax.c,
removing it from dax.h.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            |  2 +-
 include/linux/dax.h |  2 --
 mm/filemap.c        | 13 ++-----------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 01e81d228..896e2e7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -128,7 +128,7 @@ static int wake_exceptional_entry_func(wait_queue_t *wait, unsigned int mode,
  * correct waitqueue where tasks might be waiting for that old 'entry' and
  * wake them.
  */
-void dax_wake_mapping_entry_waiter(struct address_space *mapping,
+static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 		pgoff_t index, void *entry, bool wake_all)
 {
 	struct exceptional_entry_key key;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 8352ce1a..d6fd797 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -110,8 +110,6 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
-void dax_wake_mapping_entry_waiter(struct address_space *mapping,
-		pgoff_t index, void *entry, bool wake_all);
 
 #ifdef CONFIG_FS_DAX
 int __dax_zero_page_range(struct block_device *bdev,
diff --git a/mm/filemap.c b/mm/filemap.c
index 6f1be57..15f3df4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -130,17 +130,8 @@ static int page_cache_tree_insert(struct address_space *mapping,
 			return -EEXIST;
 
 		mapping->nrexceptional--;
-		if (!dax_mapping(mapping)) {
-			if (shadowp)
-				*shadowp = p;
-		} else {
-			/* DAX can replace empty locked entry with a hole */
-			WARN_ON_ONCE(p !=
-				dax_radix_locked_entry(0, RADIX_DAX_EMPTY));
-			/* Wakeup waiters for exceptional entry lock */
-			dax_wake_mapping_entry_waiter(mapping, page->index, p,
-						      true);
-		}
+		if (shadowp)
+			*shadowp = p;
 	}
 	__radix_tree_replace(&mapping->page_tree, node, slot, page,
 			     workingset_update_node, mapping);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
