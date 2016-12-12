Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32B7D820F6
 for <linux-nvdimm@lists.01.org>; Mon, 12 Dec 2016 08:35:24 -0800 (PST)
Date: Mon, 12 Dec 2016 17:35:18 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [ext4]  e2ae766c1b:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c
Message-ID: <20161212163518.GA20728@quack2.suse.cz>
References: <20161212101321.GA37214@inn.lkp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20161212101321.GA37214@inn.lkp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: kernel test robot <xiaolong.ye@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, lkp@01.org
List-ID: <linux-nvdimm@lists.01.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 12-12-16 18:13:21, kernel test robot wrote:
> FYI, we noticed the following commit:
> 
> commit: e2ae766c1b030271b5099b25674e2131d1d1e8c1 ("ext4: convert DAX faults to iomap infrastructure")
> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> 
> in testcase: nvml
> with following parameters:
> 
> 	group: vmem
> 	test: pmem
> 	nr_pmem: 1
> 	fs: ext4
> 	mount_option: dax
> 
> 
> 
> on test machine: 64 threads Intel(R) Xeon(R) CPU E5-4650 0 @ 2.70GHz with 64G memory
> 
> caused below changes:
> 
> 
> +------------------------------------------------+------------+------------+
> |                                                | 96f8ba3dd6 | e2ae766c1b |
> +------------------------------------------------+------------+------------+
> | boot_successes                                 | 2          | 2          |
> | boot_failures                                  | 2          | 2          |
> | BUG:kernel_hang_in_test_stage                  | 2          |            |
> | WARNING:at_fs/sysfs/dir.c:#sysfs_warn_dup      | 0          | 2          |
> | calltrace:parport_pc_init                      | 0          | 2          |
> | calltrace:SyS_finit_module                     | 0          | 2          |
> | WARNING:at_lib/kobject.c:#kobject_add_internal | 0          | 2          |
> +------------------------------------------------+------------+------------+
> 
> 
> 
> user  :notice: [  325.592182] vmem_aligned_alloc/TEST1: SETUP (check/pmem/debug)
> 
> user  :notice: [  325.603973] vmem_aligned_alloc/TEST1: START: vmem_aligned_alloc
> kern  :err   : [  325.608906] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:51
> kern  :err   : [  325.608908] in_atomic(): 1, irqs_disabled(): 0, pid: 24813, name: vmem_aligned_al
> kern  :warn  : [  325.608914] CPU: 44 PID: 24813 Comm: vmem_aligned_al Tainted: G           O    4.9.0-rc4-00045-ge2ae766 #1
> kern  :warn  : [  325.608916] Hardware name: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
> kern  :warn  : [  325.608922]  ffffc9002c1f7be0
> kern  :warn  : [  325.608923]  ffffffff81466af9
> kern  :warn  : [  325.608924]  ffff880fea2425c0

I think this is actually a bug introduced by Ross' PMD support. Attached
patch should fix it. Ross, can you check it please?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--VbJkn9YxBvnuCH5J
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Fix-sleep-in-atomic-contex-in-grab_mapping_entry.patch"

>From c3d67dc7543abc03161f6cf357039ad9e56783ca Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 12 Dec 2016 16:32:23 +0100
Subject: [PATCH] dax: Fix sleep in atomic contex in grab_mapping_entry()

Commit 7b5b8c9c4ac9 "dax: add struct iomap based DAX PMD support" has
introduced unmapping of page tables if huge page needs to be split in
grab_mapping_entry(). However the unmapping happens after
radix_tree_preload() call which disables preemption and thus
unmap_mapping_range() tries to acquire i_mmap_lock in atomic context
which is a bug. Fix the problem by moving unmapping before
radix_tree_preload() call.

Fixes: 7b5b8c9c4ac9716fe9d77ec56ae5d962192ba030
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 51b03e91d3e2..5c74f60d0a50 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -351,14 +351,6 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		}
 
 		spin_unlock_irq(&mapping->tree_lock);
-		err = radix_tree_preload(
-				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
-		if (err) {
-			if (pmd_downgrade)
-				put_locked_mapping_entry(mapping, index, entry);
-			return ERR_PTR(err);
-		}
-
 		/*
 		 * Besides huge zero pages the only other thing that gets
 		 * downgraded are empty entries which don't need to be
@@ -368,6 +360,13 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 			unmap_mapping_range(mapping,
 				(index << PAGE_SHIFT) & PMD_MASK, PMD_SIZE, 0);
 
+		err = radix_tree_preload(
+				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
+		if (err) {
+			if (pmd_downgrade)
+				put_locked_mapping_entry(mapping, index, entry);
+			return ERR_PTR(err);
+		}
 		spin_lock_irq(&mapping->tree_lock);
 
 		if (pmd_downgrade) {
-- 
2.10.2


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--VbJkn9YxBvnuCH5J--
