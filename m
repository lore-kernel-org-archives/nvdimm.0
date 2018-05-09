Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 232AA20348631
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 15:06:01 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id e80-v6so58834oig.11
 for <linux-nvdimm@lists.01.org>; Wed, 09 May 2018 15:06:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180509105619.e3go5wj63wmnvcxo@quack2.suse.cz>
References: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152461281488.17530.18202569789906788866.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180509105619.e3go5wj63wmnvcxo@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 May 2018 15:06:00 -0700
Message-ID: <CAPcyv4h1qaZnM_HgGfLS+A_zQFP5TP_VoJLtk=bpyAiiVD7knQ@mail.gmail.com>
Subject: Re: [PATCH v9 6/9] mm, fs,
 dax: handle layout changes to pinned dax mappings
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 9, 2018 at 3:56 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 24-04-18 16:33:35, Dan Williams wrote:
>> Background:
>>
>> get_user_pages() in the filesystem pins file backed memory pages for
>> access by devices performing dma. However, it only pins the memory pages
>> not the page-to-file offset association. If a file is truncated the
>> pages are mapped out of the file and dma may continue indefinitely into
>> a page that is owned by a device driver. This breaks coherency of the
>> file vs dma, but the assumption is that if userspace wants the
>> file-space truncated it does not matter what data is inbound from the
>> device, it is not relevant anymore. The only expectation is that dma can
>> safely continue while the filesystem reallocates the block(s).
>>
>> Problem:
>>
>> This expectation that dma can safely continue while the filesystem
>> changes the block map is broken by dax. With dax the target dma page
>> *is* the filesystem block. The model of leaving the page pinned for dma,
>> but truncating the file block out of the file, means that the filesytem
>> is free to reallocate a block under active dma to another file and now
>> the expected data-incoherency situation has turned into active
>> data-corruption.
>>
>> Solution:
>>
>> Defer all filesystem operations (fallocate(), truncate()) on a dax mode
>> file while any page/block in the file is under active dma. This solution
>> assumes that dma is transient. Cases where dma operations are known to
>> not be transient, like RDMA, have been explicitly disabled via
>> commits like 5f1d43de5416 "IB/core: disable memory registration of
>> filesystem-dax vmas".
>>
>> The dax_layout_busy_page() routine is called by filesystems with a lock
>> held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
>> The process of looking up a busy page invalidates all mappings
>> to trigger any subsequent get_user_pages() to block on i_mmap_lock.
>> The filesystem continues to call dax_layout_busy_page() until it finally
>> returns no more active pages. This approach assumes that the page
>> pinning is transient, if that assumption is violated the system would
>> have likely hung from the uncompleted I/O.
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Dave Chinner <david@fromorbit.com>
>> Cc: Matthew Wilcox <mawilcox@microsoft.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Reported-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> A few nits below. After fixing those feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
>> index 86b3806ea35b..89f21bd9da10 100644
>> --- a/drivers/dax/super.c
>> +++ b/drivers/dax/super.c
>> @@ -167,7 +167,7 @@ struct dax_device {
>>  #if IS_ENABLED(CONFIG_FS_DAX) && IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS)
>>  static void generic_dax_pagefree(struct page *page, void *data)
>>  {
>> -     /* TODO: wakeup page-idle waiters */
>> +     wake_up_var(&page->_refcount);
>>  }
>>
>>  static struct dax_device *__fs_dax_claim(struct dax_device *dax_dev,
>
> Why is this hunk in this patch? We don't wait for page refcount here. OTOH
> I agree I don't see much better patch to fold this into.

I had it here because this patch is the enabling point where
filesystems can start using dax_layout_busy_page(). Otherwise I could
move it to the first patch that introduces a wait_var_event() for this
wake-up, but that's an xfs patch and seems out of place. In other
words, theoretically someone could backport just to this point and go
enable another filesystem without worrying about the xfs changes.

>
>> diff --git a/fs/Kconfig b/fs/Kconfig
>> index 1e050e012eb9..c9acbf695ddd 100644
>> --- a/fs/Kconfig
>> +++ b/fs/Kconfig
>> @@ -40,6 +40,7 @@ config FS_DAX
>>       depends on !(ARM || MIPS || SPARC)
>>       select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
>>       select FS_IOMAP
>> +     select SRCU
>
> No need for this anymore I guess.

Yup, stale, removed.

>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 84dd2063ca3d..75ade7ebddb2 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/sched/signal.h>
>>  #include <linux/rwsem.h>
>>  #include <linux/hugetlb.h>
>> +#include <linux/dax.h>
>>
>>  #include <asm/mmu_context.h>
>>  #include <asm/pgtable.h>
>
> Why is this hunk here?

Also stale, and removed. It was there for the now removed dax_layout_lock().

Good catches, thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
