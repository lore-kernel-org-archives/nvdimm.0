Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150730210204.GQ30479@wotan.suse.de>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150730165407.33962.79603.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150730210204.GQ30479@wotan.suse.de>
Date: Thu, 30 Jul 2015 14:11:37 -0700
Message-ID: <CAPcyv4iV79Em9umnc=L+M0HqRb1gtfZxj-A=0nbAh76ceYn_pg@mail.gmail.com>
Subject: Re: [PATCH v3 05/24] arch: introduce memremap()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, "Kani, Toshimitsu" <toshi.kani@hp.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 30, 2015 at 2:02 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Jul 30, 2015 at 12:54:07PM -0400, Dan Williams wrote:
>> diff --git a/include/linux/io.h b/include/linux/io.h
>> index fb5a99800e77..3fcf6256c088 100644
>> --- a/include/linux/io.h
>> +++ b/include/linux/io.h
>> @@ -121,4 +121,13 @@ static inline int arch_phys_wc_index(int handle)
>>  #endif
>>  #endif
>>
>> +enum {
>> +     /* See memremap() kernel-doc for usage description... */
>> +     MEMREMAP_WB = 1 << 0,
>> +     MEMREMAP_WT = 1 << 1,
>> +};
>
> Same feedback for enum nameing and also kdoc style.

I'm concerned documentation here has the possibility of getting out of
sync with the "source of truth" at the definition of memremap().  I
think it's better to have the documentation consolidated at it
implementation rather than its definition.

>
>> diff --git a/kernel/memremap.c b/kernel/memremap.c
>> new file mode 100644
>> index 000000000000..27637f42f30d
>> --- /dev/null
>> +++ b/kernel/memremap.c
>
> <-- ... -->
>
>> +/**
>> + * memremap() - remap an iomem_resource as cacheable memory
>> + * @offset: iomem resource start address
>> + * @size: size of remap
>> + * @flags: either MEMREMAP_WB or MEMREMAP_WT
>> + *
>> + * memremap() is "ioremap" for cases where it is known that the resource
>> + * being mapped does not have i/o side effects and the __iomem
>> + * annotation is not applicable.
>> + *
>> + * MEMREMAP_WB - matches the default mapping for "System RAM" on
>> + * the architecture.  This is usually a read-allocate write-back cache.
>> + * Morever, if MEMREMAP_WB is specified and the requested remap region is RAM
>> + * memremap() will bypass establishing a new mapping and instead return
>> + * a pointer into the direct map.
>> + *
>> + * MEMREMAP_WT - establish a mapping whereby writes either bypass the
>> + * cache or are written through to memory and never exist in a
>> + * cache-dirty state with respect to program visibility.  Attempts to
>> + * map "System RAM" with this mapping type will fail.
>
> Then you can extrend all this on kdoc on the enum.
>
>> + */
>> +void *memremap(resource_size_t offset, size_t size, unsigned long flags)
>> +{
>> +     int is_ram = region_intersects(offset, size, "System RAM");
>
> This could be the enum region_intersect_type, then if the region enum is
> extended you'd get a compiler error if one type was not handled.

This already does not handle the REGION_DISJOINT case explicitly, it's
implied by handling the other 2.  A compiler warning would be verbose
for not much benefit afaics.
