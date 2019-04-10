Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440491334.3190322.44013027330479237.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAKv+Gu8ocQGxTAapfjb5WufhL=Qj54LythHcPHsyy+wUnVBnfA@mail.gmail.com>
 <CAPcyv4gUL8j+EaAZ556_NKXLgva++HgPBOeeAUNHN+DAWaewaQ@mail.gmail.com> <CAKv+Gu_M-V-3ahHTj10iyx=eC2pBzFg027NmdBX1x7nXrpqK7g@mail.gmail.com>
In-Reply-To: <CAKv+Gu_M-V-3ahHTj10iyx=eC2pBzFg027NmdBX1x7nXrpqK7g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 9 Apr 2019 19:10:53 -0700
Message-ID: <CAA9_cmeRqr=b-hmaxA0aLZE98YGS9hF8h8JGGp9K6c_qhLK3AQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] efi: Detect UEFI 2.8 Special Purpose Memory
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Shevchenko <andy@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 9, 2019 at 10:21 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Tue, 9 Apr 2019 at 09:44, Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Fri, Apr 5, 2019 at 9:21 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > Hi Dan,
> > >
> > > On Thu, 4 Apr 2019 at 21:21, Dan Williams <dan.j.williams@intel.com> wrote:
> > > >
> > > > UEFI 2.8 defines an EFI_MEMORY_SP attribute bit to augment the
> > > > interpretation of the EFI Memory Types as "reserved for a special
> > > > purpose".
> > > >
> > > > The proposed Linux behavior for special purpose memory is that it is
> > > > reserved for direct-access (device-dax) by default and not available for
> > > > any kernel usage, not even as an OOM fallback. Later, through udev
> > > > scripts or another init mechanism, these device-dax claimed ranges can
> > > > be reconfigured and hot-added to the available System-RAM with a unique
> > > > node identifier.
> > > >
> > > > A follow-on patch integrates parsing of the ACPI HMAT to identify the
> > > > node and sub-range boundaries of EFI_MEMORY_SP designated memory. For
> > > > now, arrange for EFI_MEMORY_SP memory to be reserved.
> > > >
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: Ingo Molnar <mingo@redhat.com>
> > > > Cc: Borislav Petkov <bp@alien8.de>
> > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > Cc: Darren Hart <dvhart@infradead.org>
> > > > Cc: Andy Shevchenko <andy@infradead.org>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  arch/x86/Kconfig                  |   18 ++++++++++++++++++
> > > >  arch/x86/boot/compressed/eboot.c  |    5 ++++-
> > > >  arch/x86/boot/compressed/kaslr.c  |    2 +-
> > > >  arch/x86/include/asm/e820/types.h |    9 +++++++++
> > > >  arch/x86/kernel/e820.c            |    9 +++++++--
> > > >  arch/x86/platform/efi/efi.c       |   10 +++++++++-
> > > >  include/linux/efi.h               |   14 ++++++++++++++
> > > >  include/linux/ioport.h            |    1 +
> > > >  8 files changed, 63 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > > > index c1f9b3cf437c..cb9ca27de7a5 100644
> > > > --- a/arch/x86/Kconfig
> > > > +++ b/arch/x86/Kconfig
> > > > @@ -1961,6 +1961,24 @@ config EFI_MIXED
> > > >
> > > >            If unsure, say N.
> > > >
> > > > +config EFI_SPECIAL_MEMORY
> > > > +       bool "EFI Special Purpose Memory Support"
> > > > +       depends on EFI
> > > > +       ---help---
> > > > +         On systems that have mixed performance classes of memory EFI
> > > > +         may indicate special purpose memory with an attribute (See
> > > > +         EFI_MEMORY_SP in UEFI 2.8). A memory range tagged with this
> > > > +         attribute may have unique performance characteristics compared
> > > > +         to the system's general purpose "System RAM" pool. On the
> > > > +         expectation that such memory has application specific usage
> > > > +         answer Y to arrange for the kernel to reserve it for
> > > > +         direct-access (device-dax) by default. The memory range can
> > > > +         later be optionally assigned to the page allocator by system
> > > > +         administrator policy. Say N to have the kernel treat this
> > > > +         memory as general purpose by default.
> > > > +
> > > > +         If unsure, say Y.
> > > > +
> > >
> > > EFI_MEMORY_SP is now part of the UEFI spec proper, so it does not make
> > > sense to make any understanding of it Kconfigurable.
> >
> > No, I think you're misunderstanding what this Kconfig option is trying
> > to achieve.
> >
> > The configuration capability is solely for the default kernel policy.
> > As can already be seen by Christoph's response [1] the thought that
> > the firmware gets more leeway to dictate to Linux memory policy may be
> > objectionable.
> >
> > [1]: https://lore.kernel.org/lkml/20190409121318.GA16955@infradead.org/
> >
> > So the Kconfig option is gating whether the kernel simply ignores the
> > attribute and gives it to the page allocator by default. Anything
> > fancier, like sub-dividing how much is OS managed vs device-dax
> > accessed requires the OS to reserve it all from the page-allocator by
> > default until userspace policy can be applied.
> >
>
> I don't think this policy should dictate whether we pretend that the
> attribute doesn't exist in the first place. We should just wire up the
> bit fully, and only apply this policy at the very end.

The bit is just a policy hint, if the kernel is not implementing any
of the policy why even check for the bit?

>
> > > Instead, what I would prefer is to implement support for EFI_MEMORY_SP
> > > unconditionally (including the ability to identify it in the debug
> > > dump of the memory map etc), in a way that all architectures can use
> > > it. Then, I think we should never treat it as ordinary memory and make
> > > it the firmware's problem not to use the EFI_MEMORY_SP attribute in
> > > cases where it results in undesired behavior in the OS.
> >
> > No, a policy of "never treat it as ordinary memory" confuses the base
> > intent of the attribute which is an optional hint to get the OS to not
> > put immovable / non-critical allocations in what could be a precious
> > resource.
> >
>
> The base intent is to prevent the OS from using memory that is
> co-located with an accelerator for any purpose other than what the
> accelerator needs it for. Having a Kconfigurable policy that may be
> disabled kind of misses the point IMO. I think 'optional hint' doesn't
> quite capture the intent.

That's not my understanding, and an EFI attribute is the wrong
mechanism to meet such a requirement. If this memory is specifically
meant for use with a given accelerator then it had better be marked
reserved and the accelerator driver is then responsible for publishing
the resource to the OS if at all.

You did prompt me to go back and re-read the wording in the spec. It
still seems clear to me that the attribute is an optional hint not a
hard requirement. Whether the OS honors an optional hint is an OS
policy and I fail to see why the OS should bother to detect the bit
without implementing any associated policy.

> > Moreover, the interface for platform firmware to indicate that a
> > memory range should never be treated as ordinary memory is simply the
> > existing "reserved" memory type, not this attribute. That's the
> > mechanism to use when platform firmware knows that a driver is needed
> > for a given mmio resource.
> >
>
> Reserved memory is memory that simply should never touched at all by
> the OS, and on ARM, we take care never to map it anywhere.

That's not a guarantee, at least on x86. Some shipping persistent
memory platforms describe it as reserved and then the ACPI NFIT
further describes what that reserved memory contains and how the OS
can use it. See commit af1996ef59db "ACPI: Change NFIT driver to
insert new resource".
