Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 4 Dec 2015 04:04:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: ARM EFI stub and the EfiPersistentMemory type
Message-ID: <20151204040447.GA1643@svinekod>
References: <94D0CD8314A33A4D9D801C0FE68B40295BE85E04@G4W3202.americas.hpqcorp.net>
 <20151204030218.GA1523@svinekod>
 <CAKv+Gu_j7ES6Rh14hPuOUSX5sY2ywaiz=Q8m3YPZBED=i7r+8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_j7ES6Rh14hPuOUSX5sY2ywaiz=Q8m3YPZBED=i7r+8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "bp@suse.de" <bp@suse.de>, "yinghai@kernel.org" <yinghai@kernel.org>, "msalter@redhat.com" <msalter@redhat.com>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 05, 2015 at 11:11:46AM +0100, Ard Biesheuvel wrote:
> On 4 December 2015 at 04:02, Mark Rutland <mark.rutland@arm.com> wrote:
> > Hi,
> >
> > On Fri, Dec 04, 2015 at 09:51:22PM +0000, Elliott, Robert (Persistent Memory) wrote:
> >> drivers/firmware/efi/libstub/efi-stub-helper.c get_dram_base()
> >> parses the UEFI memory map, but just looks at the EFI_MEMORY_WB
> >> attribute while searching for the base memory address,
> >> not the type:
> >>
> >> unsigned long get_dram_base(efi_system_table_t *sys_table_arg) {
> >> ...
> >>         for_each_efi_memory_desc(&map, md)
> >>                 if (md->attribute & EFI_MEMORY_WB)
> >>                         if (membase > md->phys_addr)
> >>                                 membase = md->phys_addr;

[...]

> >> This is used by drivers/firmware/efi/libstub/arm-stub.c to
> >> decide where to place the kernel image:
> >>
> >> unsigned long efi_entry(void *handle, efi_system_table_t *sys_table, {
> >> ...
> >>         dram_base = get_dram_base(sys_table);
> >>         if (dram_base == EFI_ERROR) {
> >>                 pr_efi_err(sys_table, "Failed to find DRAM base\n");
> >>                 goto fail;
> >>         }
> >>         status = handle_kernel_image(sys_table, image_addr, &image_size,
> >>                                      &reserve_addr,
> >>                                      &reserve_size,
> >>                                      dram_base, image);
> >>
> >> Most types, including EfiPersistentMemory (14) and
> >> EfiReservedMemoryType (0), end up with WB|WT|WC|UC attributes.

[...]

> > Is AllocatePages expected to allocate EfiPersistentMemory? The spec seems vague
> > on this point.
> >
> 
> AllocatePages should not return EfiPersistentMemory. That is the
> consensus, and if the spec does not convey this clearly, we should fix
> that.
> The primary reason is that the UEFI spec does not allow the nature of
> the contents of such regions to be described, and obviously, arbitrary
> allocations should not be served from regions which are not known to
> be vacant.

That was my feeling too.

AllocatePages will refuse an allocation if the MemoryType parameter was
EfiPersistentMemory, but I couldn't find any statement that a region of
EfiPersistentMemory will not be converted to EfiLoaderData or similar to
fulfill an allocation, as can happen for EfiConventionalMemory.

I think that could be clarified.

> On top of that, the kernel routines that back efi_low_alloc() and
> efi_high_alloc() traverse the memory map and look for
> EfiConventionalMemory regions, and trying to allocate from the
> explicitly. (i.e., they ultimately invoke AllocatePages() with a fixed
> address which is a priori known to be backed by EfiConventionalMemory)

Ok. That renders us safe for the case Robert had concerns.

> > Regarding EfiReservedMemory, the UEFI spec states that such regions should not
> > be allocated by UEFI applications, drivers, or OS loaders, so if we can
> > allocate from such regions, that is a bug that we should correct. I would hope
> > that AllocatePages would refuse to allocate from such regions, but I don't see
> > any guarantee to that effect.
> >
> > Regardless, if it is unsafe to map such regions with WB attributes (e.g.
> > because this could trigger bus errors), I don't believe that the EFI_MEMORY_WB
> > flag should be set. The spec doesn't seem to be clear on the precedence of
> > types vs attributes, but I may have missed something.
> >
> 
> The UEFI memory type attributes don't have a precedence since they are
> not normative regarding how it should be mapped by the OS, it only
> describes the various way the memory /could/ be mapped by the OS.

I understand that distinction. I think there's a problem if a region can have
the WB flag and yet not be safe to map with WB attributes (i.e. the type takes
precedence).

When Linux proper parses the efi memory map (in reserve_regions), anything with
a WB attribute is assumed safe to map, as is_normal_ram(md) will be true. So
the CPU and caches may perform speculative fetches from such a region. If
EfiUnusableMemory triggers ECC errors or similar in response to this, then we
have a problem.

It also looks like is_reserve_region(md) assumes that any memory type it
doesn't know about isn't reserved, so long as it has the WB attribute. It may
be worth making that more conservative.

> >> So, if persistent memory happened to be below conventional memory,
> >> it appears that this code would end up loading the kernel into
> >> persistent memory, which would not be good.  The same for
> >> reserved memory ranges. I think it needs to check and only
> >> operate on EfiConventionalMemory (maybe with a few others).
> >
> > I agree that we should place the kernel in EfiConventionalMemory.
> >
> > As above, there may be (sub-2MiB) overlap with regions of other types, so long
> > as these can be mapped with EFI_MEMORY_WB attributes.
> >
> > So we need to allocate a chunk of memory such that:
> > * The chunk is in EfiConventionalMemory.
> > * The chunk is least image_size bytes in size.
> > * The chunk starts TEXT_OFFSET from a 2MiB aligned base.
> > * Any page sharing a same naturally-aligned 2MiB region with said chunk has
> >   EFI_MEMORY_WB attributes. Non-chunk pages might not have a
> >   EfiConventionalMemory type.
> > * The chunk is the lowest chunk meeting the other requirements above.

Given we'll only allocate from EfiConventionalMemory, we're mostly fine here.

There does appear to be a potential problem with sharing a 2MiB chunk with !WB
regions, as we don't verify that all regions sharing a 2MiB chunk have the WB
attribute. We don't appear to be hitting that in practice, or at least we are
not seeing issues.

> >
> > Is there anything I've missed?
> 
> The DRAM base is an arbitrary lower bound, and we don't actually need
> it for arm64: it was carried over from the ARM version of this code
> (which actually predates the arm64 version), where it is important
> that the compressed kernel image is not located below the lowest 128
> MB aligned boundary that is covered by normal DRAM. The reason is that
> the decompressor assumes that DRAM starts at the 128 MB aligned
> boundary below the compressed kernel image (it does not interpret the
> device tree or UEFI memory map at all)

Ok.

Thanks,
Mark.
