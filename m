Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D116F211F35E7
 for <linux-nvdimm@lists.01.org>; Tue,  9 Apr 2019 09:44:03 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id e5so14171418oii.0
 for <linux-nvdimm@lists.01.org>; Tue, 09 Apr 2019 09:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440491334.3190322.44013027330479237.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAKv+Gu8ocQGxTAapfjb5WufhL=Qj54LythHcPHsyy+wUnVBnfA@mail.gmail.com>
In-Reply-To: <CAKv+Gu8ocQGxTAapfjb5WufhL=Qj54LythHcPHsyy+wUnVBnfA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 9 Apr 2019 09:43:50 -0700
Message-ID: <CAPcyv4gUL8j+EaAZ556_NKXLgva++HgPBOeeAUNHN+DAWaewaQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] efi: Detect UEFI 2.8 Special Purpose Memory
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Shevchenko <andy@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 5, 2019 at 9:21 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Hi Dan,
>
> On Thu, 4 Apr 2019 at 21:21, Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > UEFI 2.8 defines an EFI_MEMORY_SP attribute bit to augment the
> > interpretation of the EFI Memory Types as "reserved for a special
> > purpose".
> >
> > The proposed Linux behavior for special purpose memory is that it is
> > reserved for direct-access (device-dax) by default and not available for
> > any kernel usage, not even as an OOM fallback. Later, through udev
> > scripts or another init mechanism, these device-dax claimed ranges can
> > be reconfigured and hot-added to the available System-RAM with a unique
> > node identifier.
> >
> > A follow-on patch integrates parsing of the ACPI HMAT to identify the
> > node and sub-range boundaries of EFI_MEMORY_SP designated memory. For
> > now, arrange for EFI_MEMORY_SP memory to be reserved.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Darren Hart <dvhart@infradead.org>
> > Cc: Andy Shevchenko <andy@infradead.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  arch/x86/Kconfig                  |   18 ++++++++++++++++++
> >  arch/x86/boot/compressed/eboot.c  |    5 ++++-
> >  arch/x86/boot/compressed/kaslr.c  |    2 +-
> >  arch/x86/include/asm/e820/types.h |    9 +++++++++
> >  arch/x86/kernel/e820.c            |    9 +++++++--
> >  arch/x86/platform/efi/efi.c       |   10 +++++++++-
> >  include/linux/efi.h               |   14 ++++++++++++++
> >  include/linux/ioport.h            |    1 +
> >  8 files changed, 63 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index c1f9b3cf437c..cb9ca27de7a5 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1961,6 +1961,24 @@ config EFI_MIXED
> >
> >            If unsure, say N.
> >
> > +config EFI_SPECIAL_MEMORY
> > +       bool "EFI Special Purpose Memory Support"
> > +       depends on EFI
> > +       ---help---
> > +         On systems that have mixed performance classes of memory EFI
> > +         may indicate special purpose memory with an attribute (See
> > +         EFI_MEMORY_SP in UEFI 2.8). A memory range tagged with this
> > +         attribute may have unique performance characteristics compared
> > +         to the system's general purpose "System RAM" pool. On the
> > +         expectation that such memory has application specific usage
> > +         answer Y to arrange for the kernel to reserve it for
> > +         direct-access (device-dax) by default. The memory range can
> > +         later be optionally assigned to the page allocator by system
> > +         administrator policy. Say N to have the kernel treat this
> > +         memory as general purpose by default.
> > +
> > +         If unsure, say Y.
> > +
>
> EFI_MEMORY_SP is now part of the UEFI spec proper, so it does not make
> sense to make any understanding of it Kconfigurable.

No, I think you're misunderstanding what this Kconfig option is trying
to achieve.

The configuration capability is solely for the default kernel policy.
As can already be seen by Christoph's response [1] the thought that
the firmware gets more leeway to dictate to Linux memory policy may be
objectionable.

[1]: https://lore.kernel.org/lkml/20190409121318.GA16955@infradead.org/

So the Kconfig option is gating whether the kernel simply ignores the
attribute and gives it to the page allocator by default. Anything
fancier, like sub-dividing how much is OS managed vs device-dax
accessed requires the OS to reserve it all from the page-allocator by
default until userspace policy can be applied.

> Instead, what I would prefer is to implement support for EFI_MEMORY_SP
> unconditionally (including the ability to identify it in the debug
> dump of the memory map etc), in a way that all architectures can use
> it. Then, I think we should never treat it as ordinary memory and make
> it the firmware's problem not to use the EFI_MEMORY_SP attribute in
> cases where it results in undesired behavior in the OS.

No, a policy of "never treat it as ordinary memory" confuses the base
intent of the attribute which is an optional hint to get the OS to not
put immovable / non-critical allocations in what could be a precious
resource.

Moreover, the interface for platform firmware to indicate that a
memory range should never be treated as ordinary memory is simply the
existing "reserved" memory type, not this attribute. That's the
mechanism to use when platform firmware knows that a driver is needed
for a given mmio resource.

> Also, sInce there is a generic component and a x86 component, can you
> please split those up?

Sure, can do.

>
> You only cc'ed me on patch #1 this time, but could you please cc me on
> the entire series for v2? Thanks.

Yes, will do, and thanks for taking a look.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
