Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C28F211518C3
 for <linux-nvdimm@lists.01.org>; Mon, 24 Sep 2018 16:44:51 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm/dax fixes for 4.19-rc6
Date: Mon, 24 Sep 2018 23:34:04 +0000
Message-ID: <1537832042.7585.16.camel@intel.com>
Content-Language: en-US
Content-ID: <1A17D6520A9ED54597D9AA4CFFF8EA85@intel.com>
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
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Greg, please pull from...

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

* (2) fixes for the dax error handling updates that were merged for
v4.19-rc1. My mails to Al have been bouncing recently, so I do not have
his ack but the uaccess change is of the trivial / obviously correct
variety. The address_space_operations fixes a regression.

* A filesystem-dax fix to correct the zero page lookup to be compatible
 with non-x86 (mips and s390) architectures.

Arguably only the address_space_operations fix is urgent for -rc6, the
others can reasonably wait, but I see no reason to hold them back. This
has all appeared in -next with no reported issues. The full diff is
small and included below.

---

The following changes since commit 11da3a7f84f19c26da6f86af878298694ede0804:

  Linux 4.19-rc3 (2018-09-09 17:26:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 41c9b1be335b5afc3b5fb71c5d16f9d5939cd13f:

  device-dax: Add missing address_space_operations (2018-09-22 09:07:33 -0700)

----------------------------------------------------------------
Dave Jiang (2):
      uaccess: Fix is_source param for check_copy_size() in copy_to_iter_mcsafe()
      device-dax: Add missing address_space_operations

Matthew Wilcox (1):
      filesystem-dax: Fix use of zero page

 drivers/dax/device.c |  6 ++++++
 fs/dax.c             | 13 ++-----------
 include/linux/uio.h  |  2 +-
 3 files changed, 9 insertions(+), 12 deletions(-)

---

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index bbe4d72ca105..948806e57cee 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -535,6 +535,11 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
+static const struct address_space_operations dev_dax_aops = {
+	.set_page_dirty		= noop_set_page_dirty,
+	.invalidatepage		= noop_invalidatepage,
+};
+
 static int dax_open(struct inode *inode, struct file *filp)
 {
 	struct dax_device *dax_dev = inode_dax(inode);
@@ -544,6 +549,7 @@ static int dax_open(struct inode *inode, struct file *filp)
 	dev_dbg(&dev_dax->dev, "trace\n");
 	inode->i_mapping = __dax_inode->i_mapping;
 	inode->i_mapping->host = __dax_inode;
+	inode->i_mapping->a_ops = &dev_dax_aops;
 	filp->f_mapping = inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
 	filp->private_data = dev_dax;
diff --git a/fs/dax.c b/fs/dax.c
index f32d7125ad0f..b68ce484e1be 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1120,21 +1120,12 @@ static vm_fault_t dax_load_hole(struct address_space *mapping, void *entry,
 {
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
-	struct page *zero_page;
-	pfn_t pfn;
-
-	zero_page = ZERO_PAGE(0);
-	if (unlikely(!zero_page)) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
+	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
+	vm_fault_t ret;
 
-	pfn = page_to_pfn_t(zero_page);
 	dax_insert_mapping_entry(mapping, vmf, entry, pfn, RADIX_DAX_ZERO_PAGE,
 			false);
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
-out:
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 409c845d4cd3..422b1c01ee0d 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -172,7 +172,7 @@ size_t copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 static __always_inline __must_check
 size_t copy_to_iter_mcsafe(void *addr, size_t bytes, struct iov_iter *i)
 {
-	if (unlikely(!check_copy_size(addr, bytes, false)))
+	if (unlikely(!check_copy_size(addr, bytes, true)))
 		return 0;
 	else
 		return _copy_to_iter_mcsafe(addr, bytes, i);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
