Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FA78202E5EE3
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 09:33:11 -0700 (PDT)
Received: by mail-ot0-x236.google.com with SMTP id 77-v6so6898353otd.4
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 09:33:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 May 2018 09:33:10 -0700
Message-ID: <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
Subject: Re: Draft NVDIMM proposal
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
To: George Dunlap <george.dunlap@citrix.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Cooper <Andrew.Cooper3@citrix.com>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, Jan Beulich <JBeulich@suse.com>, Yi Zhang <yi.z.zhang@intel.com>, Roger Pau Monne <roger.pau@citrix.com>
List-ID: <linux-nvdimm@lists.01.org>

[ adding linux-nvdimm ]

Great write up! Some comments below...

On Wed, May 9, 2018 at 10:35 AM, George Dunlap <george.dunlap@citrix.com> wrote:
> Dan,
>
> I understand that you're the NVDIMM maintainer for Linux.  I've been
> working with your colleagues to try to sort out an architecture to allow
> NVRAM to be passed to guests under the Xen hypervisor.
>
> If you have time, I'd appreciate it if you could skim through at least
> the first section of the document below ("NVIDMM Overview"), concerning
> NVDIMM devices and Linux, to see if I've made any mistakes.
>
> If you're up for it, additional early feedback on the proposed Xen
> architecture, from a Linux perspective, would be awesome as well.
>
> Thanks,
>  -George
>
> On 05/09/2018 06:29 PM, George Dunlap wrote:
>> Below is an initial draft of an NVDIMM proposal.  I'll submit a patch to
>> include it in the tree at some point, but I thought for initial
>> discussion it would be easier if it were copied in-line.
>>
>> I've done a fair amount of investigation, but it's quite likely I've
>> made mistakes.  Please send me corrections where necessary.
>>
>> -George
>>
>> ---
>> % NVDIMMs and Xen
>> % George Dunlap
>> % Revision 0.1
>>
>> # NVDIMM overview
>>
>> It's very difficult, from the various specs, to actually get a
>> complete enough picture if what's going on to make a good design.
>> This section is meant as an overview of the current hardware,
>> firmware, and Linux interfaces sufficient to inform a discussion of
>> the issues in designing a Xen interface for NVDIMMs.
>>
>> ## DIMMs, Namespaces, and access methods
>>
>> An NVDIMM is a DIMM (_dual in-line memory module_) -- a physical form
>> factor) that contains _non-volatile RAM_ (NVRAM).  Individual bytes of
>> memory on a DIMM are specified by a _DIMM physical address_ or DPA.
>> Each DIMM is attached to an NVDIMM controller.
>>
>> Memory on the DIMMs is divided up into _namespaces_.  The word
>> "namespace" is rather misleading though; a namespace in this context
>> is not actually a space of names (contrast, for example "C++
>> namespaces"); rather, it's more like a SCSI LUN, or a volume, or a
>> partition on a drive: a set of data which is meant to be viewed and
>> accessed as a unit.  (The name was apparently carried over from NVMe
>> devices, which were precursors of the NVDIMM spec.)

Unlike NVMe an NVDIMM itself has no concept of namespaces. Some DIMMs
provide a "label area" which is an out-of-band non-volatile memory
area where the OS can store whatever it likes. The UEFI 2.7
specification defines a data format for the definition of namespaces
on top of persistent memory ranges advertised to the OS via the ACPI
NFIT structure.

There is no obligation for an NVDIMM to provide a label area, and as
far as I know all NVDIMMs on the market today do not provide a label
area. That said, QEMU has the ability to associate a virtual label
area with for its virtual NVDIMM representation.

>> The NVDIMM controller allows two ways to access the DIMM.  One is
>> mapped 1-1 in _system physical address space_ (SPA), much like normal
>> RAM.  This method of access is called _PMEM_.  The other method is
>> similar to that of a PCI device: you have a control and status
>> register which control an 8k aperture window into the DIMM.  This
>> method access is called _PBLK_.
>>
>> In the case of PMEM, as in the case of DRAM, addresses from the SPA
>> are interleaved across a set of DIMMs (an _interleave set_) for
>> performance reasons.  A specific PMEM namespace will be a single
>> contiguous DPA range across all DIMMs in its interleave set.  For
>> example, you might have a namespace for DPAs `0-0x50000000` on DIMMs 0
>> and 1; and another namespace for DPAs `0x80000000-0xa0000000` on DIMMs
>> 0, 1, 2, and 3.
>>
>> In the case of PBLK, a namespace always resides on a single DIMM.
>> However, that namespace can be made up of multiple discontiguous
>> chunks of space on that DIMM.  For instance, in our example above, we
>> might have a namespace om DIMM 0 consisting of DPAs
>> `0x50000000-0x60000000`, `0x80000000-0x90000000`, and
>> `0xa0000000-0xf0000000`.
>>
>> The interleaving of PMEM has implications for the speed and
>> reliability of the namespace: Much like RAID 0, it maximizes speed,
>> but it means that if any one DIMM fails, the data from the entire
>> namespace is corrupted.  PBLK makes it slightly less straightforward
>> to access, but it allows OS software to apply RAID-like logic to
>> balance redundancy and speed.
>>
>> Furthermore, PMEM requires one byte of SPA for every byte of NVDIMM;
>> for large systems without 5-level paging, this is actually becoming a
>> limitation.  Using PBLK allows existing 4-level paged systems to
>> access an arbitrary amount of NVDIMM.
>>
>> ## Namespaces, labels, and the label area
>>
>> A namespace is a mapping from the SPA and MMIO space into the DIMM.
>>
>> The firmware and/or operating system can talk to the NVDIMM controller
>> to set up mappings from SPA and MMIO space into the DIMM.  Because the
>> memory and PCI devices are separate, it would be possible for buggy
>> firmware or NVDIMM controller drivers to misconfigure things such that
>> the same DPA is exposed in multiple places; if so, the results are
>> undefined.
>>
>> Namespaces are constructed out of "labels".  Each DIMM has a Label
>> Storage Area, which is persistent but logically separate from the
>> device-addressable areas on the DIMM.  A label on a DIMM describes a
>> single contiguous region of DPA on that DIMM.  A PMEM namespace is
>> made up of one label from each of the DIMMs which make its interleave
>> set; a PBLK namespace is made up of one label for each chunk of range.
>>
>> In our examples above, the first PMEM namespace would be made of two
>> labels (one on DIMM 0 and one on DIMM 1, each describind DPA
>> `0-0x50000000`), and the second namespace would be made of four labels
>> (one on DIMM 0, one on DIMM 1, and so on).  Similarly, in the PBLK
>> example, the namespace would consist of three labels; one describing
>> `0x50000000-0x60000000`, one describing `0x80000000-0x90000000`, and
>> so on.
>>
>> The namespace definition includes not only information about the DPAs
>> which make up the namespace and how they fit together; it also
>> includes a UUID for the namespace (to allow it to be identified
>> uniquely), a 64-character "name" field for a human-friendly
>> description, and Type and Address Abstraction GUIDs to inform the
>> operating system how the data inside the namespace should be
>> interpreted.  Additionally, it can have an `ROLABEL` flag, which
>> indicates to the OS that "device drivers and manageability software
>> should refuse to make changes to the namespace labels", because
>> "attempting to make configuration changes that affect the namespace
>> labels will fail (i.e. because the VM guest is not in a position to
>> make the change correctly)".
>>
>> See the [UEFI Specification][uefi-spec], section 13.19, "NVDIMM Label
>> Protocol", for more information.
>>
>> [uefi-spec]:
>> http://www.uefi.org/sites/default/files/resources/UEFI%20Spec%202_7_A%20Sept%206.pdf
>>
>> ## NVDIMMs and ACPI
>>
>> The [ACPI Specification][acpi-spec] breaks down information in two ways.
>>
>> The first is about physical devices (see section 9.20, "NVDIMM
>> Devices").  The NVDIMM controller is called the _NVDIMM Root Device_.
>> There will generally be only a single NVDIMM root device on a system.
>>
>> Individual NVDIMMs are referred to by the spec as _NVDIMM Devices_.
>> Each separate DIMM will have its own device listed as being under the
>> Root Device.  Each DIMM will have an _NVDIMM Device Handle_ which
>> describes the physical DIMM (its location within the memory channel,
>> the channel number within the memory controller, the memory controller
>> ID within the socket, and so on).
>>
>> The second is about the data on those devices, and how the operating
>> system can access it.  This information is exposed in the NFIT table
>> (see section 5.2.25).
>>
>> Because namespace labels allow NVDIMMs to be partitioned in fairly
>> arbitrary ways, exposing information about how the operating system
>> can access it is a bit complicated.  It consists of several tables,
>> whose information must be correlated to make sense out of it.
>>
>> These tables include:
>>  1. A table of DPA ranges on individual NVDIMM devices
>>  2. A table of SPA ranges where PMEM regions are mapped, along with
>>     interleave sets
>>  3. Tables for control and data addresses for PBLK regions
>>
>> NVRAM on a given NVDIMM device will be broken down into one or more
>> _regions_.  These regions are enumerated in the NVDIMM Region Mapping
>> Structure.  Each entry in this table contains the NVDIMM Device Handle
>> for the device the region is in, as well as the DPA range for the
>> region (called "NVDIMM Physical Address Base" and "NVDIMM Region Size"
>> in the spec).  Regions which are part of a PMEM namespace will have
>> references into SPA tables and interleave set tables; regions which
>> are part of PBLK namespaces will have references into control region
>> and block data window region structures.
>>
>> [acpi-spec]:
>> http://www.uefi.org/sites/default/files/resources/ACPI%206_2_A_Sept29.pdf
>>
>> ## Namespaces and the OS
>>
>> At boot time, the firmware will read the label regions from the NVDIMM
>> device and set up the memory controllers appropriately.  It will then
>> construct a table describing the resulting regions in a table called
>> an NFIT table, and expose that table via ACPI.

Labels are not involved in the creation of the NFIT. The NFIT only
defines PMEM ranges and interleave sets, the rest is left to the OS.

>> To use a namespace, an operating system needs at a minimum two pieces
>> of information: The UUID and/or Name of the namespace, and the SPA
>> range where that namespace is mapped; and ideally also the Type and
>> Abstraction Type to know how to interpret the data inside.

Not necessarily, no. Linux supports "label-less" mode where it exposes
the raw capacity of a region in 1:1 mapped namespace without a label.
This is how Linux supports "legacy" NVDIMMs that do not support
labels.

>> Unfortunately, the information needed to understand namespaces is
>> somewhat disjoint.  The namespace labels themselves contain the UUID,
>> Name, Type, and Abstraction Type, but don't contain any information
>> about SPA or block control / status registers and windows.  The NFIT
>> table contains a list of SPA Range Structures, which list the
>> NVDIMM-related SPA ranges and their Type GUID; as well as a table
>> containing individual DPA ranges, which specifies which SPAs they
>> correspond to.  But the NFIT does not contain the UUID or other
>> identifying information from the Namespace labels.  In order to
>> actually discover that namespace with UUID _X_ is mapped at SPA _Y-Z_,
>> an operating system must:
>>
>> 1. Read the label areas of all NVDIMMs and discover the DPA range and
>>    Interleave Set for namespace _X_
>> 2. Read the Region Mapping Structures from the NFIT table, and find
>>    out which structures match the DPA ranges for namespace _X_
>> 3. Find the System Physical Address Range Structure Index associated
>>    with the Region Mapping
>> 4. Look up the SPA Range Structure in the NFIT table using the SPA
>>    Range Structure Index
>> 5. Read the SPA range _Y-Z_

I'm not sure I'm grokking your distinction between 2, 3, 4? In any
event we do the DIMM to SPA association first before reading labels.
The OS calculates a so called "Interleave Set Cookie" from the NFIT
information to compare against a similar value stored in the labels.
This lets the OS determine that the Interleave Set composition has not
changed from when the labels were initially written. An Interleave Set
Cookie mismatch indicates the labels are stale, corrupted, or that the
physical composition of the Interleave Set has changed.

>> An OS driver can modify the namespaces by modifying the Label Storage
>> Areas of the corresponding DIMMs.  The NFIT table describes how the OS
>> can access the Label Storage Areas.  Label Storage Areas may be
>> "isolated", in which case the area would be accessed via
>> device-specific AML methods (DSM), or they may be exposed directly
>> using a well-known location.  AML methods to access the label areas
>> are "dumb": they are essentially a memcpy() which copies into or out
>> of a given {DIMM, Label Area Offest} address.  No checking for
>> validity of reads and writes is done, and simply modifying the labels
>> does not change the mapping immediately -- this must be done either by
>> the OS driver reprogramming the NVDIMM memory controller, or by
>> rebooting and allowing the firmware to it.

There are checksums in the Namespace definition to account label
validity. Starting with ACPI 6.2 DSMs for labels are deprecated in
favor of the new / named methods for label access _LSI, _LSR, and
_LSW.

>> Modifying labels is tricky, due to an issue that will be somewhat of a
>> recurring theme when discussing NVDIMMs: The necessity of assuming
>> that, at any given point in time, power may be suddenly cut, and the
>> system needing to be able to recover sensible data in such a
>> circumstance.  The [UEFI Specification][uefi-spec] chapter on the
>> NVDIMM label protocol specifies how the label area is to be modified
>> such that a consistent "view" is always available; and how firmware
>> and the operating system should respond consistently to labels which
>> appear corrupt.

Not that tricky :-).

>> ## NVDIMMs and filesystems
>>
>> Along the same line, most filesystems are written with the assumption
>> that a given write to a block device will either finish completely, or
>> be entirely reverted.  Since access to NVDIMMs (even in PBLK mode) are
>> essentially `memcpy`s, writes may well be interrupted halfway through,
>> resulting in _sector tearing_.  In order to help with this, the UEFI
>> spec defines method of reading and writing NVRAM which is capable of
>> emulating sector-atomic write semantics via a _block translation
>> layer_ (BTT) ([UEFI spec][uefi-spec], chapter 6, "Block Translation
>> Table (BTT) Layout").  Namespaces accessed via this discipline will
>> have a _BTT info block_ at the beginning of the namespace (similar to
>> a superblock on a traditional hard disk).  Additionally, the
>> AddressAbstraction GUID in the namespace label(s) should be set to
>> `EFI_BTT_ABSTRACTION_GUID`.
>>
>> ## Linux
>>
>> Linux has a _direct access_ (DAX) filesystem mount mode for block
>> devices which are "memory-like" ^[kernel-dax].  If both the filesystem
>> and the underlying device support DAX, and the `dax` mount option is
>> enabled, then when a file on that filesystem is `mmap`ed, the page
>> cache is bypassed and the underlying storage is mapped directly into
>> the user process. (?)
>>
>> [kernel-dax]: https://www.kernel.org/doc/Documentation/filesystems/dax.txt
>>
>> Linux has a tool called `ndctl` to manage NVDIMM namespaces.  From the
>> documentation it looks fairly well abstracted: you don't typically
>> specify individual DPAs when creating PBLK or PMEM regions: you
>> specify the type you want and the size and it works out the layout
>> details (?).
>>
>> The `ndctl` tool allows you to make PMEM namespaces in one of four
>> modes: `raw`, `sector`, `fsdax` (or `memory`), and `devdax` (or,
>> confusingly, `dax`).

Yes, apologies on the confusion. Going forward from ndctl-v60 we have
deprecated 'memory' and 'dax'.

>> The `raw`, `sector`, and `fsdax` modes all result in a block device in
>> the pattern of `/dev/pmemN[.M]`, in which a filesystem can be stored.
>> `devdax` results in a character device in the pattern of
>> `/dev/daxN[.M]`.
>>
>> It's not clear from the documentation exactly what `raw` mode is or
>> when it would be safe to use it.

We'll add some documentation to the man page, but 'raw' mode is
effectively just a ramdisk. No, dax support.

>>
>> `sector` mode implements `BTT`; it is thus safe against sector
>> tearing, but does not support mapping files in DAX mode.  The
>> namespace can be either PMEM or PBLK (?).  As described above, the
>> first block of the namespace will be a BTT info block.

The info block is not exposed in the user accessible data space as
this comment seems to imply. It's similar to a partition table it's on
media metadata that specifies an encapsulation.

>> `fsdax` and `devdax` mode are both designed to make it possible for
>> user processes to have direct mapping of NVRAM.  As such, both are
>> only suitable for PMEM namespaces (?).  Both also need to have kernel
>> page structures allocated for each page of NVRAM; this amounts to 64
>> bytes for every 4k of NVRAM.  Memory for these page structures can
>> either be allocated out of normal "system" memory, or inside the PMEM
>> namespace itself.
>>
>> In both cases, an "info block", very similar to the BTT info block, is
>> written to the beginning of the namespace when created.  This info
>> block specifies whether the page structures come from system memory or
>> from the namespace itself.  If from the namespace itself, it contains
>> information about what parts of the namespace have been set aside for
>> Linux to use for this purpose.
>>
>> Linux has also defined "Type GUIDs" for these two types of namespace
>> to be stored in the namespace label, although these are not yet in the
>> ACPI spec.

They never will be. One of the motivations for GUIDs is that an OS can
define private ones without needing to go back and standardize them.
Only GUIDs that are needed to inter-OS / pre-OS compatibility would
need to be defined in ACPI, and there is no expectation that other
OSes understand Linux's format for reserving page structure space.

>> Documentation seems to indicate that both `pmem` and `dax` devices can
>> be further subdivided (by mentioning `/dev/pmemN.M` and
>> `/dev/daxN.M`), but don't mention specifically how.  `pmem` devices,
>> being block devices, can presumuably be partitioned like a block
>> device can. `dax` devices may have something similar, or may have
>> their own subdivision mechanism.  The rest of this document will
>> assume that this is the case.

You can create multiple namespaces in a given region. Sub-sequent
namespaces after the first get the .1, .2, .3 etc suffix.

>>
>> # Xen considerations
>>
>> ## RAM and MMIO in Xen
>>
>> Xen generally has two types of things that can go into a pagetable or
>> p2m.  The first is RAM or "system memory".  RAM has a page struct,
>> which allows it to be accounted for on a page-by-page basis: Assigned
>> to a specific domain, reference counted, and so on.
>>
>> The second is MMIO.  MMIO areas do not have page structures, and thus
>> cannot be accounted on a page-by-page basis.  Xen knows about PCI
>> devices and the associated MMIO ranges, and makes sure that PV
>> pagetables or HVM p2m tables only contain MMIO mappings for devices
>> which have been assigned to a guest.
>>
>> ## Page structures
>>
>> To begin with, Xen, like Linux, needs page structs for NVDIMM
>> memory.  Without page structs, we don't have reference counts; which
>> means there's no safe way, for instance, for a guest to ask a PV
>> device to write into NVRAM owned by a guest; and no real way to be
>> confident that the same memory hadn't been mapped multiple times.
>>
>> Page structures in Xen are 32 bytes for non-BIGMEM systems (<5 TiB),
>> and 40 bytes for BIGMEM systems.
>>
>> ### Page structure allocation
>>
>> There are three potential places we could store page structs:
>>
>>  1. **System memory** Allocated from the host RAM
>>
>>  2. **Inside the namespace** Like Linux, there could be memory set
>>    aside inside the namespace set aside specifically for mapping that
>>    namespace.  This could be 2a) As a user-visible separate partition,
>>    or 2b) allocated by `ndctl` from the namespace "superblock".  As
>>    the page frame areas of the namespace can be discontiguous (?), it
>>    would be possible to enable or disable this extra space on an
>>    existing namespace, to allow users with existing vNVDIMM images to
>>    switch to or from Xen.

