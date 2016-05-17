Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A91DB1A1F89
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 15:20:04 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id x201so48477483oif.3
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 15:19:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160517105711.GA3333@c203.arch.suse.de>
References: <146329357870.17948.14240958684074905846.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146329358943.17948.12857084981536373315.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160517105711.GA3333@c203.arch.suse.de>
Date: Tue, 17 May 2016 15:19:58 -0700
Message-ID: <CAPcyv4guFrgt8vROjPBYngBMSMF8_H3TY99vU93rG+VB+avOPQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] /dev/dax, core: file operations and dax-mmap
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 17, 2016 at 3:57 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Sat, May 14, 2016 at 11:26:29PM -0700, Dan Williams wrote:
>> The "Device DAX" core enables dax mappings of performance / feature
>> differentiated memory.  An open mapping or file handle keeps the backing
>> struct device live, but new mappings are only possible while the device
>> is enabled.   Faults are handled under rcu_read_lock to synchronize
>> with the enabled state of the device.
>>
>> Similar to the filesystem-dax case the backing memory may optionally
>> have struct page entries.  However, unlike fs-dax there is no support
>> for private mappings, or mappings that are not backed by media (see
>> use of zero-page in fs-dax).
>>
>> Mappings are always guaranteed to match the alignment of the dax_region.
>> If the dax_region is configured to have a 2MB alignment, all mappings
>> are guaranteed to be backed by a pmd entry.  Contrast this determinism
>> with the fs-dax case where pmd mappings are opportunistic.  If userspace
>> attempts to force a misaligned mapping, the driver will fail the mmap
>> attempt.  See dax_dev_check_vma() for other scenarios that are rejected,
>> like MAP_PRIVATE mappings.
>>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/dax/Kconfig |    1
>>  drivers/dax/dax.c   |  316 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  mm/huge_memory.c    |    1
>>  mm/hugetlb.c        |    1
>>  4 files changed, 319 insertions(+)
>>
>> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
>> index 86ffbaa891ad..cedab7572de3 100644
>> --- a/drivers/dax/Kconfig
>> +++ b/drivers/dax/Kconfig
>> @@ -1,6 +1,7 @@
>>  menuconfig DEV_DAX
>>       tristate "DAX: direct access to differentiated memory"
>>       default m if NVDIMM_DAX
>> +     depends on TRANSPARENT_HUGEPAGE
>>       help
>>         Support raw access to differentiated (persistence, bandwidth,
>>         latency...) memory via an mmap(2) capable character
>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>> index 8207fb33a992..b2fe8a0ce866 100644
>> --- a/drivers/dax/dax.c
>> +++ b/drivers/dax/dax.c
>> @@ -49,6 +49,7 @@ struct dax_region {
>>   * @region - parent region
>>   * @dev - device backing the character device
>>   * @kref - enable this data to be tracked in filp->private_data
>> + * @alive - !alive + rcu grace period == no new mappings can be established
>>   * @id - child id in the region
>>   * @num_resources - number of physical address extents in this device
>>   * @res - array of physical address ranges
>> @@ -57,6 +58,7 @@ struct dax_dev {
>>       struct dax_region *region;
>>       struct device *dev;
>>       struct kref kref;
>> +     bool alive;
>>       int id;
>>       int num_resources;
>>       struct resource res[0];
>> @@ -150,6 +152,10 @@ static void destroy_dax_dev(void *_dev)
>>
>>       dev_dbg(dev, "%s\n", __func__);
>>
>> +     /* disable and flush fault handlers, TODO unmap inodes */
>> +     dax_dev->alive = false;
>> +     synchronize_rcu();
>> +
>
> IIRC RCU is only protecting a pointer, not the content of the pointer, so this
> looks wrong to me.

The driver is using RCU to guarantee that all currently running fault
handlers have either completed or will see the new state of ->alive
when they start.  Reference counts are protecting the actual dax_dev
object.

>>       get_device(dev);
>>       device_unregister(dev);
>>       ida_simple_remove(&dax_region->ida, dax_dev->id);
>> @@ -173,6 +179,7 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
>>       memcpy(dax_dev->res, res, sizeof(*res) * count);
>>       dax_dev->num_resources = count;
>>       kref_init(&dax_dev->kref);
>> +     dax_dev->alive = true;
>>       dax_dev->region = dax_region;
>>       kref_get(&dax_region->kref);
>>
>> @@ -217,9 +224,318 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
>>  }
>>  EXPORT_SYMBOL_GPL(devm_create_dax_dev);
>>
>> +/* return an unmapped area aligned to the dax region specified alignment */
>> +static unsigned long dax_dev_get_unmapped_area(struct file *filp,
>> +             unsigned long addr, unsigned long len, unsigned long pgoff,
>> +             unsigned long flags)
>> +{
>> +     unsigned long off, off_end, off_align, len_align, addr_align, align;
>> +     struct dax_dev *dax_dev = filp ? filp->private_data : NULL;
>> +     struct dax_region *dax_region;
>> +
>> +     if (!dax_dev || addr)
>> +             goto out;
>> +
>> +     dax_region = dax_dev->region;
>> +     align = dax_region->align;
>> +     off = pgoff << PAGE_SHIFT;
>> +     off_end = off + len;
>> +     off_align = round_up(off, align);
>> +
>> +     if ((off_end <= off_align) || ((off_end - off_align) < align))
>> +             goto out;
>> +
>> +     len_align = len + align;
>> +     if ((off + len_align) < off)
>> +             goto out;
>> +
>> +     addr_align = current->mm->get_unmapped_area(filp, addr, len_align,
>> +                     pgoff, flags);
>> +     if (!IS_ERR_VALUE(addr_align)) {
>> +             addr_align += (off - addr_align) & (align - 1);
>> +             return addr_align;
>> +     }
>> + out:
>> +     return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
>> +}
>> +
>> +static int __match_devt(struct device *dev, const void *data)
>> +{
>> +     const dev_t *devt = data;
>> +
>> +     return dev->devt == *devt;
>> +}
>> +
>> +static struct device *dax_dev_find(dev_t dev_t)
>> +{
>> +     return class_find_device(dax_class, NULL, &dev_t, __match_devt);
>> +}
>> +
>> +static int dax_dev_open(struct inode *inode, struct file *filp)
>> +{
>> +     struct dax_dev *dax_dev = NULL;
>> +     struct device *dev;
>> +
>> +     dev = dax_dev_find(inode->i_rdev);
>> +     if (!dev)
>> +             return -ENXIO;
>> +
>> +     device_lock(dev);
>> +     dax_dev = dev_get_drvdata(dev);
>> +     if (dax_dev) {
>> +             dev_dbg(dev, "%s\n", __func__);
>> +             filp->private_data = dax_dev;
>> +             kref_get(&dax_dev->kref);
>> +             inode->i_flags = S_DAX;
>> +     }
>> +     device_unlock(dev);
>> +
>
> Does this block really need to be protected by the dev mutex? If yes, have you
> considered re-ordering it like this?

We need to make sure the dax_dev is not freed while we're trying to
take a reference against it, hence the lock.

>
>         device_lock(dev);
>         dax_dev = dev_get_drvdata(dev);
>         if (!dax_dev) {
>                 device_unlock(dev);
>                 goto out_put;
>         }
>         filp->private_data = dax_dev;
>         kref_get(&dax_dev->kref); // or get_dax_device(dax_dev)

dax_dev may already be invalid at this point if open() is racing
device_unregister().

>         inode->i_flags = S_DAX;
>         device_unlock(dev);
>
>         return 0;
>
> out_put:
>         put_device(dev);
>         return -ENXIO;
>
> The only thing I see that could be needed to be protected here, is the
> inode->i_flags and shouldn't that be protected by the inode->i_mutex? But I'm
> not sure, hence the question.

Nothing else should be mutating the inode flags so I don't think we
need protection.

> Also S_DAX is the only valid flag for a DAX
> device, isn't it?

Correct, we need that capability so that vma_is_dax() will recognize
these mappings.

>
>> +     if (!dax_dev) {
>> +             put_device(dev);
>> +             return -ENXIO;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static int dax_dev_release(struct inode *inode, struct file *filp)
>> +{
>> +     struct dax_dev *dax_dev = filp->private_data;
>> +     struct device *dev = dax_dev->dev;
>> +
>> +     dev_dbg(dax_dev->dev, "%s\n", __func__);
>> +     dax_dev_put(dax_dev);
>> +     put_device(dev);
>> +
>
> For reasons of consistency one could reset the inode's i_flags here.

That change seems like a bug to me, it doesn't stop being a dax inode
just because an open file is released, right?

>> +     return 0;
>> +}
>> +
>> +static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
>> +             const char *func)
>> +{
>> +     struct dax_region *dax_region = dax_dev->region;
>> +     struct device *dev = dax_dev->dev;
>> +     unsigned long mask;
>> +
>> +     if (!dax_dev->alive)
>> +             return -ENXIO;
>> +
>> +     /* prevent private / writable mappings from being established */
>> +     if ((vma->vm_flags & (VM_NORESERVE|VM_SHARED|VM_WRITE)) == VM_WRITE) {
>> +             dev_dbg(dev, "%s: %s: fail, attempted private mapping\n",
>> +                             current->comm, func);
>
> This deserves a higher log-level than debug, IMHO.
>
>> +             return -EINVAL;
>> +     }
>> +
>> +     mask = dax_region->align - 1;
>> +     if (vma->vm_start & mask || vma->vm_end & mask) {
>> +             dev_dbg(dev, "%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
>> +                             current->comm, func, vma->vm_start, vma->vm_end,
>> +                             mask);
>
> Ditto.
>
>> +             return -EINVAL;
>> +     }
>> +
>> +     if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) == PFN_DEV
>> +                     && (vma->vm_flags & VM_DONTCOPY) == 0) {
>> +             dev_dbg(dev, "%s: %s: fail, dax range requires MADV_DONTFORK\n",
>> +                             current->comm, func);
>
> Ditto.
>
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (!vma_is_dax(vma)) {
>> +             dev_dbg(dev, "%s: %s: fail, vma is not DAX capable\n",
>> +                             current->comm, func);
>
> Ditto.

Ok, will bump these up to dev_info.

>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
>> +             unsigned long size)
>> +{
>> +     struct resource *res;
>> +     phys_addr_t phys;
>> +     int i;
>> +
>> +     for (i = 0; i < dax_dev->num_resources; i++) {
>> +             res = &dax_dev->res[i];
>> +             phys = pgoff * PAGE_SIZE + res->start;
>> +             if (phys >= res->start && phys <= res->end)
>> +                     break;
>> +             pgoff -= PHYS_PFN(resource_size(res));
>> +     }
>> +
>> +     if (i < dax_dev->num_resources) {
>> +             res = &dax_dev->res[i];
>> +             if (phys + size - 1 <= res->end)
>> +                     return phys;
>> +     }
>> +
>> +     return -1;
>> +}
>> +
>> +static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
>> +             struct vm_fault *vmf)
>> +{
>> +     unsigned long vaddr = (unsigned long) vmf->virtual_address;
>> +     struct device *dev = dax_dev->dev;
>> +     struct dax_region *dax_region;
>> +     int rc = VM_FAULT_SIGBUS;
>> +     phys_addr_t phys;
>> +     pfn_t pfn;
>> +
>> +     if (check_vma(dax_dev, vma, __func__))
>> +             return VM_FAULT_SIGBUS;
>> +
>> +     dax_region = dax_dev->region;
>> +     if (dax_region->align > PAGE_SIZE) {
>> +             dev_dbg(dev, "%s: alignment > fault size\n", __func__);
>> +             return VM_FAULT_SIGBUS;
>> +     }
>> +
>> +     phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
>> +     if (phys == -1) {
>> +             dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
>> +                             vmf->pgoff);
>> +             return VM_FAULT_SIGBUS;
>> +     }
>> +
>> +     pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
>> +
>> +     rc = vm_insert_mixed(vma, vaddr, pfn);
>> +
>> +     if (rc == -ENOMEM)
>> +             return VM_FAULT_OOM;
>> +     if (rc < 0 && rc != -EBUSY)
>> +             return VM_FAULT_SIGBUS;
>> +
>> +     return VM_FAULT_NOPAGE;
>> +}
>> +
>> +static int dax_dev_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>> +{
>> +     int rc;
>> +     struct file *filp = vma->vm_file;
>> +     struct dax_dev *dax_dev = filp->private_data;
>> +
>> +     dev_dbg(dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
>> +                     current->comm, (vmf->flags & FAULT_FLAG_WRITE)
>> +                     ? "write" : "read", vma->vm_start, vma->vm_end);
>> +     rcu_read_lock();
>> +     rc = __dax_dev_fault(dax_dev, vma, vmf);
>> +     rcu_read_unlock();
>
> Similarly, what are you protecting? I just see you're locking something to be
> read, but don't do a rcu_dereference() to actually access a rcu protected
> pointer. Or am I missing something totally here?

Like I mentioned above, I'm protecting the fault handler vs shutdown.
I need this building-block-guarantee later when I go to fix the vfs to
unmap inodes on device-removal.  Same bug currently in filesystem-DAX
[1].

[1]: http://thread.gmane.org/gmane.linux.file-systems/103333/focus=72179

[..]

Thanks for the review Johannes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
