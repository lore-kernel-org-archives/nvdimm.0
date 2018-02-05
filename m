Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2CD4122364880
 for <linux-nvdimm@lists.01.org>; Sun,  4 Feb 2018 19:48:31 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id v5so25714367oth.5
 for <linux-nvdimm@lists.01.org>; Sun, 04 Feb 2018 19:54:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180205034653.mfnla2nq55ikkhav@hz-desktop>
References: <151778551496.7139.17808629759104553625.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151778553083.7139.6601964812589807125.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180205034653.mfnla2nq55ikkhav@hz-desktop>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 4 Feb 2018 19:54:11 -0800
Message-ID: <CAPcyv4iNk=mmyRak6tyDyvF8BzKqi+z-_-aTh8ZQBeAQe-Q7gw@mail.gmail.com>
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

On Sun, Feb 4, 2018 at 7:46 PM, Haozhong Zhang <haozhong.zhang@intel.com> wrote:
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
>
> vmas is not used subsequently if this branch is taken, so can we use
> NULL here?

I'd rather go the other way and refactor this a bit further to skip
the find_vma_intersection() below since get_user_pages() already does
that work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