I think a Xen mode namespace makes sense. If I understand correctly it
would also need to house the struct page array at the same time in
case dom0 needs to do a get_user_pages() operation when assigning pmem
to a guest?

The other consideration is how to sub-divide that namespace for
handing it out to guests. We are currently working through problems
with virtualization and device-assignment when the guest is given
memory for a dax mapped file on a filesystem in dax mode. Given that
the filesytem can do physical layout rearrangement at will it means
that it is not suitable to give to guest. For now we require a devdax
mode namespace for mapping pmem to a guest so that we do not collide
with filesystem block map mutations.

I assume this "xen-mode" namespace would be something like devdax + mfn array.

>>
>>  3. **A different namespace** NVRAM could be set aside for use by
>>    arbitrary namespaces.  This could be a 3a) specially-selected
>>    partition from a normal namespace, or it could be 3b) a namespace
>>    specifically designed to be used for Xen (perhaps with its own Type
>>    GUID).
>>
>> 2b has the advantage that we should be able to unilaterally allocate a
>> Type GUID and start using it for that purpose.  It also has the
>> advantage that it should be somewhat easier for someone with existing
>> vNVDIMM images to switch into (or away from) using Xen.  It has the
>> disadvantage of being less transparent to the user.
>>
>> 3b has the advantage of being invisible to the user once being set up.
>> It has the slight disadvantage of having more gatekeepers to get
>> through; and if those gatekeepers aren't happy with enabling or
>> disabling extra frametable space for Xen after creation (or if I've
>> misunderstood and such functionality isn't straightforward to
>> implement) then it will be difficult for people with existing images
>> to switch to Xen.
>>
>> ### Dealing with changing frame tables
>>
>> Another potential issue to consider is the monolithic nature of the
>> current frame table.  At the moment, to find a page struct given an
>> mfn, you use the mfn as an index into a single large array.
>>
>> I think we can assume that NVDIMM SPA ranges will be separate from
>> normal system RAM.  There's no reason the frame table couldn't be
>> "sparse": i.e., only the sections of it that actually contain valid
>> pages need to have ram backing them.
>>
>> However, if we pursue a solution like Linux, where each namespace
>> contains memory set aside to use for its own pagetables, we may have a
>> situation where boundary between two namespaces falls in the middle of
>> a frame table page; in that case, from where should such a frame table
>> page be allocated?

