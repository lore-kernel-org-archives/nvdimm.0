Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C263D81EFA
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 01:47:04 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/6] dax: Call ->iomap_begin without entry lock during dax
 fault
Date: Thu, 24 Nov 2016 10:46:35 +0100
Message-Id: <1479980796-26161-6-git-send-email-jack@suse.cz>
In-Reply-To: <1479980796-26161-1-git-send-email-jack@suse.cz>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently ->iomap_begin() handler is called with entry lock held. If the
filesystem held any locks between ->iomap_begin() and ->iomap_end()
(such as ext4 which will want to hold transaction open), this would cause
lock inversion with the iomap_apply() from standard IO path which first
calls ->iomap_begin() and only then calls ->actor() callback which grabs
entry locks for DAX.

Fix the problem by nesting grabbing of entry lock inside ->iomap_begin()
- ->iomap_end() pair.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 120 ++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 65 insertions(+), 55 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 38f996976ebf..be39633d346e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1077,6 +1077,15 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(dax_iomap_rw);
 
+static int dax_fault_return(int error)
+{
+	if (error == 0)
+		return VM_FAULT_NOPAGE;
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM;
+	return VM_FAULT_SIGBUS;
+}
+
 /**
  * dax_iomap_fault - handle a page fault on a DAX file
  * @vma: The virtual memory area where the fault occurred
@@ -1109,12 +1118,6 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (pos >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
-	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
-	if (IS_ERR(entry)) {
-		error = PTR_ERR(entry);
-		goto out;
-	}
-
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
 		flags |= IOMAP_WRITE;
 
@@ -1125,9 +1128,15 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	 */
 	error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
 	if (error)
-		goto unlock_entry;
+		return dax_fault_return(error);
 	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
-		error = -EIO;		/* fs corruption? */
+		vmf_ret = dax_fault_return(-EIO);	/* fs corruption? */
+		goto finish_iomap;
+	}
+
+	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
+	if (IS_ERR(entry)) {
+		vmf_ret = dax_fault_return(PTR_ERR(entry));
 		goto finish_iomap;
 	}
 
@@ -1150,13 +1159,13 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		}
 
 		if (error)
-			goto finish_iomap;
+			goto error_unlock_entry;
 
 		__SetPageUptodate(vmf->cow_page);
 		vmf_ret = finish_fault(vmf);
 		if (!vmf_ret)
 			vmf_ret = VM_FAULT_DONE_COW;
-		goto finish_iomap;
+		goto unlock_entry;
 	}
 
 	switch (iomap.type) {
@@ -1168,12 +1177,15 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		}
 		error = dax_insert_mapping(mapping, iomap.bdev, sector,
 				PAGE_SIZE, &entry, vma, vmf);
+		/* -EBUSY is fine, somebody else faulted on the same PTE */
+		if (error == -EBUSY)
+			error = 0;
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
 		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
 			vmf_ret = dax_load_hole(mapping, &entry, vmf);
-			goto finish_iomap;
+			goto unlock_entry;
 		}
 		/*FALLTHRU*/
 	default:
@@ -1182,30 +1194,25 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		break;
 	}
 
- finish_iomap:
-	if (ops->iomap_end) {
-		if (error || (vmf_ret & VM_FAULT_ERROR)) {
-			/* keep previous error */
-			ops->iomap_end(inode, pos, PAGE_SIZE, 0, flags,
-					&iomap);
-		} else {
-			error = ops->iomap_end(inode, pos, PAGE_SIZE,
-					PAGE_SIZE, flags, &iomap);
-		}
-	}
+ error_unlock_entry:
+	vmf_ret = dax_fault_return(error) | major;
  unlock_entry:
 	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
