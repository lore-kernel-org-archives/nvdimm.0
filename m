Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C694C1A1EFA
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 14:09:20 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 13/17] dax: dax_iomap_fault() needs to call iomap_end()
Date: Fri,  7 Oct 2016 15:09:00 -0600
Message-Id: <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Currently iomap_end() doesn't do anything for DAX page faults for both ext2
and XFS.  ext2_iomap_end() just checks for a write underrun, and
xfs_file_iomap_end() checks to see if it needs to finish a delayed
allocation.  However, in the future iomap_end() calls might be needed to
make sure we have balanced allocations, locks, etc.  So, add calls to
iomap_end() with appropriate error handling to dax_iomap_fault().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7689ab0..5e8febe 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1187,7 +1187,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		goto unlock_entry;
 	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
 		error = -EIO;		/* fs corruption? */
-		goto unlock_entry;
+		goto finish_iomap;
 	}
 
 	sector = dax_iomap_sector(&iomap, pos);
@@ -1209,7 +1209,14 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		}
 
 		if (error)
-			goto unlock_entry;
+			goto finish_iomap;
+
+		if (ops->iomap_end) {
+			error = ops->iomap_end(inode, pos, PAGE_SIZE,
+					PAGE_SIZE, flags, &iomap);
+			if (error)
+				goto unlock_entry;
+		}
 		if (!radix_tree_exceptional_entry(entry)) {
 			vmf->page = entry;
 			return VM_FAULT_LOCKED;
@@ -1230,8 +1237,15 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
-		if (!(vmf->flags & FAULT_FLAG_WRITE))
+		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
+			if (ops->iomap_end)  {
+				error = ops->iomap_end(inode, pos, PAGE_SIZE,
+						PAGE_SIZE, flags, &iomap);
+				if (error)
+					goto unlock_entry;
+			}
 			return dax_load_hole(mapping, entry, vmf);
+		}
 		/*FALLTHRU*/
 	default:
 		WARN_ON_ONCE(1);
@@ -1239,6 +1253,17 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		break;
 	}
 
+ finish_iomap:
+	if (ops->iomap_end) {
+		if (error) {
+			/* keep previous error */
+			ops->iomap_end(inode, pos, PAGE_SIZE, PAGE_SIZE, flags,
+					&iomap);
+		} else {
+			error = ops->iomap_end(inode, pos, PAGE_SIZE,
+					PAGE_SIZE, flags, &iomap);
+		}
+	}
  unlock_entry:
 	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  out:
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