It's already the case that the minimum alignment for multiple
namespaces is 128MB given the current "section size" assumptions of
the core mm. Can we make a similar alignment restriction for Xen to
eliminate this problem.?

>> A simple answer would be to use system RAM to "cover the gap": There
>> would only ever need to be a single page per boundary.
>>
>> ## Page tracking for domain 0
>>
>> When domain 0 adds or removes entries from its pagetables, it does not
>> explicitly store the memory type (i.e., whether RAM or MMIO); Xen
>> infers this from its knowledge of where RAM is and is not.  Below we
>> will explore design choices that involve domain 0 telling Xen about
>> NVDIMM namespaces, SPAs, and what it can use for page structures.  In
>> such a scenario, NVRAM pages essentially transition from being MMIO
>> (before Xen knows about them) to being RAM (after Xen knows about
>> them), which in turn has implications for any mappings which domain 0
>> has in its pagetables.
>>
>> ## PVH and QEMU
>>
>> A number of solutions have suggested using QEMU to provide emulated
>> NVDIMM support to guests.  This is a workable solution for HVM guests,
>> but for PVH guests we would like to avoid introducing a device model
>> if at all possible.
>>
>> ## FS DAX and DMA in Linux
>>
>> There is [an issue][linux-fs-dax-dma-issue] with DAX and filesystems,
>> in that filesystems (even those claiming to support DAX) may want to
>> rearrange the block<->file mapping "under the feet" of running
>> processes with mapped files.  Unfortunately, this is more tricky with
>> DAX than with a page cache, and as of [early 2018][linux-fs-dax-dma-2]
>> was essentially incompatible with virtualization. ("I think we need to
>> enforce this in the host kernel. I.e. do not allow file backed DAX
>> pages to be mapped in EPT entries unless / until we have a solution to
>> the DMA synchronization problem.")
>>
>> More needs to be discussed and investigated here; but for the time
>> being, mapping a file in a DAX filesystem into a guest's p2m is
>> probably not going to be possible.

Ah, you have the fsdax issue captured here, great.

>>
>> [linux-fs-dax-dma-issue]:
>> https://lists.01.org/pipermail/linux-nvdimm/2017-December/013704.html
>> [linux-fs-dax-dma-2]:
>> https://lists.nongnu.org/archive/html/qemu-devel/2018-01/msg07347.html
>>
>> # Target functionality
>>
>> The above sets the stage, but to actually determine on an architecture
>> we have to decide what kind of final functionality we're looking for.
>> The functionality falls into two broad areas: Functionality from the
>> host administrator's point of view (accessed from domain 0), and
>> functionality from the guest administrator's point of view.
>>
>> ## Domain 0 functionality
>>
>> For the purposes of this section, I shall be distinguishing between
>> "native Linux" functionality and "domain 0" functionality.  By "native
>> Linux" functionality I mean functionality which is available when
>> Linux is running on bare metal -- `ndctl`, `/dev/pmem`, `/dev/dax`,
>> and so on.  By "dom0 functionality" I mean functionality which is
>> available in domain 0 when Linux is running under Xen.
>>
>>  1. **Disjoint functionality** Have dom0 and native Linux
>>    functionality completely separate: namespaces created when booted
>>    on native Linux would not be accessible when booted under domain 0,
>>    and vice versa.  Some Xen-specific tool similar to `ndctl` would
>>    need to be developed for accessing functionality.

I'm open to teaching ndctl about Xen needs if that helps.

>>
>>  2. **Shared data but no dom0 functionality** Another option would be
>>    to have Xen and Linux have shared access to the same namespaces,
>>    but dom0 essentially have no direct access to the NVDIMM.  Xen
>>    would read the NFIT, parse namespaces, and expose those namespaces
>>    to dom0 like any other guest; but dom0 would not be able to create
>>    or modify namespaces.  To manage namespaces, an administrator would
>>    need to boot into native Linux, modify the namespaces, and then
>>    reboot into Xen again.

Ugh.

>>
>>  3. **Dom0 fully functional, Manual Xen frame table** Another level of
>>    functionality would be to make it possible for dom0 to have full
>>    parity with native Linux in terms of using `ndctl` to manage
>>    namespaces, but to require the host administrator to manually set
>>    aside NVRAM for Xen to use for frame tables.
>>
>>  4. **Dom0 fully functional, automatic Xen frame table** This is like
>>    the above, but with the Xen frame table space automatically
>>    managed, similar to Linux's: You'd simply specify that you wanted
>>    the Xen frametable somehow when you create the namespace, and from
>>    then on forget about it.
>>
>> Number 1 should be avoided if at all possible, in my opinion.
>>
>> Given that the NFIT table doesn't currently have namespace UUIDs or
>> other key pieces of information to fully understand the namespaces, it
>> seems like #2 would likely not be able to be made functional enough.
>>
>> Number 3 should be achievable under our control.  Obviously #4 would
>> be ideal, but might depend on getting cooperation from the Linux
>> NVDIMM maintainers to be able to set aside Xen frame table memory in
>> addition to Linux frame table memory.

"xen-mode" namespace?

>>
>> ## Guest functionality
>>
>>   1. **No remapping** The guest can take the PMEM device as-is.  It's
>>     mapped by the toolstack at a specific place in _guest physical
>>     address_ (GPA) space and cannot be moved.  There is no controller
>>     emulation (which would allow remapping) and minimal label area
>>     functionality.
>>
>>   2. **Full controller access for PMEM**.  The guest has full
>>     controller access for PMEM: it can carve up namespaces, change
>>     mappings in GPA space, and so on.

In it's own virtual label area, right?

>>   3. **Full controller access for both PMEM and PBLK**.  A guest has
>>     full controller access, and can carve up its NVRAM into arbitrary
>>     PMEM or PBLK regions, as it wants.

I'd forget about giving PBLK to guests, just use standard virtio or
equivalent to route requests to the dom0 driver. Unless the PBLK
control registers are mapped on 4K boundaries there's no safe way to
give individual guests their own direct PBLK access.

>>
>> Numbers 2 and 3 would of course be nice-to-have, but would almost
>> certainly involve having a QEMU qprocess to emulate them.  Since we'd
>> like to have PVH use NVDIMMs, we should at least make #1 an option.
>>
>> # Proposed design / roadmap
>>
>> Initially, dom0 accesses the NVRAM as normal, using static ACPI tables
>> and the DSM methods; mappings are treated by Xen during this phase as
>> MMIO.
>>
>> Once dom0 is ready to pass parts of a namespace through to a guest, it
>> makes a hypercall to tell Xen about the namespace.  It includes any
>> regions of the namespace which Xen may use for 'scratch'; it also
>> includes a flag to indicate whether this 'scratch' space may be used
>> for frame tables from other namespaces.
>>
>> Frame tables are then created for this SPA range.  They will be
>> allocated from, in this order: 1) designated 'scratch' range from
>> within this namespace 2) designated 'scratch' range from other
>> namespaces which has been marked as sharable 3) system RAM.
>>
>> Xen will either verify that dom0 has no existing mappings, or promote
>> the mappings to full pages (taking appropriate reference counts for
>> mappings).  Dom0 must ensure that this namespace is not unmapped,
>> modified, or relocated until it asks Xen to unmap it.
>>
>> For Xen frame tables, to begin with, set aside a partition inside a
>> namespace to be used by Xen.  Pass this in to Xen when activating the
>> namespace; this could be either 2a or 3a from "Page structure
>> allocation".  After that, we could decide which of the two more
>> streamlined approaches (2b or 3b) to pursue.
>>
>> At this point, dom0 can pass parts of the mapped namespace into
>> guests.  Unfortunately, passing files on a fsdax filesystem is
>> probably not safe; but we can pass in full dev-dax or fsdax
>> partitions.
>>
>> From a guest perspective, I propose we provide static NFIT only, no
>> access to labels to begin with.  This can be generated in hvmloader
>> and/or the toolstack acpi code.

I'm ignorant of Xen internals, but can you not reuse the existing QEMU
emulation for labels and NFIT?

Thanks for this thorough write up, it's always nice to see the tradeoffs.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
