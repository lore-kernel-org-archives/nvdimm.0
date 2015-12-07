Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: ARM EFI stub and the EfiPersistentMemory type
Date: Mon, 7 Dec 2015 23:06:18 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BE8966F@G4W3202.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B40295BE85E04@G4W3202.americas.hpqcorp.net>
 <20151204030218.GA1523@svinekod>
 <CAKv+Gu_j7ES6Rh14hPuOUSX5sY2ywaiz=Q8m3YPZBED=i7r+8Q@mail.gmail.com>
 <20151204040447.GA1643@svinekod>
In-Reply-To: <20151204040447.GA1643@svinekod>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "bp@suse.de" <bp@suse.de>, "yinghai@kernel.org" <yinghai@kernel.org>, "msalter@redhat.com" <msalter@redhat.com>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


> -----Original Message-----
> From: Mark Rutland [mailto:mark.rutland@arm.com]
> Sent: Thursday, December 3, 2015 10:05 PM
> To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Elliott, Robert (Persistent Memory) <elliott@hpe.com>;
> leif.lindholm@linaro.org; dan.j.williams@intel.com; Kani, Toshimitsu
> <toshi.kani@hpe.com>; linux-nvdimm@lists.01.org; matt.fleming@intel.com;
> bp@suse.de; yinghai@kernel.org; msalter@redhat.com; roy.franz@linaro.org;
> linux-kernel@vger.kernel.org
> Subject: Re: ARM EFI stub and the EfiPersistentMemory type
> 
> On Sat, Dec 05, 2015 at 11:11:46AM +0100, Ard Biesheuvel wrote:
> > On 4 December 2015 at 04:02, Mark Rutland <mark.rutland@arm.com> wrote:

>> For EfiPersistentMemory, I understand that such allocations would 
>> be valid, (given that such memory may be mapped as EFI_MEMORY_WB),
>> but would be suboptimal (i.e. that memory will be slower, and
>> would be better suited for other data).
>>
>> Is that understanding correct?
>>
>> Or are there correctness issues with placing the kernel in
>> persistent memory, even if using attributes consistent with
>> EFI_MEMORY_WB?

The contents of persistent memory depend on the drivers being
used.  The pmem block device driver treats the memory as 512 byte 
logical blocks holding anything that can be stored on block
device - partitions, filesystems, etc.  Other drivers could
have different interpretations.  The user must manage any driver
conflicts.

Any UEFI driver that manages this space (e.g., a UEFI pmem
driver to facilitate booting) must match the OS driver.

UEFI's pool and page allocators need to avoid that area to
avoid letting loadable applications treating it as memory
from destroying the persistent data.

> [...]
> 
> > > Is AllocatePages expected to allocate EfiPersistentMemory? The spec
> > > seems vague on this point.
> > >
> >
> > AllocatePages should not return EfiPersistentMemory. That is the
> > consensus, and if the spec does not convey this clearly, we should fix
> > that.
> > The primary reason is that the UEFI spec does not allow the nature of
> > the contents of such regions to be described, and obviously, arbitrary
> > allocations should not be served from regions which are not known to
> > be vacant.
> 
> That was my feeling too.
> 
> AllocatePages will refuse an allocation if the MemoryType parameter was
> EfiPersistentMemory, but I couldn't find any statement that a region of
> EfiPersistentMemory will not be converted to EfiLoaderData or similar to
> fulfill an allocation, as can happen for EfiConventionalMemory.
> 
> I think that could be clarified.

The description of AllocatePool() includes:
    "This function allocates pages from EfiConventionalMemory as needed
     to grow the requested pool type."

but that doesn't include EfiPersistentMemory, so it shouldn't be
interpreted as being the source for a pool.

AllocatePages() doesn't say anything like that for EfiConventionalMemory,
so shouldn't imply anything about EfiPersistentMemory.

> > On top of that, the kernel routines that back efi_low_alloc() and
> > efi_high_alloc() traverse the memory map and look for
> > EfiConventionalMemory regions, and trying to allocate from the
> > explicitly. (i.e., they ultimately invoke AllocatePages() with a fixed
> > address which is a priori known to be backed by EfiConventionalMemory)
> 
> Ok. That renders us safe for the case Robert had concerns.
> 
> > > Regarding EfiReservedMemory, the UEFI spec states that such
> > > regions should not be allocated by UEFI applications, drivers,
> > > or OS loaders, so if we can allocate from such regions, that
> > > is a bug that we should correct. I would hope that AllocatePages
> > > would refuse to allocate from such regions, but I don't see
> > > any guarantee to that effect.

AllocatePages() supports EfiReservedMemoryType for internal 
allocations, so doesn't reject such requests like it does
for EfiPersistentMemory.  I guess "just don't do that" applies
for loadable applications - they'd just be removing memory
from their own memory map.

...
> I understand that distinction. I think there's a problem if a region can
> have the WB flag and yet not be safe to map with WB attributes (i.e. the
> type takes precedence).

EfiPersistentMemory will usually be marked as WB|WT|WC|UC, but
persistent memory software must be careful using WB. Writes are 
not persistent until the CPU caches are flushed and appropriate
fence instructions are completed by the CPU.

The ACPI NFIT reports a lot more information about the memory
regions - GUIDs, Flush Hint Addresses, etc.


