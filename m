Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA4D3FC2
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 05:59:23 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Av3bKo6+lGvzi65jTQ4Nuk+DkI+orL9Y04lQ7?=
 =?us-ascii?q?vn2ZKCYlFvBw8vrCoB1173HJYUkqMk3I9ergBEDiewK4yXcW2/hzAV7KZmCP11?=
 =?us-ascii?q?dAR7sSj7cKrQeBJwTOssZZ1YpFN5N1EcDMCzFB5vrS0U2VFMkBzbC8nJyVuQ?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="113175255"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 20 Aug 2021 13:59:13 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id 20B0E4D0D9CC;
	Fri, 20 Aug 2021 13:59:12 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 13:59:06 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 13:59:06 +0800
Received: from irides.mr (10.167.225.141) by G08CNEXCHPEKD09.g08.fujitsu.local
 (10.167.33.209) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Fri, 20 Aug 2021 13:59:05 +0800
Subject: Re: [PATCH v7 2/8] fsdax: Introduce dax_iomap_cow_copy()
To: Dan Williams <dan.j.williams@intel.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-3-ruansy.fnst@fujitsu.com>
 <CAPcyv4h0dukvcxN4Bc5a-jHk2FQ-j7ay9P1AB0wq9pNNSBU8-A@mail.gmail.com>
From: ruansy.fnst <ruansy.fnst@fujitsu.com>
Message-ID: <052a38ba-9c47-fc0a-61bf-6e6c8765ca8b@fujitsu.com>
Date: Fri, 20 Aug 2021 13:59:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h0dukvcxN4Bc5a-jHk2FQ-j7ay9P1AB0wq9pNNSBU8-A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 20B0E4D0D9CC.A3716
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



