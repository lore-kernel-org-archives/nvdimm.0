Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39D38223972B6
 for <linux-nvdimm@lists.01.org>; Tue,  6 Feb 2018 07:04:09 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id 8so1546156oix.7
 for <linux-nvdimm@lists.01.org>; Tue, 06 Feb 2018 07:09:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180206075337.yzzziohvv6qc6t7y@hz-desktop>
References: <151778551496.7139.17808629759104553625.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151778553083.7139.6601964812589807125.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180206075337.yzzziohvv6qc6t7y@hz-desktop>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Feb 2018 07:09:50 -0800
Message-ID: <CAPcyv4iVcukZSermEk9V=nZtzpZF_ghXzoQVMJJXpO_Vo2_19g@mail.gmail.com>
Subject: Re: [PATCH 3/3] vfio: disable filesystem-dax page pinning
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
To: Dan Williams <dan.j.williams@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, linux-nvdimm@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 5, 2018 at 11:53 PM, Haozhong Zhang
<haozhong.zhang@intel.com> wrote:
> Hi Dan,
>
> On 02/04/18 15:05 -0800, Dan Williams wrote:
>> Filesystem-DAX is incompatible with 'longterm' page pinning. Without
>> page cache indirection a DAX mapping maps filesystem blocks directly.
>> This means that the filesystem must not modify a file's block map while
>> any page in a mapping is pinned. In order to prevent the situation of
>> userspace holding of filesystem operations indefinitely, disallow
>> 'longterm' Filesystem-DAX mappings.
>>
>> RDMA has the same conflict and the plan there is to add a 'with lease'
>> mechanism to allow the kernel to notify userspace that the mapping is
>> being torn down for block-map maintenance. Perhaps something similar can
>> be put in place for vfio.
>>
>> Note that xfs and ext4 still report:
>>
>>    "DAX enabled. Warning: EXPERIMENTAL, use at your own risk"
>>
>> ...at mount time, and resolving the dax-dma-vs-truncate problem is one
>> of the last hurdles to remove that designation.
>>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: kvm@vger.kernel.org
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Haozhong Zhang <haozhong.zhang@intel.com>
>> Fixes: d475c6346a38 ("dax,ext2: replace XIP read and write with DAX I/O")
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c |   18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index e30e29ae4819..45657e2b1ff7 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -338,11 +338,12 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>>  {
>>       struct page *page[1];
>>       struct vm_area_struct *vma;
>> +     struct vm_area_struct *vmas[1];
>>       int ret;
>>
>>       if (mm == current->mm) {
>> -             ret = get_user_pages_fast(vaddr, 1, !!(prot & IOMMU_WRITE),
>> -                                       page);
>> +             ret = get_user_pages_longterm(vaddr, 1, !!(prot & IOMMU_WRITE),
>> +                                           page, vmas);
>>       } else {
>>               unsigned int flags = 0;
>>
>> @@ -351,7 +352,18 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>>
>>               down_read(&mm->mmap_sem);
>>               ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
>> -                                         NULL, NULL);
>> +                                         vmas, NULL);
>> +             /*
>> +              * The lifetime of a vaddr_get_pfn() page pin is
>> +              * userspace-controlled. In the fs-dax case this could
>> +              * lead to indefinite stalls in filesystem operations.
>> +              * Disallow attempts to pin fs-dax pages via this
>> +              * interface.
>> +              */
>> +             if (ret > 0 && vma_is_fsdax(vmas[0])) {
>> +                     ret = -EOPNOTSUPP;
>> +                     put_page(page[0]);
>> +             }
>>               up_read(&mm->mmap_sem);
>>       }
>>
>>
>
> Besides this patch series, are there other patches needed to make
> vma_is_fsdax() to work with device-dax?
>
> I applied this patch series on the libvdimm-for-next branch of nvdimm
> tree (ee95f4059a83), and found this patch series also failed
> device-dax mapping with vfio. It can be reproduced by following steps:
>
> 1. Attach PCI device at BDF 0000:03:10.2 to vfio-pci.
>    # modprobe vfio-pci
>    # lspci -n -s 0000:03:10.2
>    03:10.2 0200: 8086:1515 (rev 01)
>    # echo 0000:03:10.2 > /sys/bus/pci/devices/0000:06:0d.0/driver/unbind
>    # echo 8086:1515 > /sys/bus/pci/drivers/vfio-pci/new_id
>
> 2. Use RAM to emulate NVDIMM and create a device-dax device /dev/dax0.0
>    # cat /proc/iomem
>    ...
>    100000000-2ffffffff : Persistent Memory (legacy)
>      100000000-2ffffffff : namespace0.0
>    ...
>
>    # ndctl create-namespace -f -e namespace0.0 -m dax
>    {
>      "dev":"namespace0.0",
>      "mode":"dax",
>      "size":8453619712,
>      "uuid":"e1db00bc-f830-4f1b-ac18-091ae7df4f93",
>      "daxdevs":[
>        {
>          "chardev":"dax0.0",
>          "size":8453619712
>        }
>      ]
>    }
>
> 3. Create a VM with assigned PCI device in step 1 and the device-dax
>    device in step 2.
>    # qemu-system-x86_64 -machine pc,accel=kvm,nvdimm=on -smp host \
>                         -m 4G,slots=32,maxmem=128G \
>                         -drive file=VM_DISK_IMG.img,format=raw,if=virtio \
>                         -object memory-backend-file,id=nv_be1,share=on,mem-path=/dev/dax0.0,size=4G,align=2M \
>                         -device nvdimm,id=nv1,memdev=nv_be1 \
>                         -device ioh3420,id=root.0,slot=4 \
>                         -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:03:10.2,id=nic1,bus=pci.0,addr=0x6
>
>    It then fails with the following QEMU error messages:
>      qemu-system-x86_64: -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:03:10.2,id=nic1,bus=pci.0,addr=0x6: VFIO_MAP_DMA: -95
>      qemu-system-x86_64: -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:03:10.2,id=nic1,bus=pci.0,addr=0x6: vfio_dma_map(0x5643804a92c0, 0x140000000, 0xffe00000, 0x7f2ed5200000) = -95 (Operation not supported)
>      qemu-system-x86_64: -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:03:10.2,id=nic1,bus=pci.0,addr=0x6: vfio error: 0000:03:10.2: failed to setup container for group 52: memory listener initialization failed for container: Operation not supported
>
>    I added the following debug messages after the
>    get_user_pages_longterm() call in this patch,
>        if (vmas[0] && vma_is_dax(vmas[0]))
>                printk(KERN_DEBUG "%s: longterm failed for pfn 0x%lx, ret %d\n",
>                       __func__, page_to_pfn(page[0]), ret);
>    and shows get_user_pages_longterm() returns -EOPNOTSUPP on the
>    first device-dax page mapping.

Thanks for that thorough debug, I'll take a look today.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
