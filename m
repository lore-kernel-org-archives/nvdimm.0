Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A6BD21F0DB02
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 11:55:34 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id r30-v6so7468731otr.2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 12:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180329160215.glnrmyunujcc4vwg@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167306807.5268.8483232024444414342.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180329160215.glnrmyunujcc4vwg@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Mar 2018 12:02:13 -0700
Message-ID: <CAPcyv4h8CgZmiDLh5p8Vnt0SjB2FvZgGuRMZ+ZYRO=H3mkES_A@mail.gmail.com>
Subject: Re: [PATCH v7 07/14] fs, dax: use page->mapping to warn if truncate
 collides with a busy page
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
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 29, 2018 at 9:02 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 21-03-18 15:57:48, Dan Williams wrote:
>> Catch cases where extent unmap operations encounter pages that are
>> pinned / busy. Typically this is pinned pages that are under active dma.
>> This warning is a canary for potential data corruption as truncated
>> blocks could be allocated to a new file while the device is still
>> performing i/o.
>>
>> Here is an example of a collision that this implementation catches:
>>
>>  WARNING: CPU: 2 PID: 1286 at fs/dax.c:343 dax_disassociate_entry+0x55/0x80
>>  [..]
>>  Call Trace:
>>   __dax_invalidate_mapping_entry+0x6c/0xf0
>>   dax_delete_mapping_entry+0xf/0x20
>>   truncate_exceptional_pvec_entries.part.12+0x1af/0x200
>>   truncate_inode_pages_range+0x268/0x970
>>   ? tlb_gather_mmu+0x10/0x20
>>   ? up_write+0x1c/0x40
>>   ? unmap_mapping_range+0x73/0x140
>>   xfs_free_file_space+0x1b6/0x5b0 [xfs]
>>   ? xfs_file_fallocate+0x7f/0x320 [xfs]
>>   ? down_write_nested+0x40/0x70
>>   ? xfs_ilock+0x21d/0x2f0 [xfs]
>>   xfs_file_fallocate+0x162/0x320 [xfs]
>>   ? rcu_read_lock_sched_held+0x3f/0x70
>>   ? rcu_sync_lockdep_assert+0x2a/0x50
>>   ? __sb_start_write+0xd0/0x1b0
>>   ? vfs_fallocate+0x20c/0x270
>>   vfs_fallocate+0x154/0x270
>>   SyS_fallocate+0x43/0x80
>>   entry_SYSCALL_64_fastpath+0x1f/0x96
>>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Matthew Wilcox <mawilcox@microsoft.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Two comments when looking at this now:
>
>> +#define for_each_entry_pfn(entry, pfn, end_pfn) \
>> +     for (pfn = dax_radix_pfn(entry), \
>> +                     end_pfn = pfn + dax_entry_size(entry) / PAGE_SIZE; \
>> +                     pfn < end_pfn; \
>> +                     pfn++)
>
> Why don't you declare 'end_pfn' inside the for() block? That way you don't
> have to pass the variable as an argument to for_each_entry_pfn(). It's not
> like you need end_pfn anywhere in the loop body, you just use it to cache
> loop termination index.

Agreed, good catch.

>
>> @@ -547,6 +599,10 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
>>
>>       spin_lock_irq(&mapping->tree_lock);
>>       new_entry = dax_radix_locked_entry(pfn, flags);
>> +     if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
>> +             dax_disassociate_entry(entry, mapping, false);
>> +             dax_associate_entry(new_entry, mapping);
>> +     }
>
> I find it quite tricky that in case we pass zero page / empty entry into
> dax_[dis]associate_entry(), it will not do anything because
> dax_entry_size() will return 0. Can we add an explicit check into
> dax_[dis]associate_entry() or at least a comment there?

Ok, will do.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
