Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8CE201A1F90
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 09:29:35 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 7/7] dax: Remove i_mmap_lock protection
Date: Thu, 12 May 2016 18:29:20 +0200
Message-Id: <1463070560-1979-8-git-send-email-jack@suse.cz>
In-Reply-To: <1463070560-1979-1-git-send-email-jack@suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently faults are protected against truncate by filesystem specific
i_mmap_sem and page lock in case of hole page. Cow faults are protected
DAX radix tree entry locking. So there's no need for i_mmap_lock in DAX
code. Remove it.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c    | 24 +++++-------------------
 mm/memory.c |  2 --
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index a09d19f5371e..a07202ab8f61 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -830,29 +830,19 @@ static int dax_insert_mapping(struct address_space *mapping,
 		.sector = to_sector(bh, mapping->host),
 		.size = bh->b_size,
 	};
-	int error;
 	void *ret;
 	void *entry = *entryp;
 
-	i_mmap_lock_read(mapping);
-
-	if (dax_map_atomic(bdev, &dax) < 0) {
-		error = PTR_ERR(dax.addr);
-		goto out;
-	}
+	if (dax_map_atomic(bdev, &dax) < 0)
+		return PTR_ERR(dax.addr);
 	dax_unmap_atomic(bdev, &dax);
 
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, dax.sector);
-	if (IS_ERR(ret)) {
-		error = PTR_ERR(ret);
-		goto out;
-	}
+	if (IS_ERR(ret))
+		return PTR_ERR(ret);
 	*entryp = ret;
 
-	error = vm_insert_mixed(vma, vaddr, dax.pfn);
- out:
-	i_mmap_unlock_read(mapping);
-	return error;
+	return vm_insert_mixed(vma, vaddr, dax.pfn);
 }
 
 /**
@@ -1090,8 +1080,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	i_mmap_lock_read(mapping);
-
 	if (!write && !buffer_mapped(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
@@ -1180,8 +1168,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	return result;
 
  fallback:
diff --git a/mm/memory.c b/mm/memory.c
index 7f063c9ad711..f6f1c15c8682 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2486,8 +2486,6 @@ void unmap_mapping_range(struct address_space *mapping,
 	if (details.last_index < details.first_index)
 		details.last_index = ULONG_MAX;
 
-
-	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
