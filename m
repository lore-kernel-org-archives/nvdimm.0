Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id B48DF1A1EC2
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:36:29 -0700 (PDT)
Subject: [PATCH 6/7] /dev/dax, core: file operations and dax-mmap
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:35:42 -0700
Message-ID: <146274694214.10891.5764699458357001927.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146274690999.10891.10714722986208180484.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146274690999.10891.10714722986208180484.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

The "Device DAX" core enables dax mappings of performance / feature
differentiated memory.  An open mapping or file handle keeps the backing
struct device live, but new mappings are only possible while the device
is enabled.   Faults are handled under the device lock to synchronize
with the enabled state of the device.  Per the standard device model,
device->driver_data is non-NULL while the device is enabled, and device
state transitions happen under the device lock.

Similar to the filesystem-dax case the backing memory may optionally
have struct page entries.  However, unlike fs-dax there is no support
for private mappings, or mappings that are not backed by media (see
use of zero-page in fs-dax).

Mappings are always guaranteed to match the alignment of the dax_region.
If the dax_region is configured to have a 2MB alignment, all mappings
are guaranteed to be backed by a pmd entry.  Contrast this determinism
with the fs-dax case where pmd mappings are opportunistic.  If userspace
attempts to force a misaligned mapping, the driver will fail the mmap
attempt.  See dax_dev_check_vma() for other scenarios that are rejected,
like MAP_PRIVATE mappings.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |  320 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c  |    1 
 mm/hugetlb.c      |    1 
 3 files changed, 322 insertions(+)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index e95af4ead357..4198054e703c 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -187,9 +187,329 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 }
 EXPORT_SYMBOL_GPL(devm_create_dax_dev);
 
