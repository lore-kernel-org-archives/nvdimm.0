Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23C961A1E34
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 03:57:24 -0700 (PDT)
Date: Tue, 17 May 2016 12:57:11 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 2/3] /dev/dax, core: file operations and dax-mmap
Message-ID: <20160517105711.GA3333@c203.arch.suse.de>
References: <146329357870.17948.14240958684074905846.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146329358943.17948.12857084981536373315.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146329358943.17948.12857084981536373315.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sat, May 14, 2016 at 11:26:29PM -0700, Dan Williams wrote:
> The "Device DAX" core enables dax mappings of performance / feature
> differentiated memory.  An open mapping or file handle keeps the backing
> struct device live, but new mappings are only possible while the device
> is enabled.   Faults are handled under rcu_read_lock to synchronize
> with the enabled state of the device.
> =

> Similar to the filesystem-dax case the backing memory may optionally
> have struct page entries.  However, unlike fs-dax there is no support
> for private mappings, or mappings that are not backed by media (see
> use of zero-page in fs-dax).
> =

> Mappings are always guaranteed to match the alignment of the dax_region.
> If the dax_region is configured to have a 2MB alignment, all mappings
> are guaranteed to be backed by a pmd entry.  Contrast this determinism
> with the fs-dax case where pmd mappings are opportunistic.  If userspace
> attempts to force a misaligned mapping, the driver will fail the mmap
> attempt.  See dax_dev_check_vma() for other scenarios that are rejected,
> like MAP_PRIVATE mappings.
> =

> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/Kconfig |    1 =

>  drivers/dax/dax.c   |  316 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  mm/huge_memory.c    |    1 =

>  mm/hugetlb.c        |    1 =

>  4 files changed, 319 insertions(+)
> =

> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index 86ffbaa891ad..cedab7572de3 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -1,6 +1,7 @@
>  menuconfig DEV_DAX
>  	tristate "DAX: direct access to differentiated memory"
>  	default m if NVDIMM_DAX
> +	depends on TRANSPARENT_HUGEPAGE
>  	help
>  	  Support raw access to differentiated (persistence, bandwidth,
>  	  latency...) memory via an mmap(2) capable character
> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
> index 8207fb33a992..b2fe8a0ce866 100644
> --- a/drivers/dax/dax.c
> +++ b/drivers/dax/dax.c
> @@ -49,6 +49,7 @@ struct dax_region {
>   * @region - parent region
>   * @dev - device backing the character device
>   * @kref - enable this data to be tracked in filp->private_data
> + * @alive - !alive + rcu grace period =3D=3D no new mappings can be esta=
blished
>   * @id - child id in the region
>   * @num_resources - number of physical address extents in this device
>   * @res - array of physical address ranges
> @@ -57,6 +58,7 @@ struct dax_dev {
>  	struct dax_region *region;
>  	struct device *dev;
>  	struct kref kref;
> +	bool alive;
>  	int id;
>  	int num_resources;
>  	struct resource res[0];
> @@ -150,6 +152,10 @@ static void destroy_dax_dev(void *_dev)
>  =

>  	dev_dbg(dev, "%s\n", __func__);
>  =

> +	/* disable and flush fault handlers, TODO unmap inodes */
> +	dax_dev->alive =3D false;
> +	synchronize_rcu();
> +

IIRC RCU is only protecting a pointer, not the content of the pointer, so t=
his
looks wrong to me.

>  	get_device(dev);
>  	device_unregister(dev);
>  	ida_simple_remove(&dax_region->ida, dax_dev->id);
> @@ -173,6 +179,7 @@ int devm_create_dax_dev(struct dax_region *dax_region=
, struct resource *res,
>  	memcpy(dax_dev->res, res, sizeof(*res) * count);
>  	dax_dev->num_resources =3D count;
>  	kref_init(&dax_dev->kref);
> +	dax_dev->alive =3D true;
>  	dax_dev->region =3D dax_region;
>  	kref_get(&dax_region->kref);
>  =

> @@ -217,9 +224,318 @@ int devm_create_dax_dev(struct dax_region *dax_regi=
on, struct resource *res,
>  }
>  EXPORT_SYMBOL_GPL(devm_create_dax_dev);
>  =

> +/* return an unmapped area aligned to the dax region specified alignment=
 */
> +static unsigned long dax_dev_get_unmapped_area(struct file *filp,
> +		unsigned long addr, unsigned long len, unsigned long pgoff,
> +		unsigned long flags)
> +{
> +	unsigned long off, off_end, off_align, len_align, addr_align, align;
> +	struct dax_dev *dax_dev =3D filp ? filp->private_data : NULL;
> +	struct dax_region *dax_region;
> +
> +	if (!dax_dev || addr)
> +		goto out;
> +
> +	dax_region =3D dax_dev->region;
> +	align =3D dax_region->align;
> +	off =3D pgoff << PAGE_SHIFT;
> +	off_end =3D off + len;
> +	off_align =3D round_up(off, align);
> +
> +	if ((off_end <=3D off_align) || ((off_end - off_align) < align))
> +		goto out;
> +
> +	len_align =3D len + align;
> +	if ((off + len_align) < off)
> +		goto out;
> +
> +	addr_align =3D current->mm->get_unmapped_area(filp, addr, len_align,
> +			pgoff, flags);
> +	if (!IS_ERR_VALUE(addr_align)) {
> +		addr_align +=3D (off - addr_align) & (align - 1);
> +		return addr_align;
> +	}
> + out:
> +	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
> +}
> +
> +static int __match_devt(struct device *dev, const void *data)
> +{
> +	const dev_t *devt =3D data;
> +
> +	return dev->devt =3D=3D *devt;
> +}
> +
> +static struct device *dax_dev_find(dev_t dev_t)
> +{
> +	return class_find_device(dax_class, NULL, &dev_t, __match_devt);
> +}
> +
> +static int dax_dev_open(struct inode *inode, struct file *filp)
> +{
> +	struct dax_dev *dax_dev =3D NULL;
> +	struct device *dev;
> +
> +	dev =3D dax_dev_find(inode->i_rdev);
> +	if (!dev)
> +		return -ENXIO;
> +
> +	device_lock(dev);
> +	dax_dev =3D dev_get_drvdata(dev);
> +	if (dax_dev) {
> +		dev_dbg(dev, "%s\n", __func__);
> +		filp->private_data =3D dax_dev;
> +		kref_get(&dax_dev->kref);
> +		inode->i_flags =3D S_DAX;
> +	}
> +	device_unlock(dev);
> +

Does this block really need to be protected by the dev mutex? If yes, have =
you
considered re-ordering it like this?

	device_lock(dev);
	dax_dev =3D dev_get_drvdata(dev);
	if (!dax_dev) {
		device_unlock(dev);
		goto out_put;
	}
	filp->private_data =3D dax_dev;
	kref_get(&dax_dev->kref); // or get_dax_device(dax_dev)
	inode->i_flags =3D S_DAX;
	device_unlock(dev);

	return 0;

out_put:
	put_device(dev);
	return -ENXIO;

The only thing I see that could be needed to be protected here, is the
inode->i_flags and shouldn't that be protected by the inode->i_mutex? But I=
'm
not sure, hence the question. Also S_DAX is the only valid flag for a DAX
device, isn't it?

> +	if (!dax_dev) {
> +		put_device(dev);
> +		return -ENXIO;
> +	}
> +	return 0;
> +}
> +
> +static int dax_dev_release(struct inode *inode, struct file *filp)
> +{
> +	struct dax_dev *dax_dev =3D filp->private_data;
> +	struct device *dev =3D dax_dev->dev;
> +
> +	dev_dbg(dax_dev->dev, "%s\n", __func__);
> +	dax_dev_put(dax_dev);
> +	put_device(dev);
> +

For reasons of consistency one could reset the inode's i_flags here.

> +	return 0;
> +}
> +
> +static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
> +		const char *func)
> +{
> +	struct dax_region *dax_region =3D dax_dev->region;
> +	struct device *dev =3D dax_dev->dev;
> +	unsigned long mask;
> +
> +	if (!dax_dev->alive)
> +		return -ENXIO;
> +
> +	/* prevent private / writable mappings from being established */
> +	if ((vma->vm_flags & (VM_NORESERVE|VM_SHARED|VM_WRITE)) =3D=3D VM_WRITE=
) {
> +		dev_dbg(dev, "%s: %s: fail, attempted private mapping\n",
> +				current->comm, func);

This deserves a higher log-level than debug, IMHO.

> +		return -EINVAL;
> +	}
> +
> +	mask =3D dax_region->align - 1;
> +	if (vma->vm_start & mask || vma->vm_end & mask) {
> +		dev_dbg(dev, "%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
> +				current->comm, func, vma->vm_start, vma->vm_end,
> +				mask);

Ditto.

> +		return -EINVAL;
> +	}
> +
> +	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) =3D=3D PFN_DEV
> +			&& (vma->vm_flags & VM_DONTCOPY) =3D=3D 0) {
> +		dev_dbg(dev, "%s: %s: fail, dax range requires MADV_DONTFORK\n",
> +				current->comm, func);

Ditto.

> +		return -EINVAL;
> +	}
> +
> +	if (!vma_is_dax(vma)) {
> +		dev_dbg(dev, "%s: %s: fail, vma is not DAX capable\n",
> +				current->comm, func);

Ditto.

> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
> +		unsigned long size)
> +{
> +	struct resource *res;
> +	phys_addr_t phys;
> +	int i;
> +
> +	for (i =3D 0; i < dax_dev->num_resources; i++) {
> +		res =3D &dax_dev->res[i];
> +		phys =3D pgoff * PAGE_SIZE + res->start;
> +		if (phys >=3D res->start && phys <=3D res->end)
> +			break;
> +		pgoff -=3D PHYS_PFN(resource_size(res));
> +	}
> +
> +	if (i < dax_dev->num_resources) {
> +		res =3D &dax_dev->res[i];
> +		if (phys + size - 1 <=3D res->end)
> +			return phys;
> +	}
> +
> +	return -1;
> +}
> +
> +static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struc=
t *vma,
> +		struct vm_fault *vmf)
> +{
> +	unsigned long vaddr =3D (unsigned long) vmf->virtual_address;
> +	struct device *dev =3D dax_dev->dev;
> +	struct dax_region *dax_region;
> +	int rc =3D VM_FAULT_SIGBUS;
> +	phys_addr_t phys;
> +	pfn_t pfn;
> +
> +	if (check_vma(dax_dev, vma, __func__))
> +		return VM_FAULT_SIGBUS;
> +
> +	dax_region =3D dax_dev->region;
> +	if (dax_region->align > PAGE_SIZE) {
> +		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	phys =3D pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
> +	if (phys =3D=3D -1) {
> +		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
> +				vmf->pgoff);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	pfn =3D phys_to_pfn_t(phys, dax_region->pfn_flags);
> +
> +	rc =3D vm_insert_mixed(vma, vaddr, pfn);
> +
> +	if (rc =3D=3D -ENOMEM)
> +		return VM_FAULT_OOM;
> +	if (rc < 0 && rc !=3D -EBUSY)
> +		return VM_FAULT_SIGBUS;
> +
> +	return VM_FAULT_NOPAGE;
> +}
> +
> +static int dax_dev_fault(struct vm_area_struct *vma, struct vm_fault *vm=
f)
> +{
> +	int rc;
> +	struct file *filp =3D vma->vm_file;
> +	struct dax_dev *dax_dev =3D filp->private_data;
> +
> +	dev_dbg(dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
> +			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
> +			? "write" : "read", vma->vm_start, vma->vm_end);
> +	rcu_read_lock();
> +	rc =3D __dax_dev_fault(dax_dev, vma, vmf);
> +	rcu_read_unlock();

Similarly, what are you protecting? I just see you're locking something to =
be
read, but don't do a rcu_dereference() to actually access a rcu protected
pointer. Or am I missing something totally here?

> +
> +	return rc;
> +}
> +
> +static int __dax_dev_pmd_fault(struct dax_dev *dax_dev,
> +		struct vm_area_struct *vma, unsigned long addr, pmd_t *pmd,
> +		unsigned int flags)
> +{
> +	unsigned long pmd_addr =3D addr & PMD_MASK;
> +	struct device *dev =3D dax_dev->dev;
> +	struct dax_region *dax_region;
> +	phys_addr_t phys;
> +	pgoff_t pgoff;
> +	pfn_t pfn;
> +
> +	if (check_vma(dax_dev, vma, __func__))
> +		return VM_FAULT_SIGBUS;
> +
> +	dax_region =3D dax_dev->region;
> +	if (dax_region->align > PMD_SIZE) {
> +		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	/* dax pmd mappings require pfn_t_devmap() */
> +	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) !=3D (PFN_DEV|PFN_MAP))=
 {
> +		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	pgoff =3D linear_page_index(vma, pmd_addr);
> +	phys =3D pgoff_to_phys(dax_dev, pgoff, PAGE_SIZE);
> +	if (phys =3D=3D -1) {
> +		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
> +				pgoff);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	pfn =3D phys_to_pfn_t(phys, dax_region->pfn_flags);
> +
> +	return vmf_insert_pfn_pmd(vma, addr, pmd, pfn,
> +			flags & FAULT_FLAG_WRITE);
> +}
> +
> +static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long a=
ddr,
> +		pmd_t *pmd, unsigned int flags)
> +{
> +	int rc;
> +	struct file *filp =3D vma->vm_file;
> +	struct dax_dev *dax_dev =3D filp->private_data;
> +
> +	dev_dbg(dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
> +			current->comm, (flags & FAULT_FLAG_WRITE)
> +			? "write" : "read", vma->vm_start, vma->vm_end);
> +
> +	rcu_read_lock();
> +	rc =3D __dax_dev_pmd_fault(dax_dev, vma, addr, pmd, flags);
> +	rcu_read_unlock();
> +
> +	return rc;
> +}
> +
> +static void dax_dev_vm_open(struct vm_area_struct *vma)
> +{
> +	struct file *filp =3D vma->vm_file;
> +	struct dax_dev *dax_dev =3D filp->private_data;
> +
> +	dev_dbg(dax_dev->dev, "%s\n", __func__);
> +	kref_get(&dax_dev->kref);
> +}
> +
> +static void dax_dev_vm_close(struct vm_area_struct *vma)
> +{
> +	struct file *filp =3D vma->vm_file;
> +	struct dax_dev *dax_dev =3D filp->private_data;
> +
> +	dev_dbg(dax_dev->dev, "%s\n", __func__);
> +	dax_dev_put(dax_dev);
> +}
> +
> +static const struct vm_operations_struct dax_dev_vm_ops =3D {
> +	.fault =3D dax_dev_fault,
> +	.pmd_fault =3D dax_dev_pmd_fault,
> +	.open =3D dax_dev_vm_open,
> +	.close =3D dax_dev_vm_close,
> +};
> +
> +static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct dax_dev *dax_dev =3D filp->private_data;
> +	int rc;
> +
> +	dev_dbg(dax_dev->dev, "%s\n", __func__);
> +
> +	rc =3D check_vma(dax_dev, vma, __func__);
> +	if (rc)
> +		return rc;
> +
> +	kref_get(&dax_dev->kref);
> +	vma->vm_ops =3D &dax_dev_vm_ops;
> +	vma->vm_flags |=3D VM_MIXEDMAP | VM_HUGEPAGE;
> +	return 0;
> +
> +}
> +
>  static const struct file_operations dax_fops =3D {
>  	.llseek =3D noop_llseek,
>  	.owner =3D THIS_MODULE,
> +	.open =3D dax_dev_open,
> +	.release =3D dax_dev_release,
> +	.get_unmapped_area =3D dax_dev_get_unmapped_area,
> +	.mmap =3D dax_dev_mmap,
>  };
>  =

>  static int __init dax_init(void)
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 86f9f8b82f8e..52ea012d8a80 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1013,6 +1013,7 @@ int vmf_insert_pfn_pmd(struct vm_area_struct *vma, =
unsigned long addr,
>  	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
>  	return VM_FAULT_NOPAGE;
>  }
> +EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
>  =

>  static void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>  		pmd_t *pmd)
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 19d0d08b396f..b14e98129b07 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -624,6 +624,7 @@ pgoff_t linear_hugepage_index(struct vm_area_struct *=
vma,
>  {
>  	return vma_hugecache_offset(hstate_vma(vma), vma, address);
>  }
> +EXPORT_SYMBOL_GPL(linear_hugepage_index);
>  =

>  /*
>   * Return the size of the pages allocated when backing a VMA. In the maj=
ority
> =

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
