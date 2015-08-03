Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1438622487.9404.2.camel@linux.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150730165553.33962.20257.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1438622487.9404.2.camel@linux.intel.com>
Date: Mon, 3 Aug 2015 11:01:46 -0700
Message-ID: <CAPcyv4gCPyXwwgjidaUaNyNe8ZitmwVa-NF7pBT-y3rV4XBUzA@mail.gmail.com>
Subject: Re: [PATCH v3 24/24] pmem: convert to generic memremap
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Luis Rodriguez <mcgrof@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 3, 2015 at 10:21 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, 2015-07-30 at 12:55 -0400, Dan Williams wrote:
>> Update memremap_pmem() to query the architecture for the mapping type of
>> the given persistent memory range  and then pass those flags to generic
>> memremap().  arch_memremap_pmem_flags() is provided an address range to
>> evaluate in the event an arch has a need for different mapping types by
>> address range.  For example the ACPI NFIT carries EFI mapping types in
>> its memory range description table.
>>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/x86/include/asm/io.h |    2 +-
>>  arch/x86/mm/ioremap.c     |   16 ++++++++++------
>>  include/linux/pmem.h      |   26 +++++++++++++++-----------
>>  3 files changed, 26 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>> index 1a9d44ee9ed0..26c81b01419c 100644
>> --- a/arch/x86/include/asm/io.h
>> +++ b/arch/x86/include/asm/io.h
>> @@ -245,7 +245,7 @@ static inline void flush_write_buffers(void)
>>  #endif
>>  }
>>
>> -void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size);
>> +unsigned long arch_memremap_pmem_flags(resource_size_t offset, size_t size);
>>  #endif /* __KERNEL__ */
>>
>>  extern void native_io_delay(void);
>> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
>> index ffbfcf2e701b..5a41e3e4ea1e 100644
>> --- a/arch/x86/mm/ioremap.c
>> +++ b/arch/x86/mm/ioremap.c
>> @@ -205,6 +205,16 @@ err_free_memtype:
>>       return NULL;
>>  }
>>
>> +unsigned long arch_memremap_pmem_flags(resource_size_t offset, size_t size)
>> +{
>> +     /*
>> +      * TODO: check the mapping type provided by platform firmware,
>> +      * per range.
>> +      */
>> +     return MEMREMAP_WB;
>> +}
>> +EXPORT_SYMBOL(arch_memremap_pmem_flags);
>
> I'm not sure that the architecture code has the right information to be able
> to tell the caller what the correct mapping is.
>

It does in this instance as it has to pick a mapping type that is
compatible with memcpy_to_pmem() and wmb_pmem().

> I think what you are ultimately looking for is the "Address Range Memory
> Mapping Attribute" found in the System Physical Address Range Structure of the
> NFIT, right?  (ACPI 6.0, table 5-128)  How can we get to that structure from
> nfit-independent architecture code like arch_memremap_pmem_flags()?  It seems
> like that if we want to make the mapping type dynamic we should get the flags
> from ND when the SPA range is provided by ND, and provide a reasonable default
> (WB, it seems) when we are dealing with legacy PMEM?  If PMEM had the flag
> from whatever source, it could then pass it in to memremap_pmem(), and get a
> mapping of the appropriate caching.

We can do what ioremap() does and look it up through other means.

> Another option of course is to just ignore the mapping attribute in the NFIT
> like we've been doing, and just say "we know WB will be good enough", and
> remove the TODO.

I agree, but there may be a non-zero chance that a platform
implementation wants strict adherence.  Maybe move the TODO to a
dev_dbg() that flags platforms where the NFIT mapping type is not
"WB"?
