Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3EE9E209603F8
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 17:31:37 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id a6-v6so17927836oia.2
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 17:31:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c418e1a5-0dc7-fc69-d4bd-ffcf64b95e8d@citrix.com>
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
 <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
 <b0ccf9f3-56f7-e061-a5b6-4c5e1bcbecb0@citrix.com>
 <CAPcyv4huEso9OHG65UvMh9vOp-yHOR9sptKpzSC_HhhtgbihOg@mail.gmail.com>
 <c418e1a5-0dc7-fc69-d4bd-ffcf64b95e8d@citrix.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 May 2018 17:31:35 -0700
Message-ID: <CAPcyv4jfevtJ7U5TO_6VgZxezas3FwnfYn0OgxGbeYED1ax+ZA@mail.gmail.com>
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

On Thu, May 17, 2018 at 7:52 AM, George Dunlap <george.dunlap@citrix.com> wrote:
> On 05/15/2018 07:06 PM, Dan Williams wrote:
>> On Tue, May 15, 2018 at 7:19 AM, George Dunlap <george.dunlap@citrix.com> wrote:
>>> So, who decides what this SPA range and interleave set is?  Can the
>>> operating system change these interleave sets and mappings, or change
>>> data from PMEM to BLK, and is so, how?
>>
>> The interleave-set to SPA range association and delineation of
>> capacity between PMEM and BLK access modes is current out-of-scope for
>> ACPI. The BIOS reports the configuration to the OS via the NFIT, but
>> the configuration is currently written by vendor specific tooling.
>> Longer term it would be great for this mechanism to become
>> standardized and available to the OS, but for now it requires platform
>> specific tooling to change the DIMM interleave configuration.
>
> OK -- I was sort of assuming that different hardware would have
> different drivers in Linux that ndctl knew how to drive (just like any
> other hardware with vendor-specific interfaces);

That way potentially lies madness, at least for me as a Linux
sub-system maintainer. There is no value for the kernel to help enable
vendors to do the same thing slightly differently ways. libnvdimm +
nfit is 100% an open standards driver and the hope is to be able to
deprecate non-public vendor-specific support over time, and
consolidate work-alike support from vendor specs into ACPI. The public
standards that the kernel enables are:

http://www.uefi.org/sites/default/files/resources/ACPI%206_2_A_Sept29.pdf
http://www.uefi.org/sites/default/files/resources/UEFI%20Spec%202_7_A%20Sept%206.pdf
http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf
https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/
https://msdn.microsoft.com/library/windows/hardware/mt604741

> but it sounds a bit
> more like at the moment it's binary blobs either in the BIOS/firmware,
> or a vendor-supplied tool.

Only for the functionality, like interleave set configuration, that is
not defined in those standards. Even then the impact is only userspace
tooling, not the kernel. Also, we are seeing that functionality bleed
into the standards over time. For example label methods used to only
exist in the Intel DSM document, but have now been standardized in
ACPI 6.2. Firmware update which was a private interface has now
graduated to the public Intel DSM document. Hopefully more and more
functionality transitions into an ACPI definition over time. Any
common functionality in those Intel, HPE, and MSFT command formats is
comprehended / abstracted by the ndctl tool.

>
>>> And so (here's another guess) -- when you're talking about namespaces
>>> and label areas, you're talking about namespaces stored *within a
>>> pre-existing SPA range*.  You use the same format as described in the
>>> UEFI spec, but ignore all the stuff about interleave sets and whatever,
>>> and use system physical addresses relative to the SPA range rather than
>>> DPAs.
>>
>> Well, we don't ignore it because we need to validate in the driver
>> that the interleave set configuration matches a checksum that we
>> generated when the namespace was first instantiated on the interleave
>> set. However, you are right, for accesses at run time all we care
>> about is the SPA for PMEM accesses.
> [snip]
>> They can change, but only under the control of the BIOS. All changes
>> to the interleave set configuration need a reboot because the memory
>> controller needs to be set up differently at system-init time.
> [snip]
>> No, the checksum I'm referring to is the interleave set cookie (see:
>> "SetCookie" in the UEFI 2.7 specification). It validates that the
>> interleave set backing the SPA has not changed configuration since the
>> last boot.
> [snip]
>> The NVDIMM just provides storage area for the OS to write opaque data
>> that just happens to conform to the UEFI Namespace label format. The
>> interleave-set configuration is stored in yet another out-of-band
>> location on the DIMM or on some platform-specific storage location and
>> is consulted / restored by the BIOS each boot. The NFIT is the output
>> from the platform specific physical mappings of the DIMMs, and
>> Namespaces are logical volumes built on top of those hard-defined NFIT
>> boundaries.
>
> OK, so what I'm hearing is:
>
> The label area isn't "within a pre-existing SPA range" as I was guessing
> (i.e., similar to a partition table residing within a disk); it is the
> per-DIMM label area as described by UEFI spec.
>
> But, the interleave set data in the label area doesn't *control* the
> hardware -- the NVDIMM controller / bios / firmware don't read it or do
> anything based on what's in it.  Rather, the interleave set data in the
> label area is there to *record*, for the operating system's benefit,
> what the hardware configuration was when the labels were created, so
> that if it changes, the OS knows that the label area is invalid; it must
> either refrain from touching the NVRAM (if it wants to preserve the
> data), or write a new label area.
>
> The OS can also use labels to partition a single SPA range into several
> namespaces.  It can't change the interleaving, but it can specify that
> [0-A) is one namespace, [A-B) is another namespace, &c; and these
> namespaces will naturally map into the SPA range advertised in the NFIT.
>
> And if a controller allows the same memory to be used either as PMEM or
> PBLK, it can write which *should* be used for which, and then can avoid
> accessing the same underlying NVRAM in two different ways (which will
> yield unpredictable results).
>
> That makes sense.

You got it.

>
>>> If SPA regions don't change after boot, and if Xen can find its own
>>> Xen-specific namespace to use for the frame tables by reading the NFIT
>>> table, then that significantly reduces the amount of interaction it
>>> needs with Linux.
>>>
>>> If SPA regions *can* change after boot, and if Xen must rely on Linux to
>>> read labels and find out what it can safely use for frame tables, then
>>> it makes things significantly more involved.  Not impossible by any
>>> means, but a lot more complicated.
>>>
>>> Hope all that makes sense -- thanks again for your help.
>>
>> I think it does, but it seems namespaces are out of reach for Xen
>> without some agent / enabling that can execute the necessary AML
>> methods.
>
> Sure, we're pretty much used to that. :-)  We'll have Linux read the
> label area and tell Xen what it needs to know.  But:
>
> * Xen can know the SPA ranges of all potential NVDIMMs before dom0
> starts.  So it can tell, for instance, if a page mapped by dom0 is
> inside an NVDIMM range, even if dom0 hasn't yet told it anything.
>
> * Linux doesn't actually need to map these NVDIMMs to read the label
> area and the NFIT and know where the PMEM namespaces live in system memory.

Theoretically we could support a mode where dom0 Linux just parses
namespaces, but never enables namespaces. That would be additional
enabling on top of what we have today. It would be similar to what we
do for "locked" DIMMs.

> With that sorted out, let me go back and see whether it makes sense to
> respond to your original response, or to write up a new design doc and
> send it out.
>
> Thanks for your help!

No problem. I had typed up this response earlier, but neglected to hit
send. That is now remedied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
