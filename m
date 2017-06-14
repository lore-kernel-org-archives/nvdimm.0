Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62E4B21A6F106
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 09:48:15 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id b6so3992499oia.1
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 09:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170614105425.GD21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170614105425.GD21506@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jun 2017 09:49:29 -0700
Message-ID: <CAPcyv4hNLkX9ct=Z9YQ8zaqAYPa_ab_+W+Z8By6=btJEkbrZag@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] x86, dax,
 libnvdimm: move wb_cache_pmem() to libnvdimm
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 14, 2017 at 3:54 AM, Jan Kara <jack@suse.cz> wrote:
> On Fri 09-06-17 13:24:29, Dan Williams wrote:
>> With all calls to this routine re-directed through the pmem driver, we can kill
>> the pmem api indirection. arch_wb_cache_pmem() is now optionally supplied by
>> the arch specific asm/pmem.h.  Same as before, pmem flushing is only defined
>> for x86_64, but it is straightforward to add other archs in the future.
>>
>> Cc: <x86@kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Oliver O'Halloran <oohall@gmail.com>
>> Cc: Matthew Wilcox <mawilcox@microsoft.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Looks good to me. Just one question below...
>
>> -/**
>> - * arch_wb_cache_pmem - write back a cache range with CLWB
>> - * @vaddr:   virtual start address
>> - * @size:    number of bytes to write back
>> - *
>> - * Write back a cache range using the CLWB (cache line write back)
>> - * instruction. Note that @size is internally rounded up to be cache
>> - * line size aligned.
>> - */
>>  static inline void arch_wb_cache_pmem(void *addr, size_t size)
>>  {
>> -     u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
>> -     unsigned long clflush_mask = x86_clflush_size - 1;
>> -     void *vend = addr + size;
>> -     void *p;
>> -
>> -     for (p = (void *)((unsigned long)addr & ~clflush_mask);
>> -          p < vend; p += x86_clflush_size)
>> -             clwb(p);
>> +     clean_cache_range(addr,size);
>>  }
>
> So this will make compilation break on 32-bit x86 as it does not define
> clean_cache_range(). Do we somewhere force we are on x86_64 when pmem is
> enabled?

Yes, this is enforced by:

    select ARCH_HAS_PMEM_API if X86_64

...in arch/x86/Kconfig. We fallback to a dummy arch_wb_cache_pmem()
implementation and emit this warning for !ARCH_HAS_PMEM_API archs:

    "nd_pmem namespace0.0: unable to guarantee persistence of writes"
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
