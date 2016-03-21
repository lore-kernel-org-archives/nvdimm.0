Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38B3F1A1FD0
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 06:22:56 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/10] dax: Remove i_mmap_lock protection
Date: Mon, 21 Mar 2016 14:22:55 +0100
Message-Id: <1458566575-28063-11-git-send-email-jack@suse.cz>
In-Reply-To: <1458566575-28063-1-git-send-email-jack@suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Currently faults are protected against truncate by filesystem specific
i_mmap_sem and page lock in case of hole page. Cow faults are protected
DAX radix tree entry locking. So there's no need for i_mmap_lock in DAX
code. Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 2fcf4e8a17c5..a2a370db59b7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -795,8 +795,6 @@ static int dax_insert_mapping(struct address_space *mapping,
 	int error;
 	void *ret;
 
-	i_mmap_lock_read(mapping);
-
 	if (dax_map_atomic(bdev, &dax) < 0) {
 		error = PTR_ERR(dax.addr);
 		goto out;
@@ -821,7 +819,6 @@ static int dax_insert_mapping(struct address_space *mapping,
 
 	error = vm_insert_mixed(vma, vaddr, dax.pfn);
  out:
-	i_mmap_unlock_read(mapping);
 	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
 	return error;
 }
@@ -1063,8 +1060,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	i_mmap_lock_read(mapping);
-
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
@@ -1162,8 +1157,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	return result;
 
  fallback:
-- 
2.6.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
