Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x230.google.com (mail-ot0-x230.google.com
 [IPv6:2607:f8b0:4003:c0f::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 54386209603F2
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 11:06:54 -0700 (PDT)
Received: by mail-ot0-x230.google.com with SMTP id 15-v6so1249621otn.12
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 11:06:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b0ccf9f3-56f7-e061-a5b6-4c5e1bcbecb0@citrix.com>
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
 <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
 <b0ccf9f3-56f7-e061-a5b6-4c5e1bcbecb0@citrix.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 May 2018 11:06:53 -0700
Message-ID: <CAPcyv4huEso9OHG65UvMh9vOp-yHOR9sptKpzSC_HhhtgbihOg@mail.gmail.com>
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

On Tue, May 15, 2018 at 7:19 AM, George Dunlap <george.dunlap@citrix.com> wrote:
> On 05/11/2018 05:33 PM, Dan Williams wrote:
>> [ adding linux-nvdimm ]
>>
>> Great write up! Some comments below...
>
> Thanks for the quick response!
>
> It seems I still have some fundamental misconceptions about what's going
> on, so I'd better start with that. :-)
>
> Here's the part that I'm having a hard time getting.
>
> If actual data on the NVDIMMs is a noun, and the act of writing is a
> verb, then the SPA and interleave sets are adverbs: they define *how*
> the write happens.  When the processor says, "Write to address X", the
> memory controller converts address X into a <dimm number, dimm-physical
> address> tuple to actually write the data.
>
> So, who decides what this SPA range and interleave set is?  Can the
> operating system change these interleave sets and mappings, or change
> data from PMEM to BLK, and is so, how?

The interleave-set to SPA range association and delineation of
capacity between PMEM and BLK access modes is current out-of-scope for
ACPI. The BIOS reports the configuration to the OS via the NFIT, but
the configuration is currently written by vendor specific tooling.
Longer term it would be great for this mechanism to become
standardized and available to the OS, but for now it requires platform
specific tooling to change the DIMM interleave configuration.

> If you read through section 13.19 of the UEFI manual, it seems to imply
> that this is determined by the label area -- that each DIMM has a
> separate label area describing regions local to that DIMM; and that if
> you have 4 DIMMs you'll have 4 label areas, and each label area will
> have a label describing the DPA region on that DIMM which corresponds to
> the interleave set.  And somehow someone sets up the interleave sets and
> SPA based on what's written there.
>
> Which would mean that an operating system could change how the
> interleave sets work by rewriting the various labels on the DIMMs; for
> instance, changing a single 4-way set spanning the entirety of 4 DIMMs,
> to one 4-way set spanning half of 4 DIMMs, and 2 2-way sets spanning
> half of 2 DIMMs each.

If a DIMM supports both the PMEM and BLK mechanisms for accessing the
same DPA, then the label breaks the disambiguation and tells the OS to
enforce one access mechanism per DPA at a time. Otherwise the OS has
no ability to affect the interleave-set configuration, it's all
initialized by platform BIOS/firmware before the OS boots.

>
> But then you say:
>
>> Unlike NVMe an NVDIMM itself has no concept of namespaces. Some DIMMs
>> provide a "label area" which is an out-of-band non-volatile memory
>> area where the OS can store whatever it likes. The UEFI 2.7
>> specification defines a data format for the definition of namespaces
>> on top of persistent memory ranges advertised to the OS via the ACPI
>> NFIT structure.
>
> OK, so that sounds like no, that's that what happens.  So where do the
> SPA range and interleave sets come from?
>
> Random guess: The BIOS / firmware makes it up.  Either it's hard-coded,
> or there's some menu in the BIOS you can use to change things around;
> but once it hits the operating system, that's it -- the mapping of SPA
> range onto interleave sets onto DIMMs is, from the operating system's
> point of view, fixed.

Correct.

> And so (here's another guess) -- when you're talking about namespaces
> and label areas, you're talking about namespaces stored *within a
> pre-existing SPA range*.  You use the same format as described in the
> UEFI spec, but ignore all the stuff about interleave sets and whatever,
> and use system physical addresses relative to the SPA range rather than
> DPAs.

Well, we don't ignore it because we need to validate in the driver
that the interleave set configuration matches a checksum that we
generated when the namespace was first instantiated on the interleave
set. However, you are right, for accesses at run time all we care
about is the SPA for PMEM accesses.

>
> Is that right?
>
> But then there's things like this:
>
>> There is no obligation for an NVDIMM to provide a label area, and as
>> far as I know all NVDIMMs on the market today do not provide a label
>> area.
> [snip]
>> Linux supports "label-less" mode where it exposes
>> the raw capacity of a region in 1:1 mapped namespace without a label.
>> This is how Linux supports "legacy" NVDIMMs that do not support
>> labels.
>
> So are "all NVDIMMs on the market today" then classed as "legacy"
> NVDIMMs because they don't support labels?  And if labels are simply the
> NVDIMM equivalent of a partition table, then what does it mena to
> "support" or "not support" labels?

Yes, the term "legacy" has been thrown around for NVDIMMs that do not
support labels. The way this support is determined is whether the
platform publishes the _LSI, _LSR, and _LSW methods in ACPI (see:
6.5.10 NVDIMM Label Methods in ACPI 6.2a). I.e. each DIMM is
represented by an ACPI device object, and we query those objects for
these named methods. When the methods are missing *or* there is no
initialized namespace index block found on the DIMMs, Linux will fall
back to the "label-less" mode.

>
> And then there's this:
>
>> In any
>> event we do the DIMM to SPA association first before reading labels.
>> The OS calculates a so called "Interleave Set Cookie" from the NFIT
>> information to compare against a similar value stored in the labels.
>> This lets the OS determine that the Interleave Set composition has not
>> changed from when the labels were initially written. An Interleave Set
>> Cookie mismatch indicates the labels are stale, corrupted, or that the
>> physical composition of the Interleave Set has changed.
>
> So wait, the SPA and interleave sets can actually change?  And the
> labels which the OS reads actually are per-DIMM, and do control somehow
> how the DPA ranges of individual DIMMs are mapped into interleave sets
> and exposed as SPAs?  (And perhaps, can be changed by the operating system?)

They can change, but only under the control of the BIOS. All changes
to the interleave set configuration need a reboot because the memory
controller needs to be set up differently at system-init time.

>
> And:
>
>> There are checksums in the Namespace definition to account label
>> validity. Starting with ACPI 6.2 DSMs for labels are deprecated in
>> favor of the new / named methods for label access _LSI, _LSR, and
>> _LSW.
>
> Does this mean the methods will use checksums to verify writes to the
> label area, and refuse writes which create invalid labels?

No, the checksum I'm referring to is the interleave set cookie (see:
"SetCookie" in the UEFI 2.7 specification). It validates that the
interleave set backing the SPA has not changed configuration since the
last boot.

>
> If all of the above is true, then in what way can it be said that
> "NVDIMM has no concept of namespaces", that an OS can "store whatever it
> likes" in the label area, and that UEFI namespaces are "on top of
> persistent memory ranges advertised to the OS via the ACPI NFIT structure"?

The NVDIMM just provides storage area for the OS to write opaque data
that just happens to conform to the UEFI Namespace label format. The
interleave-set configuration is stored in yet another out-of-band
location on the DIMM or on some platform-specific storage location and
is consulted / restored by the BIOS each boot. The NFIT is the output
from the platform specific physical mappings of the DIMMs, and
Namespaces are logical volumes built on top of those hard-defined NFIT
boundaries.

>
> I'm sorry if this is obvious, but I am exactly as confused as I was
> before I started writing this. :-)
>
> This is all pretty foundational.  Xen can read static ACPI tables, but
> it can't do AML.  So to do a proper design for Xen, we need to know:

Oooh, ok, no AML in Xen...

> 1. If Xen can find out, without Linux's help, what namespaces exist and
> if there is one it can use for its own purposes

Yeah, no, not without calling AML methods.

> 2. If the SPA regions can change at runtime.

Nope, these are statically defined and can only change at reboot, if
at all. A likely scenario is that an OEM ships the DIMMs already
configured in an interleave-set and, barring component failure,
nothing changes for the life of the platform.

> If SPA regions don't change after boot, and if Xen can find its own
> Xen-specific namespace to use for the frame tables by reading the NFIT
> table, then that significantly reduces the amount of interaction it
> needs with Linux.
>
> If SPA regions *can* change after boot, and if Xen must rely on Linux to
> read labels and find out what it can safely use for frame tables, then
> it makes things significantly more involved.  Not impossible by any
> means, but a lot more complicated.
>
> Hope all that makes sense -- thanks again for your help.

I think it does, but it seems namespaces are out of reach for Xen
without some agent / enabling that can execute the necessary AML
methods.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
