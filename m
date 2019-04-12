Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C432D2120516B
 for <linux-nvdimm@lists.01.org>; Fri, 12 Apr 2019 14:18:16 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e80so9639860ote.5
 for <linux-nvdimm@lists.01.org>; Fri, 12 Apr 2019 14:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440491334.3190322.44013027330479237.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAKv+Gu8ocQGxTAapfjb5WufhL=Qj54LythHcPHsyy+wUnVBnfA@mail.gmail.com>
 <CAPcyv4gUL8j+EaAZ556_NKXLgva++HgPBOeeAUNHN+DAWaewaQ@mail.gmail.com>
 <CAKv+Gu_M-V-3ahHTj10iyx=eC2pBzFg027NmdBX1x7nXrpqK7g@mail.gmail.com>
 <CAA9_cmeRqr=b-hmaxA0aLZE98YGS9hF8h8JGGp9K6c_qhLK3AQ@mail.gmail.com>
 <CAKv+Gu_gzHH7onY4WUWV8SAYeVXfMK-W3CaxYZ706sPo6ATZpA@mail.gmail.com>
In-Reply-To: <CAKv+Gu_gzHH7onY4WUWV8SAYeVXfMK-W3CaxYZ706sPo6ATZpA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Apr 2019 14:18:03 -0700
Message-ID: <CAPcyv4gtD=h-z_b5k3XTWsiPVv0NY=+Gycr8TJoTMCfcM3RL_A@mail.gmail.com>
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

On Fri, Apr 12, 2019 at 1:44 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
[..]
> > > I don't think this policy should dictate whether we pretend that the
> > > attribute doesn't exist in the first place. We should just wire up the
> > > bit fully, and only apply this policy at the very end.
> >
> > The bit is just a policy hint, if the kernel is not implementing any
> > of the policy why even check for the bit?
> >
>
> Because I would like things like the EFI memory map dumping code etc
> to report the bit regardless of whether we are honoring it or not.

Ok, I'll split it out just for reporting purposes, and come up with a
different mechanism to indicate whether the OS might not be honoring
the expectations of the attribute.

[..]
> Because not taking a hint is not the same thing as pretending it isn't
> there to begin with.

True, and I was missing the enabling to go update where the kernel
goes to report attributes, but for the applications that care they
will still want to debug when the kernel may be placing unwanted
allocations in the "special purpose" range.

> > > > Moreover, the interface for platform firmware to indicate that a
> > > > memory range should never be treated as ordinary memory is simply the
> > > > existing "reserved" memory type, not this attribute. That's the
> > > > mechanism to use when platform firmware knows that a driver is needed
> > > > for a given mmio resource.
> > > >
> > >
> > > Reserved memory is memory that simply should never touched at all by
> > > the OS, and on ARM, we take care never to map it anywhere.
> >
> > That's not a guarantee, at least on x86. Some shipping persistent
> > memory platforms describe it as reserved and then the ACPI NFIT
> > further describes what that reserved memory contains and how the OS
> > can use it. See commit af1996ef59db "ACPI: Change NFIT driver to
> > insert new resource".
>
> The UEFI spec is pretty clear about the fact that reserved memory
> shouldn't ever be touched by the OS. The fact that x86 platforms exist
> that violate this doesn't mean we should abuse it in other ways as
> well.

I think we're talking about 2 different "reserved" memory types, and
it was my fault for not being precise enough. The e820 reserved memory
type has been used for things like PCI memory-mapped I/O or other
memory ranges for which the OS should expect a device-driver to claim.
So when I said EFI_RESERVED_TYPE is safe to use as driver memory I
literally meant this interpretation from do_add_efi_memmap():

                default:
                        /*
                         * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
                         * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
                         * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
                         */
                        e820_type = E820_TYPE_RESERVED;
                        break;

...where EFI_RESERVED_TYPE is identical to EFI_MEMORY_MAPPED_IO
relative to E820_TYPE_RESERVED.

The policy taken by these patches is that EFI_CONVENTIONAL_MEMORY
marked with the EFI_MEMORY_SP attribute is treated as
E820_TYPE_RESERVED by default and given to the device-dax driver with
the option to hotplug it as E820_TYPE_RAM at a later time with its own
numa description.

I'm generally pushing back on the argument that EFI_MEMORY_SP ==
EFI_RESERVED_TYPE, especially when the type is explicitly set to
EFI_CONVENTIONAL_MEMORY.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
