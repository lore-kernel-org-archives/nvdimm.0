Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1438123889.2459.0.camel@linux.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150725023940.8664.2784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1438123889.2459.0.camel@linux.intel.com>
Date: Tue, 28 Jul 2015 16:06:54 -0700
Message-ID: <CAPcyv4iz=y8HhAx4SnFAhO9At636B-B7tPuUKaBySZ8FZ27oyA@mail.gmail.com>
Subject: Re: [PATCH v2 18/25] libnvdimm, pmem: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 28, 2015 at 3:51 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, 2015-07-24 at 22:39 -0400, Dan Williams wrote:
>> In preparation for deprecating ioremap_cache() convert its usage in
>> libnvdimm and the PMEM API to memremap.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/x86/include/asm/io.h         |    7 +------
>>  arch/x86/mm/ioremap.c             |    6 ++++++
>>  tools/testing/nvdimm/Kbuild       |    2 +-
>>  tools/testing/nvdimm/test/iomap.c |    6 +++---
>>  4 files changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>> index cc9c61bc1abe..8aeb6456188a 100644
>> --- a/arch/x86/include/asm/io.h
>> +++ b/arch/x86/include/asm/io.h
>> @@ -248,12 +248,7 @@ static inline void flush_write_buffers(void)
>>  #endif
>>  }
>>
>> -static inline void __pmem *arch_memremap_pmem(resource_size_t offset,
>> -     unsigned long size)
>> -{
>> -     return (void __force __pmem *) ioremap_cache(offset, size);
>> -}
>> -
>> +void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size);
>>  #endif /* __KERNEL__ */
>>
>>  extern void native_io_delay(void);
>> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
>> index 6f759c7c2ab7..7b422e7574b1 100644
>> --- a/arch/x86/mm/ioremap.c
>> +++ b/arch/x86/mm/ioremap.c
>> @@ -317,6 +317,12 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
>>  }
>>  EXPORT_SYMBOL(ioremap_cache);
>>
>> +void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size)
>> +{
>> +     return (void __force __pmem *) ioremap_cache(offset, size);
>
> Did you mean for this to be a call to memremap() instead of ioremap_cache()?

The ioremap_cache elimination comes in "[PATCH v2 25/25] pmem: convert
to generic memremap", but yeah I should update the changelog to
reflect this is more about pushing the calls to ioremap_cache() out of
line.  It would be circular at this point in the series to call back
out to memremap to have it turn around and call ioremap_cache again.