On 2021/8/20 上午6:35, Dan Williams wrote:
> On Sun, Aug 15, 2021 at 11:04 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>> In the case where the iomap is a write operation and iomap is not equal
>> to srcmap after iomap_begin, we consider it is a CoW operation.
>>
>> The destance extent which iomap indicated is new allocated extent.
> 
> s/destance/destination/
> 
> That sentence is still hard to grok though, did it mean to say:
> 
> "In this case, the destination (iomap->addr) points to a newly
> allocated extent."
> 
>> So, it is needed to copy the data from srcmap to new allocated extent.
>> In theory, it is better to copy the head and tail ranges which is
>> outside of the non-aligned area instead of copying the whole aligned
>> range. But in dax page fault, it will always be an aligned range.  So,
>> we have to copy the whole range in this case.
> 
> s/we have to copy/copy/
> 
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/dax.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 84 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 9fb6218f42be..697a7b7bb96f 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -1050,6 +1050,61 @@ static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
>>          return rc;
>>   }
>>
>> +/**
>> + * dax_iomap_cow_copy(): Copy the data from source to destination before write.
> 
> s/():/() -/
> 
> ...to be kernel-doc compliant
> 
>> + * @pos:       address to do copy from.
>> + * @length:    size of copy operation.
>> + * @align_size:        aligned w.r.t align_size (either PMD_SIZE or PAGE_SIZE)
>> + * @srcmap:    iomap srcmap
>> + * @daddr:     destination address to copy to.
>> + *
>> + * This can be called from two places. Either during DAX write fault, to copy
>> + * the length size data to daddr. Or, while doing normal DAX write operation,
>> + * dax_iomap_actor() might call this to do the copy of either start or end
>> + * unaligned address. In this case the rest of the copy of aligned ranges is
> 
> Which "this", the latter, or the former? Looks like the latter.
> 
> "In the latter case the rest of the copy..."
> 
>> + * taken care by dax_iomap_actor() itself.
>> + * Also, note DAX fault will always result in aligned pos and pos + length.
> 
> Perhaps drop this sentence and just say:
> 
> "Either during DAX write fault (page aligned), to copy..."
> 
> ...in that earlier sentence so this comment flows better.
> 
>> + */
>> +static int dax_iomap_cow_copy(loff_t pos, uint64_t length, size_t align_size,
>> +               const struct iomap *srcmap, void *daddr)
>> +{
>> +       loff_t head_off = pos & (align_size - 1);
>> +       size_t size = ALIGN(head_off + length, align_size);
>> +       loff_t end = pos + length;
>> +       loff_t pg_end = round_up(end, align_size);
>> +       bool copy_all = head_off == 0 && end == pg_end;
>> +       void *saddr = 0;
>> +       int ret = 0;
>> +
>> +       ret = dax_iomap_direct_access(srcmap, pos, size, &saddr, NULL);
>> +       if (ret)
>> +               return ret;
>> +
>> +       if (copy_all) {
>> +               ret = copy_mc_to_kernel(daddr, saddr, length);
>> +               return ret ? -EIO : 0;
>> +       }
>> +
>> +       /* Copy the head part of the range.  Note: we pass offset as length. */
> 
> I've re-read this a few times and this comment is not helping, why is
> the offset used as the copy length?

I forgot to update the comment.  It should be 'head_off', which is 
passed as the length for copy_mc_to_kernel().  It is the head part we 
need to COPY before write.

--
Thanks,
Ruan.

> 
>> +       if (head_off) {
>> +               ret = copy_mc_to_kernel(daddr, saddr, head_off);
>> +               if (ret)
>> +                       return -EIO;
>> +       }
>> +
>> +       /* Copy the tail part of the range */
>> +       if (end < pg_end) {
>> +               loff_t tail_off = head_off + length;
>> +               loff_t tail_len = pg_end - end;
>> +
>> +               ret = copy_mc_to_kernel(daddr + tail_off, saddr + tail_off,
>> +                                       tail_len);
>> +               if (ret)
>> +                       return -EIO;
>> +       }
>> +       return 0;
>> +}
>> +
>>   /*
>>    * The user has performed a load from a hole in the file.  Allocating a new
>>    * page in the file would cause excessive storage usage for workloads with
>> @@ -1175,16 +1230,18 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>                  struct iov_iter *iter)
>>   {
>>          const struct iomap *iomap = &iomi->iomap;
>> +       const struct iomap *srcmap = &iomi->srcmap;
>>          loff_t length = iomap_length(iomi);
>>          loff_t pos = iomi->pos;
>>          struct block_device *bdev = iomap->bdev;
>>          struct dax_device *dax_dev = iomap->dax_dev;
>>          loff_t end = pos + length, done = 0;
>> +       bool write = iov_iter_rw(iter) == WRITE;
>>          ssize_t ret = 0;
>>          size_t xfer;
>>          int id;
>>
>> -       if (iov_iter_rw(iter) == READ) {
>> +       if (!write) {
>>                  end = min(end, i_size_read(iomi->inode));
>>                  if (pos >= end)
>>                          return 0;
>> @@ -1193,7 +1250,12 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>                          return iov_iter_zero(min(length, end - pos), iter);
>>          }
>>
>> -       if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
>> +       /*
>> +        * In DAX mode, we allow either pure overwrites of written extents, or
> 
> s/we allow/enforce/
> 
>> +        * writes to unwritten extents as part of a copy-on-write operation.
>> +        */
>> +       if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED &&
>> +                       !(iomap->flags & IOMAP_F_SHARED)))
>>                  return -EIO;
>>
>>          /*
>> @@ -1232,6 +1294,14 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>                          break;
>>                  }
>>
>> +               if (write &&
>> +                   srcmap->addr != IOMAP_HOLE && srcmap->addr != iomap->addr) {
>> +                       ret = dax_iomap_cow_copy(pos, length, PAGE_SIZE, srcmap,
>> +                                                kaddr);
>> +                       if (ret)
>> +                               break;
>> +               }
>> +
>>                  map_len = PFN_PHYS(map_len);
>>                  kaddr += offset;
>>                  map_len -= offset;
>> @@ -1243,7 +1313,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>                   * validated via access_ok() in either vfs_read() or
>>                   * vfs_write(), depending on which operation we are doing.
>>                   */
>> -               if (iov_iter_rw(iter) == WRITE)
>> +               if (write)
>>                          xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
>>                                          map_len, iter);
>>                  else
>> @@ -1385,6 +1455,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
>>   {
>>          struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>>          const struct iomap *iomap = &iter->iomap;
>> +       const struct iomap *srcmap = &iter->srcmap;
>>          size_t size = pmd ? PMD_SIZE : PAGE_SIZE;
>>          loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
>>          bool write = vmf->flags & FAULT_FLAG_WRITE;
>> @@ -1392,6 +1463,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
>>          unsigned long entry_flags = pmd ? DAX_PMD : 0;
>>          int err = 0;
>>          pfn_t pfn;
>> +       void *kaddr;
>>
>>          if (!pmd && vmf->cow_page)
>>                  return dax_fault_cow_page(vmf, iter);
>> @@ -1404,18 +1476,25 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
>>                  return dax_pmd_load_hole(xas, vmf, iomap, entry);
>>          }
>>
>> -       if (iomap->type != IOMAP_MAPPED) {
>> +       if (iomap->type != IOMAP_MAPPED && !(iomap->flags & IOMAP_F_SHARED)) {
>>                  WARN_ON_ONCE(1);
>>                  return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
>>          }
>>
>> -       err = dax_iomap_direct_access(&iter->iomap, pos, size, NULL, &pfn);
>> +       err = dax_iomap_direct_access(iomap, pos, size, &kaddr, &pfn);
>>          if (err)
>>                  return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
>>
>>          *entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn, entry_flags,
>>                                    write && !sync);
>>
>> +       if (write &&
>> +           srcmap->addr != IOMAP_HOLE && srcmap->addr != iomap->addr) {
>> +               err = dax_iomap_cow_copy(pos, size, size, srcmap, kaddr);
>> +               if (err)
>> +                       return dax_fault_return(err);
>> +       }
>> +
>>          if (sync)
>>                  return dax_fault_synchronous_pfnp(pfnp, pfn);
>>
>> --
>> 2.32.0
>>
>>
>>


