Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D3F021A13487
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 12:59:22 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 2/2] dax: fix data corruption due to stale mmap reads
Date: Thu,  4 May 2017 13:59:10 -0600
Message-Id: <20170504195910.11579-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20170504195910.11579-1-ross.zwisler@linux.intel.com>
References: <20170504195910.11579-1-ross.zwisler@linux.intel.com>
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
Cc: Latchesar Ionkov <lucho@ionkov.net>, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, linux-cifs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Eric Van Hensbergen <ericvh@gmail.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, v9fs-developer@lists.sourceforge.net, Jens Axboe <axboe@kernel.dk>, linux-nfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, samba-technical@lists.samba.org, Steve French <sfrench@samba.org>, Alexey Kuznetsov <kuznet@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, Ron Minnich <rminnich@sandia.gov>, Anna Schumaker <anna.schumaker@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

Users of DAX can suffer data corruption from stale mmap reads via the
following sequence:

- open an mmap over a 2MiB hole

- read from a 2MiB hole, faulting in a 2MiB zero page

- write to the hole with write(3p).  The write succeeds but we incorrectly
  leave the 2MiB zero page mapping intact.

- via the mmap, read the data that was just written.  Since the zero page
  mapping is still intact we read back zeroes instead of the new data.

We fix this by unconditionally calling invalidate_inode_pages2_range() in
dax_iomap_actor() for new block allocations, and by enhancing
invalidate_inode_pages2_range() so that it properly unmaps the DAX entries
being removed from the radix tree.

This is based on an initial patch from Jan Kara.

I've written an fstest that triggers this error:
http://www.spinics.net/lists/linux-mm/msg126276.html

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
Reported-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>    [4.10+]
---

Changes since v1:
 - Instead of unmapping each DAX entry individually in
   __dax_invalidate_mapping_entry(), instead unmap the whole range at once
   inside of invalidate_inode_pages2_range().  Each unmap requires an rmap
   walk so this should be less expensive, plus now we don't have to drop
   and re-acquire the mapping->tree_lock for each entry. (Jan)

These patches apply cleanly to v4.11 and have passed an xfstest run.
They also apply to v4.10.13 with a little help from git am's 3-way merger.

---
 fs/dax.c      |  8 ++++----
 mm/truncate.c | 10 ++++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 166504c..1f2c880 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -999,11 +999,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		return -EIO;
 
 	/*
-	 * Write can allocate block for an area which has a hole page mapped
-	 * into page tables. We have to tear down these mappings so that data
-	 * written by write(2) is visible in mmap.
+	 * Write can allocate block for an area which has a hole page or zero
+	 * PMD entry in the radix tree.  We have to tear down these mappings so
+	 * that data written by write(2) is visible in mmap.
 	 */
-	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
+	if (iomap->flags & IOMAP_F_NEW) {
 		invalidate_inode_pages2_range(inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
diff --git a/mm/truncate.c b/mm/truncate.c
index c537184..ad40316 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -683,6 +683,16 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		cond_resched();
 		index++;
 	}
+
+	/*
+	 * Ensure that any DAX exceptional entries that have been invalidated
+	 * are also unmapped.
+	 */
+	if (dax_mapping(mapping)) {
+		unmap_mapping_range(mapping, (loff_t)start << PAGE_SHIFT,
+				(loff_t)(1 + end - start) << PAGE_SHIFT, 0);
+	}
+
 	cleancache_invalidate_inode(mapping);
 	return ret;
 }
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
