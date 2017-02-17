Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FA1482129
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 19:56:35 -0800 (PST)
Received: by mail-oi0-x235.google.com with SMTP id 62so5725973oih.2
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 19:56:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170217035233.GB27382@linux.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148488422955.37913.7723740119156814265.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170217035233.GB27382@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Feb 2017 19:56:34 -0800
Message-ID: <CAPcyv4h7CXenpDkb=d3RN8wo-rSfrQ_ioLoBPV3U+a_r3W9CEg@mail.gmail.com>
Subject: Re: [PATCH 03/13] x86, dax,
 pmem: introduce 'copy_from_iter' dax operation
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 16, 2017 at 7:52 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, Jan 19, 2017 at 07:50:29PM -0800, Dan Williams wrote:
>> The direct-I/O write path for a pmem device must ensure that data is flushed
>> to a power-fail safe zone when the operation is complete. However, other
>> dax capable block devices, like brd, do not have this requirement.
>> Introduce a 'copy_from_iter' dax operation so that pmem can inject
>> cache management without imposing this overhead on other dax capable
>> block_device drivers.
>>
>> Cc: <x86@kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Matthew Wilcox <mawilcox@microsoft.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/x86/include/asm/pmem.h |   31 -------------------------------
>>  drivers/nvdimm/pmem.c       |   10 ++++++++++
>>  fs/dax.c                    |   11 ++++++++++-
>>  include/linux/blkdev.h      |    1 +
>>  include/linux/pmem.h        |   24 ------------------------
>>  5 files changed, 21 insertions(+), 56 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
>> index f26ba430d853..0ca5e693f4a2 100644
>> --- a/arch/x86/include/asm/pmem.h
>> +++ b/arch/x86/include/asm/pmem.h
>> @@ -64,37 +64,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
>>               clwb(p);
>>  }
>>
>> -/*
>> - * copy_from_iter_nocache() on x86 only uses non-temporal stores for iovec
>> - * iterators, so for other types (bvec & kvec) we must do a cache write-back.
>> - */
>> -static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
>> -{
>> -     return iter_is_iovec(i) == false;
>> -}
>> -
>> -/**
>> - * arch_copy_from_iter_pmem - copy data from an iterator to PMEM
>> - * @addr:    PMEM destination address
>> - * @bytes:   number of bytes to copy
>> - * @i:               iterator with source data
>> - *
>> - * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
>> - */
>> -static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
>> -             struct iov_iter *i)
>> -{
>> -     size_t len;
>> -
>> -     /* TODO: skip the write-back by always using non-temporal stores */
>> -     len = copy_from_iter_nocache(addr, bytes, i);
>> -
>> -     if (__iter_needs_pmem_wb(i))
>> -             arch_wb_cache_pmem(addr, bytes);
>
> This writeback is no longer conditional in the pmem_copy_from_iter() version,
> which means that for iovec iterators you do a non-temporal store and then
> afterwards take the time to loop through and flush the cachelines?  This seems
> incorrect, and I wonder if this could be the cause of the performance
> regression reported by 0-day?

I'm pretty sure you're right. What I was planning for the next version
of this patch is to handle the unaligned case in the local assembly so
that we never need to do a flush loop after the fact.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