- out:
-	if (error == -ENOMEM)
-		return VM_FAULT_OOM | major;
-	/* -EBUSY is fine, somebody else faulted on the same PTE */
-	if (error < 0 && error != -EBUSY)
-		return VM_FAULT_SIGBUS | major;
-	if (vmf_ret) {
-		WARN_ON_ONCE(error); /* -EBUSY from ops->iomap_end? */
-		return vmf_ret;
+ finish_iomap:
+	if (ops->iomap_end) {
+		int copied = PAGE_SIZE;
+
+		if (vmf_ret & VM_FAULT_ERROR)
+			copied = 0;
+		/*
+		 * The fault is done by now and there's no way back (other
+		 * thread may be already happily using PTE we have installed).
+		 * Just ignore error from ->iomap_end since we cannot do much
+		 * with it.
+		 */
+		ops->iomap_end(inode, pos, PAGE_SIZE, copied, flags, &iomap);
 	}
-	return VM_FAULT_NOPAGE | major;
+	return vmf_ret;
 }
 EXPORT_SYMBOL_GPL(dax_iomap_fault);
 
@@ -1330,6 +1337,15 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		goto fallback;
 
 	/*
+	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
+	 * setting up a mapping, so really we're using iomap_begin() as a way
+	 * to look up our filesystem block.
+	 */
+	pos = (loff_t)pgoff << PAGE_SHIFT;
+	error = ops->iomap_begin(inode, pos, PMD_SIZE, iomap_flags, &iomap);
+	if (error)
+		goto fallback;
+	/*
 	 * grab_mapping_entry() will make sure we get a 2M empty entry, a DAX
 	 * PMD or a HZP entry.  If it can't (because a 4k page is already in
 	 * the tree, for instance), it will return -EEXIST and we just fall
@@ -1337,19 +1353,10 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	 */
 	entry = grab_mapping_entry(mapping, pgoff, RADIX_DAX_PMD);
 	if (IS_ERR(entry))
-		goto fallback;
+		goto finish_iomap;
 
-	/*
-	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
-	 * setting up a mapping, so really we're using iomap_begin() as a way
-	 * to look up our filesystem block.
-	 */
-	pos = (loff_t)pgoff << PAGE_SHIFT;
-	error = ops->iomap_begin(inode, pos, PMD_SIZE, iomap_flags, &iomap);
-	if (error)
-		goto unlock_entry;
 	if (iomap.offset + iomap.length < pos + PMD_SIZE)
-		goto finish_iomap;
+		goto unlock_entry;
 
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
@@ -1363,7 +1370,7 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
 		if (WARN_ON_ONCE(write))
-			goto finish_iomap;
+			goto unlock_entry;
 		result = dax_pmd_load_hole(vma, pmd, &vmf, address, &iomap,
 				&entry);
 		break;
@@ -1372,20 +1379,23 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		break;
 	}
 
+ unlock_entry:
+	put_locked_mapping_entry(mapping, pgoff, entry);
  finish_iomap:
 	if (ops->iomap_end) {
-		if (result == VM_FAULT_FALLBACK) {
-			ops->iomap_end(inode, pos, PMD_SIZE, 0, iomap_flags,
-					&iomap);
-		} else {
-			error = ops->iomap_end(inode, pos, PMD_SIZE, PMD_SIZE,
-					iomap_flags, &iomap);
-			if (error)
-				result = VM_FAULT_FALLBACK;
-		}
+		int copied = PMD_SIZE;
+
+		if (result == VM_FAULT_FALLBACK)
+			copied = 0;
+		/*
+		 * The fault is done by now and there's no way back (other
+		 * thread may be already happily using PMD we have installed).
+		 * Just ignore error from ->iomap_end since we cannot do much
+		 * with it.
+		 */
+		ops->iomap_end(inode, pos, PMD_SIZE, copied, iomap_flags,
+				&iomap);
 	}
- unlock_entry:
-	put_locked_mapping_entry(mapping, pgoff, entry);
  fallback:
 	if (result == VM_FAULT_FALLBACK) {
 		split_huge_pmd(vma, pmd, address);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
