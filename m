Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CA+55aFzPUY2jReg2NXYUpTB2oDYttO5+qw4oy9G1eg+BCm2aDA@mail.gmail.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150605211906.20751.59875.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CA+55aFzPUY2jReg2NXYUpTB2oDYttO5+qw4oy9G1eg+BCm2aDA@mail.gmail.com>
Date: Fri, 5 Jun 2015 15:12:54 -0700
Message-ID: <CAPcyv4jffyMvR=eDcuh6i0i33otSK-m8yQjSzYErUYN8yejHdA@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] introduce __pfn_t for scatterlists and pmem
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Dave Chinner <david@fromorbit.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Christoph Hellwig <hch@lst.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 5, 2015 at 2:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 5, 2015 at 2:19 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> +enum {
>> +#if BITS_PER_LONG == 64
>> +       PFN_SHIFT = 3,
>> +       /* device-pfn not covered by memmap */
>> +       PFN_DEV = (1UL << 2),
>> +#else
>> +       PFN_SHIFT = 2,
>> +#endif
>> +       PFN_MASK = (1UL << PFN_SHIFT) - 1,
>> +       PFN_SG_CHAIN = (1UL << 0),
>> +       PFN_SG_LAST = (1UL << 1),
>> +};
>
> Ugh. Just make PFN_SHIFT unconditional. Make it 2, unconditionally.
> Or, if you want to have more bits, make it three unconditionally, and
> make 'struct page' just be at least 8-byte aligned even on 32-bit.
>
> Even on 32-bit architectures, there's plenty of bits. There's no
> reason to "pack" this optimally. Remember: it's a page frame number,
> so there's the page size shifting going on in physical memory, and
> even if you shift the PFN by 3 - or four  of five - bits
> unconditionally (rather than try to shift it by some minimal number),
> you're covering a *lot* of physical memory.

It is a page frame number, but page_to_pfn_t() just stores the value
of the struct page pointer directly, so we really only have the
pointer alignment bits.  I do this so that kmap_atomic_pfn_t() can
optionally call kmap_atomic() if the pfn is mapped.

>
> Say you're a 32-bit architecture with a 4k page size, and you lose
> three bits to "type" bits. You still have 32+12-3=41 bits of physical
> address space. Which is way more than realistic for a 32-bit
> architecture anyway, even with PAE (or PXE or whatever ARM calls it).
> Not that I see persistent memory being all that relevant on 32-bit
> hardware anyway.
>
> So I think if you actually do want that third bit, you're better off
> just marking "struct page" as being __aligned__((8)) and getting the
> three bits unconditionally. Just make the rule be that mem_map[] has
> to be 8-byte aligned.
>
> Even 16-byte alignment would probably be fine. No?
>

Ooh, that's great, I was already lamenting the fact that I had run out
of bits.  One of the reasons to go to 16-byte alignment is to have
another bit to further qualify the pfn as persistent memory not just
un-mapped memory.  The rationale would be to generate, and verify
proper usage of, __pmem annotated pointers.

...but I'm still waiting for someone to tell me I'm needlessly
complicating things with a __pmem annotation [1].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-June/001087.html
