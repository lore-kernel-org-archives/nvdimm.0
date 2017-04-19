Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AD5121A0483B
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 10:47:15 -0700 (PDT)
Subject: [4.9, 4.10 -stable PATCH] device-dax: switch to srcu,
 fix rcu_read_lock() vs pte allocation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 10:41:28 -0700
Message-ID: <149262368870.23714.15890323452545563405.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: stable@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

commit 956a4cd2c957acf638ff29951aabaa9d8e92bbc2 upstream.

The following warning triggers with a new unit test that stresses the
device-dax interface.

 ===============================
 [ ERR: suspicious RCU usage.  ]
 4.11.0-rc4+ #1049 Tainted: G           O
 -------------------------------
 ./include/linux/rcupdate.h:521 Illegal context switch in RCU read-side critical section!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 0
 2 locks held by fio/9070:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8d0739d7>] __do_page_fault+0x167/0x4f0
  #1:  (rcu_read_lock){......}, at: [<ffffffffc03fbd02>] dax_dev_huge_fault+0x32/0x620 [dax]

 Call Trace:
  dump_stack+0x86/0xc3
  lockdep_rcu_suspicious+0xd7/0x110
  ___might_sleep+0xac/0x250
  __might_sleep+0x4a/0x80
  __alloc_pages_nodemask+0x23a/0x360
  alloc_pages_current+0xa1/0x1f0
  pte_alloc_one+0x17/0x80
  __pte_alloc+0x1e/0x120
  __get_locked_pte+0x1bf/0x1d0
  insert_pfn.isra.70+0x3a/0x100
  ? lookup_memtype+0xa6/0xd0
  vm_insert_mixed+0x64/0x90
  dax_dev_huge_fault+0x520/0x620 [dax]
  ? dax_dev_huge_fault+0x32/0x620 [dax]
  dax_dev_fault+0x10/0x20 [dax]
  __do_fault+0x1e/0x140
  __handle_mm_fault+0x9af/0x10d0
  handle_mm_fault+0x16d/0x370
  ? handle_mm_fault+0x47/0x370
  __do_page_fault+0x28c/0x4f0
  trace_do_page_fault+0x58/0x2a0
  do_async_page_fault+0x1a/0xa0
  async_page_fault+0x28/0x30

Inserting a page table entry may trigger an allocation while we are
holding a read lock to keep the device instance alive for the duration
of the fault. Use srcu for this keep-alive protection.

Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig |    1 +
 drivers/dax/dax.c   |   13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 3e2ab3b14eea..9e95bf94eb13 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -2,6 +2,7 @@ menuconfig DEV_DAX
 	tristate "DAX: direct access to differentiated memory"
 	default m if NVDIMM_DAX
 	depends on TRANSPARENT_HUGEPAGE
+	select SRCU
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 20ab6bf9d1c7..53a016c3dffa 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -24,6 +24,7 @@
 #include "dax.h"
 
 static dev_t dax_devt;
+DEFINE_STATIC_SRCU(dax_srcu);
 static struct class *dax_class;
 static DEFINE_IDA(dax_minor_ida);
 static int nr_dax = CONFIG_NR_DEV_DAX;
@@ -59,7 +60,7 @@ struct dax_region {
  * @region - parent region
  * @dev - device backing the character device
  * @cdev - core chardev data
- * @alive - !alive + rcu grace period == no new mappings can be established
+ * @alive - !alive + srcu grace period == no new mappings can be established
  * @id - child id in the region
  * @num_resources - number of physical address extents in this device
  * @res - array of physical address ranges
@@ -530,7 +531,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev,
 static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, unsigned int flags)
 {
-	int rc;
+	int rc, id;
 	struct file *filp = vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
 
@@ -538,9 +539,9 @@ static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 			current->comm, (flags & FAULT_FLAG_WRITE)
 			? "write" : "read", vma->vm_start, vma->vm_end);
 
-	rcu_read_lock();
+	id = srcu_read_lock(&dax_srcu);
 	rc = __dax_dev_pmd_fault(dax_dev, vma, addr, pmd, flags);
-	rcu_read_unlock();
+	srcu_read_unlock(&dax_srcu, id);
 
 	return rc;
 }
@@ -656,11 +657,11 @@ static void unregister_dax_dev(void *dev)
 	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
 	 * ensuring that any fault handlers that might have seen
 	 * dax_dev->alive == true, have completed.  Any fault handlers
-	 * that start after synchronize_rcu() has started will abort
+	 * that start after synchronize_srcu() has started will abort
 	 * upon seeing dax_dev->alive == false.
 	 */
 	dax_dev->alive = false;
-	synchronize_rcu();
+	synchronize_srcu(&dax_srcu);
 	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
 	cdev_del(cdev);
 	device_unregister(dev);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
