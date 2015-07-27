Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150727231755.GV30479@wotan.suse.de>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150725023842.8664.97620.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150727231755.GV30479@wotan.suse.de>
Date: Mon, 27 Jul 2015 16:31:09 -0700
Message-ID: <CAPcyv4i07wV1Mf1XCs-U98w979enk9PYKquh7CSMcJv0T1kH1Q@mail.gmail.com>
Subject: Re: [PATCH v2 08/25] arch: introduce memremap()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 27, 2015 at 4:17 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Fri, Jul 24, 2015 at 10:38:42PM -0400, Dan Williams wrote:
>> Existing users of ioremap_cache() are mapping memory that is known in
>> advance to not have i/o side effects.  These users are forced to cast
>> away the __iomem annotation, or otherwise neglect to fix the sparse
>> errors thrown when dereferencing pointers to this memory.  Provide
>> memremap() as a non __iomem annotated ioremap_*() in the case when
>> ioremap is otherwise a pointer to memory.
>
> Ok so a special use case.
>
>> Outside of ioremap() and
>> ioremap_nocache(), the expectation is that most calls to
>> ioremap_<type>() are seeking memory-like semantics (e.g.  speculative
>> reads, and prefetching permitted).  These callsites can be moved to
>> memremap() over time.
>
> Such memory-like smantics are not well defined yet and this has caused
> issues over expectations over a slew of APIs. As you note above
> your own defined 'semantics' so far for memremap are just that there are
> no i/o side effects, when the mapped memory is just a pointer to memory,
> as such I do not think its fair to set the excpectations that we'll
> switch all other ioremap_*() callers to the same memremap() API. Now,
> it may be a good idea to use something similar, ie, to pass flags,
> but setting the expectations outright to move to memremap() without having
> any agreement having been made over semantics seems uncalled for at this
> point in time, specially when you are noting that the expectations for
> both sets of calls are different.
>
> So perhaps:
>
> "
> Outside of ioremap() and ioremap_nocache(), all other ioremap_<type>()
> variant calls are seeking memory-like semantics (e.g.  speculative
> reads, and prefetching permitted) and all calls expecations currently
> differ depending on architecture. Once and if we get agreement on such
> semantics we may be able to move such ioremap_*() variant calls to
> a similar API where the semantics required are clearly spelled out
> and well defined and passed as arguments.

I still think ioremap_wc(), and now ioremap_uc(), are special and are
not obvious candidates for conversion to memremap().

> "
>
>> diff --git a/kernel/memremap.c b/kernel/memremap.c
>> new file mode 100644
>> index 000000000000..ba206fd11785
>> --- /dev/null
>> +++ b/kernel/memremap.c
>> @@ -0,0 +1,82 @@
>> +/*
>> + * Copyright(c) 2015 Intel Corporation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +#include <linux/types.h>
>> +#include <linux/io.h>
>> +#include <linux/mm.h>
>> +
>> +#ifndef ioremap_cache
>> +/* temporary while we convert existing ioremap_cache users to memremap */
>> +__weak void __iomem *ioremap_cache(resource_size_t offset, unsigned long size)
>> +{
>> +     return ioremap(offset, size);
>> +}
>> +#endif
>> +
>> +/*
>> + * memremap() is "ioremap" for cases where it is known that the resource
>> + * being mapped does not have i/o side effects and the __iomem
>> + * annotation is not applicable.
>> + */
>> +void *memremap(resource_size_t offset, size_t size, unsigned long flags)
>> +{
>> +     int is_ram = region_is_ram(offset, size);
>> +     void *addr = NULL;
>> +
>> +     if (is_ram < 0) {
>> +             WARN_ONCE(1, "memremap attempted on mixed range %pa size: %zu\n",
>> +                             &offset, size);
>> +             return NULL;
>> +     }
>> +
>> +     /* Try all mapping types requested until one returns non-NULL */
>> +     if (flags & MEMREMAP_CACHE) {
>> +             flags &= ~MEMREMAP_CACHE;
>> +             /*
>> +              * MEMREMAP_CACHE is special in that it can be satisifed
>> +              * from the direct map.  Some archs depend on the
>> +              * capability of memremap() to autodetect cases where
>> +              * the requested range is potentially in "System RAM"
>> +              */
>> +             if (is_ram)
>> +                     addr = __va(offset);
>
> The no MMU case seems to match this, can that be switch to this?

Hmm, it may be possible to consolidate all the NOMMU cases here.
That's a good incremental cleanup once these base patches are merged.
