Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C026121959D3F
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 00:25:10 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] dax: Fix data corruption when fault races with write
Date: Fri,  5 May 2017 09:25:00 +0200
Message-Id: <20170505072500.25692-5-jack@suse.cz>
In-Reply-To: <20170505072500.25692-1-jack@suse.cz>
References: <20170505072500.25692-1-jack@suse.cz>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently DAX read fault can race with write(2) in the following way:

CPU1 - write(2)			CPU2 - read fault
				dax_iomap_pte_fault()
				  ->iomap_begin() - sees hole
dax_iomap_rw()
  iomap_apply()
    ->iomap_begin - allocates blocks
    dax_iomap_actor()
      invalidate_inode_pages2_range()
        - there's nothing to invalidate
				  grab_mapping_entry()
				  - we add zero page in the radix tree
				    and map it to page tables

The result is that hole page is mapped into page tables (and thus zeros
are seen in mmap) while file has data written in that place.

Fix the problem by locking exception entry before mapping blocks for the
fault. That way we are sure invalidate_inode_pages2_range() call for
racing write will either block on entry lock waiting for the fault to
finish (and unmap stale page tables after that) or read fault will see
already allocated blocks by write(2).

Fixes: 9f141d6ef6258a3a37a045842d9ba7e68f368956
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 72853669a356..f5071249d456 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1124,23 +1124,23 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
 		flags |= IOMAP_WRITE;
 
+	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
+	if (IS_ERR(entry))
+		return dax_fault_return(PTR_ERR(entry));
+
 	/*
 	 * Note that we don't bother to use iomap_apply here: DAX required
 	 * the file system block size to be equal the page size, which means
 	 * that we never have to deal with more than a single extent here.
 	 */
 	error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
-	if (error)
-		return dax_fault_return(error);
-	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
-		vmf_ret = dax_fault_return(-EIO);	/* fs corruption? */
-		goto finish_iomap;
+	if (error) {
+		vmf_ret = dax_fault_return(error);
+		goto unlock_entry;
 	}
-
-	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
-	if (IS_ERR(entry)) {
-		vmf_ret = dax_fault_return(PTR_ERR(entry));
-		goto finish_iomap;
+	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
+		error = -EIO;	/* fs corruption? */
+		goto error_finish_iomap;
 	}
 
 	sector = dax_iomap_sector(&iomap, pos);
@@ -1162,13 +1162,13 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		}
 
 		if (error)
-			goto error_unlock_entry;
+			goto error_finish_iomap;
 
 		__SetPageUptodate(vmf->cow_page);
 		vmf_ret = finish_fault(vmf);
 		if (!vmf_ret)
 			vmf_ret = VM_FAULT_DONE_COW;
-		goto unlock_entry;
+		goto finish_iomap;
 	}
 
 	switch (iomap.type) {
@@ -1188,7 +1188,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	case IOMAP_HOLE:
 		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
 			vmf_ret = dax_load_hole(mapping, &entry, vmf);
-			goto unlock_entry;
+			goto finish_iomap;
 		}
 		/*FALLTHRU*/
 	default:
@@ -1197,10 +1197,8 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		break;
 	}
 
- error_unlock_entry:
+ error_finish_iomap:
 	vmf_ret = dax_fault_return(error) | major;
- unlock_entry:
-	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PAGE_SIZE;
@@ -1215,6 +1213,8 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		 */
 		ops->iomap_end(inode, pos, PAGE_SIZE, copied, flags, &iomap);
 	}
+ unlock_entry:
+	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
 	return vmf_ret;
 }
 
-- 
2.12.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
