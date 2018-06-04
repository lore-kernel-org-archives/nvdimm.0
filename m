Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DC342096F338
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jun 2018 11:35:07 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id k5-v6so29336666oiw.0
 for <linux-nvdimm@lists.01.org>; Mon, 04 Jun 2018 11:35:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180604180845.GA17942@agluck-desk>
References: <152800336321.17112.3300876636370683279.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152800340082.17112.1154560126059273408.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180604170801.GA17234@agluck-desk>
 <CAPcyv4g76nv=D2NXrpFLS-aWQR=N0T2n01WhrVY2_KPavkvLCA@mail.gmail.com>
 <20180604180845.GA17942@agluck-desk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Jun 2018 11:35:06 -0700
Message-ID: <CAPcyv4ggLr780-bQWVFqh-iC3z+coGwRnd-bM-nwWfXC+mVgfg@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] x86, memory_failure: Introduce {set,
 clear}_mce_nospec()
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 4, 2018 at 11:08 AM, Luck, Tony <tony.luck@intel.com> wrote:
> On Mon, Jun 04, 2018 at 10:39:48AM -0700, Dan Williams wrote:
>> On Mon, Jun 4, 2018 at 10:08 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> > On Sat, Jun 02, 2018 at 10:23:20PM -0700, Dan Williams wrote:
>> >> +static inline int set_mce_nospec(unsigned long pfn)
>> >> +{
>> >> +     int rc;
>> >> +
>> >> +     rc = set_memory_uc((unsigned long) __va(PFN_PHYS(pfn)), 1);
>> >
>> > You should really do the decoy_addr thing here that I had in mce_unmap_kpfn().
>> > Putting the virtual address of the page you mustn't accidentally prefetch
>> > from into a register is a pretty good way to make sure that the processor
>> > does do a prefetch.
>>
>> Maybe I'm misreading, but doesn't that make the page completely
>> inaccessible? We still want to read pmem through the driver and the
>> linear mapping with memcpy_mcsafe(). Alternatively I could just drop
>> this patch and setup a private / alias mapping for the pmem driver to
>> use. It seems aliased mappings would be the safer option, but I want
>> to make sure I've comprehended your suggestion correctly?
>
> I'm OK with the call to set_memory_uc() to make this uncacheable
> instead of set_memory_np() to make it inaccessible.
>
> The problem is how to achieve that.
>
> The result of __va(PFN_PHYS(pfn) is the virtual address where the poison
> page is currently mapped into the kernel. That value gets put into
> register %rdi to make the call to set_memory_uc() (which goes on to
> call a bunch of other functions passing the virtual address along
> the way).
>
> Now imagine an impatient super-speculative processor is waiting for
> some result to decide where to jump next, and picks a path that isn't
> going to be taken ... out in the weeds somewhere it runs into:
>
>         movzbl  (%rdi), %eax
>
> Oops ... now you just read from the address you were trying to
> avoid. So we log an error. Eventually the speculation gets sorted
> out and the processor knows not to signal a machine check. But the
> log is sitting in a machine check bank waiting to cause an overflow
> if we try to log a second error.
>
> The decoy_addr trick in mce_unmap_kpfn() throws in the high bit
> to the address passed.  The set_memory_np() code (and I assume the
> set_memory_uc()) code ignores it, but it means any stray speculative
> access won't point at the poison page.
>
> -Tony
>
> Note: this is *mostly* a problem if the poison is in the first
> cache line of the page.  But you could hit other lines if the
> instruction you speculatively ran into had the right offset. E.g.
> to hit the third line:
>
>         movzbl  128(%rdi), %eax

Ok, makes sense and I do see now that this decoy resolves to the same
physical address once PTE_PFN_MASK is applied when we start messing
with page tables.

However, set_memory_uc() is currently not prepared for this trick as
it specifies the unmasked physical address to reserve_memtype().

        ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
                              _PAGE_CACHE_MODE_UC_MINUS, NULL);

...compared to set_memory_np() which does not manipulate the memtype tracking.

I'll fix up reserve_memtype() and free_memtype() to be prepared for
decoy addresses.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
