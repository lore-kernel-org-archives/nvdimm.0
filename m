Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 431DD1A1F5B
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:18:54 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/12] dax: Fix data corruption for written and mmapped files
Date: Thu, 10 Mar 2016 20:18:50 +0100
Message-Id: <1457637535-21633-8-git-send-email-jack@suse.cz>
In-Reply-To: <1457637535-21633-1-git-send-email-jack@suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
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

When a fault to a hole races with write filling the hole, it can happen
that block zeroing in __dax_fault() overwrites the data copied by write.
Since filesystem is supposed to provide pre-zeroed blocks for fault
anyway, just remove the racy zeroing from dax code. The only catch is
with read-faults over unwritten block where __dax_fault() filled in the
block into page tables anyway. For that case we have to fall back to
using hole page now.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f53b13d9644b..4aa440f9305b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -580,11 +580,6 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		error = PTR_ERR(dax.addr);
 		goto out;
 	}
-
-	if (buffer_unwritten(bh) || buffer_new(bh)) {
-		clear_pmem(dax.addr, PAGE_SIZE);
-		wmb_pmem();
-	}
 	dax_unmap_atomic(bdev, &dax);
 
 	error = dax_radix_entry(mapping, vmf->pgoff, dax.sector, false,
@@ -661,7 +656,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (error)
 		goto unlock_page;
 
-	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
+	if (!buffer_mapped(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			error = get_block(inode, block, &bh, 1);
 			count_vm_event(PGMAJFAULT);
@@ -933,8 +928,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		}
 
 		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			clear_pmem(dax.addr, PMD_SIZE);
-			wmb_pmem();
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 			result |= VM_FAULT_MAJOR;
-- 
2.6.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