+/* return an unmapped area aligned to the dax region specified alignment */
+static unsigned long dax_dev_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	struct dax_dev *dax_dev;
+	struct device *dev = filp ? filp->private_data : NULL;
+	unsigned long off, off_end, off_align, len_align, addr_align, align = 0;
+
+	if (!filp || addr)
+		goto out;
+
+	device_lock(dev);
+	dax_dev = dev_get_drvdata(dev);
+	if (dax_dev) {
+		struct dax_region *dax_region = dax_dev->region;
+
+		align = dax_region->align;
+	}
+	device_unlock(dev);
+
+	if (!align)
+		goto out;
+
+	off = pgoff << PAGE_SHIFT;
+	off_end = off + len;
+	off_align = round_up(off, align);
+
+	if ((off_end <= off_align) || ((off_end - off_align) < align))
+		goto out;
+
+	len_align = len + align;
+	if ((off + len_align) < off)
+		goto out;
+
+	addr_align = current->mm->get_unmapped_area(filp, addr, len_align,
+			pgoff, flags);
+	if (!IS_ERR_VALUE(addr_align)) {
+		addr_align += (off - addr_align) & (align - 1);
+		return addr_align;
+	}
+ out:
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+
+static int __match_devt(struct device *dev, const void *data)
+{
+	const dev_t *devt = data;
+
+	return dev->devt == *devt;
+}
+
+static int dax_dev_open(struct inode *inode, struct file *filp)
+{
+	struct device *dev;
+
+	dev = class_find_device(dax_class, NULL, &inode->i_rdev, __match_devt);
+	if (dev) {
+		dev_dbg(dev, "%s\n", __func__);
+		filp->private_data = dev;
+		inode->i_flags = S_DAX;
+		return 0;
+	}
+	return -ENXIO;
+}
+
+static int dax_dev_release(struct inode *inode, struct file *filp)
+{
+	struct device *dev = filp->private_data;
+
+	dev_dbg(dev, "%s\n", __func__);
+	put_device(dev);
+	return 0;
+}
+
+static struct dax_dev *to_dax_dev(struct device *dev)
+{
+	WARN_ON(dev->class != dax_class);
+	device_lock_assert(dev);
+	return dev_get_drvdata(dev);
+}
+
+static int dax_dev_check_vma(struct device *dev, struct vm_area_struct *vma,
+		const char *func)
+{
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region;
+	unsigned long mask;
+
+	if (!dax_dev)
+		return -ENXIO;
+
+	/* prevent private / writable mappings from being established */
+	if ((vma->vm_flags & (VM_NORESERVE|VM_SHARED|VM_WRITE)) == VM_WRITE) {
+		dev_dbg(dev, "%s: fail, attempted private mapping\n", func);
+		return -EINVAL;
+	}
+
+	dax_region = dax_dev->region;
+	mask = dax_region->align - 1;
+	if (vma->vm_start & mask || vma->vm_end & mask) {
+		dev_dbg(dev, "%s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
+				func, vma->vm_start, vma->vm_end, mask);
+		return -EINVAL;
+	}
+
+	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) == PFN_DEV
+			&& (vma->vm_flags & VM_DONTCOPY) == 0) {
+		dev_dbg(dev, "%s: fail, dax range requires MADV_DONTFORK\n",
+				func);
+		return -EINVAL;
+	}
+
+	if (!vma_is_dax(vma)) {
+		dev_dbg(dev, "%s: fail, vma is not DAX capable\n", func);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+		unsigned long size)
+{
+	struct resource *res;
+	phys_addr_t phys;
+	int i;
+
+	for (i = 0; i < dax_dev->num_resources; i++) {
+		res = &dax_dev->res[i];
+		phys = pgoff * PAGE_SIZE + res->start;
+		if (phys >= res->start && phys <= res->end)
+			break;
+		pgoff -= PHYS_PFN(resource_size(res));
+	}
+
+	if (i < dax_dev->num_resources) {
+		res = &dax_dev->res[i];
+		if (phys + size - 1 <= res->end)
+			return phys;
+	}
+
+	return -1;
+}
+
+static int __dax_dev_fault(struct address_space *mapping, struct device *dev,
+		struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region;
+	phys_addr_t phys;
+	pfn_t pfn;
+	int rc;
+
+	if (!dax_dev)
+		return VM_FAULT_SIGBUS;
+
+	if (dax_dev_check_vma(dev, vma, __func__))
+		return VM_FAULT_SIGBUS;
+
+	dax_region = dax_dev->region;
+	if (dax_region->align > PAGE_SIZE) {
+		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
+	if (phys == -1) {
+		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+				vmf->pgoff);
+		return VM_FAULT_SIGBUS;
+	}
+
+	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
+
+	i_mmap_lock_read(mapping);
+	rc = vm_insert_mixed(vma, vaddr, pfn);
+	i_mmap_unlock_read(mapping);
+
+	if (rc == -ENOMEM)
+		return VM_FAULT_OOM;
+	if (rc < 0 && rc != -EBUSY)
+		return VM_FAULT_SIGBUS;
+
+	return VM_FAULT_NOPAGE;
+}
+
+static int dax_dev_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int rc;
+	struct file *filp = vma->vm_file;
+	struct device *dev = filp->private_data;
+	struct address_space *mapping = filp->f_mapping;
+
+	dev_dbg(dev, "%s: %s (%#lx - %#lx)\n", __func__,
+			(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
+			vma->vm_start, vma->vm_end);
+	device_lock(dev);
+	rc = __dax_dev_fault(mapping, dev, vma, vmf);
+	device_unlock(dev);
+
+	return rc;
+}
+
+static int __dax_dev_pmd_fault(struct address_space *mapping,
+		struct device *dev, struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmd, unsigned int flags)
+{
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+	unsigned long pmd_addr = addr & PMD_MASK;
+	struct dax_region *dax_region;
+	phys_addr_t phys;
+	pgoff_t pgoff;
+	pfn_t pfn;
+	int rc;
+
+	if (!dax_dev)
+		return VM_FAULT_SIGBUS;
+
+	if (dax_dev_check_vma(dev, vma, __func__))
+		return VM_FAULT_SIGBUS;
+
+	dax_region = dax_dev->region;
+	if (dax_region->align > HPAGE_SIZE) {
+		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	/* dax pmd mappings require pfn_t_devmap() */
+	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) != (PFN_DEV|PFN_MAP)) {
+		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	pgoff = linear_page_index(vma, pmd_addr);
+	phys = pgoff_to_phys(dax_dev, pgoff, PAGE_SIZE);
+	if (phys == -1) {
+		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+				pgoff);
+		return VM_FAULT_SIGBUS;
+	}
+
+	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
+
+	i_mmap_lock_read(mapping);
+	rc = vmf_insert_pfn_pmd(vma, addr, pmd, pfn,
+			flags & FAULT_FLAG_WRITE);
+	i_mmap_unlock_read(mapping);
+
+	return rc;
+}
+
+static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd, unsigned int flags)
+{
+	int rc;
+	struct file *filp = vma->vm_file;
+	struct device *dev = filp->private_data;
+	struct address_space *mapping = filp->f_mapping;
+
+	dev_dbg(dev, "%s: %s (%#lx - %#lx)\n", __func__,
+			(flags & FAULT_FLAG_WRITE) ? "write" : "read",
+			vma->vm_start, vma->vm_end);
+	device_lock(dev);
+	rc = __dax_dev_pmd_fault(mapping, dev, vma, addr, pmd, flags);
+	device_unlock(dev);
+
+	return rc;
+}
+
+static void dax_dev_vm_open(struct vm_area_struct *vma)
+{
+	struct file *filp = vma->vm_file;
+	struct device *dev = filp->private_data;
+
+	dev_dbg(dev, "%s\n", __func__);
+	get_device(dev);
+}
+
+static void dax_dev_vm_close(struct vm_area_struct *vma)
+{
+	struct file *filp = vma->vm_file;
+	struct device *dev = filp->private_data;
+
+	dev_dbg(dev, "%s\n", __func__);
+	put_device(dev);
+}
+
+static const struct vm_operations_struct dax_dev_vm_ops = {
+	.fault = dax_dev_fault,
+	.pmd_fault = dax_dev_pmd_fault,
+	.open = dax_dev_vm_open,
+	.close = dax_dev_vm_close,
+};
+
+static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct device *dev = filp->private_data;
+	int rc;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	device_lock(dev);
+	rc = dax_dev_check_vma(dev, vma, __func__);
+	device_unlock(dev);
+	if (rc)
+		return rc;
+
+	get_device(dev);
+	vma->vm_ops = &dax_dev_vm_ops;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	return 0;
+
+}
+
 static const struct file_operations dax_fops = {
 	.llseek = noop_llseek,
 	.owner = THIS_MODULE,
+	.open = dax_dev_open,
+	.release = dax_dev_release,
+	.get_unmapped_area = dax_dev_get_unmapped_area,
+	.mmap = dax_dev_mmap,
 };
 
 static int __init dax_init(void)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 86f9f8b82f8e..52ea012d8a80 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1013,6 +1013,7 @@ int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
 	return VM_FAULT_NOPAGE;
 }
+EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
 
 static void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 19d0d08b396f..b14e98129b07 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -624,6 +624,7 @@ pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
 {
 	return vma_hugecache_offset(hstate_vma(vma), vma, address);
 }
+EXPORT_SYMBOL_GPL(linear_hugepage_index);
 
 /*
  * Return the size of the pages allocated when backing a VMA. In the majority

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
