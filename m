Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from SMTP03.CITRIX.COM (smtp03.citrix.com [162.221.156.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7C56207E4DE3
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 07:52:26 -0700 (PDT)
Subject: Re: Draft NVDIMM proposal
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
 <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
 <b0ccf9f3-56f7-e061-a5b6-4c5e1bcbecb0@citrix.com>
 <CAPcyv4huEso9OHG65UvMh9vOp-yHOR9sptKpzSC_HhhtgbihOg@mail.gmail.com>
From: George Dunlap <george.dunlap@citrix.com>
Message-ID: <c418e1a5-0dc7-fc69-d4bd-ffcf64b95e8d@citrix.com>
Date: Thu, 17 May 2018 15:52:22 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4huEso9OHG65UvMh9vOp-yHOR9sptKpzSC_HhhtgbihOg@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Cooper <Andrew.Cooper3@citrix.com>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, Jan Beulich <JBeulich@suse.com>, Yi Zhang <yi.z.zhang@intel.com>, Roger Pau Monne <roger.pau@citrix.com>
List-ID: <linux-nvdimm@lists.01.org>

On 05/15/2018 07:06 PM, Dan Williams wrote:
> On Tue, May 15, 2018 at 7:19 AM, George Dunlap <george.dunlap@citrix.com> wrote:
>> So, who decides what this SPA range and interleave set is?  Can the
>> operating system change these interleave sets and mappings, or change
>> data from PMEM to BLK, and is so, how?
> 
> The interleave-set to SPA range association and delineation of
> capacity between PMEM and BLK access modes is current out-of-scope for
> ACPI. The BIOS reports the configuration to the OS via the NFIT, but
> the configuration is currently written by vendor specific tooling.
> Longer term it would be great for this mechanism to become
> standardized and available to the OS, but for now it requires platform
> specific tooling to change the DIMM interleave configuration.

OK -- I was sort of assuming that different hardware would have
different drivers in Linux that ndctl knew how to drive (just like any
other hardware with vendor-specific interfaces); but it sounds a bit
more like at the moment it's binary blobs either in the BIOS/firmware,
or a vendor-supplied tool.

>> And so (here's another guess) -- when you're talking about namespaces
>> and label areas, you're talking about namespaces stored *within a
>> pre-existing SPA range*.  You use the same format as described in the
>> UEFI spec, but ignore all the stuff about interleave sets and whatever,
>> and use system physical addresses relative to the SPA range rather than
>> DPAs.
> 
> Well, we don't ignore it because we need to validate in the driver
> that the interleave set configuration matches a checksum that we
> generated when the namespace was first instantiated on the interleave
> set. However, you are right, for accesses at run time all we care
> about is the SPA for PMEM accesses.
[snip]
> They can change, but only under the control of the BIOS. All changes
> to the interleave set configuration need a reboot because the memory
> controller needs to be set up differently at system-init time.
[snip]
> No, the checksum I'm referring to is the interleave set cookie (see:
> "SetCookie" in the UEFI 2.7 specification). It validates that the
> interleave set backing the SPA has not changed configuration since the
> last boot.
[snip]
> The NVDIMM just provides storage area for the OS to write opaque data
> that just happens to conform to the UEFI Namespace label format. The
> interleave-set configuration is stored in yet another out-of-band
> location on the DIMM or on some platform-specific storage location and
> is consulted / restored by the BIOS each boot. The NFIT is the output
> from the platform specific physical mappings of the DIMMs, and
> Namespaces are logical volumes built on top of those hard-defined NFIT
> boundaries.

OK, so what I'm hearing is:

The label area isn't "within a pre-existing SPA range" as I was guessing
(i.e., similar to a partition table residing within a disk); it is the
per-DIMM label area as described by UEFI spec.

But, the interleave set data in the label area doesn't *control* the
hardware -- the NVDIMM controller / bios / firmware don't read it or do
anything based on what's in it.  Rather, the interleave set data in the
label area is there to *record*, for the operating system's benefit,
what the hardware configuration was when the labels were created, so
that if it changes, the OS knows that the label area is invalid; it must
either refrain from touching the NVRAM (if it wants to preserve the
data), or write a new label area.

The OS can also use labels to partition a single SPA range into several
namespaces.  It can't change the interleaving, but it can specify that
[0-A) is one namespace, [A-B) is another namespace, &c; and these
namespaces will naturally map into the SPA range advertised in the NFIT.

And if a controller allows the same memory to be used either as PMEM or
PBLK, it can write which *should* be used for which, and then can avoid
accessing the same underlying NVRAM in two different ways (which will
yield unpredictable results).

That makes sense.

>> If SPA regions don't change after boot, and if Xen can find its own
>> Xen-specific namespace to use for the frame tables by reading the NFIT
>> table, then that significantly reduces the amount of interaction it
>> needs with Linux.
>>
>> If SPA regions *can* change after boot, and if Xen must rely on Linux to
>> read labels and find out what it can safely use for frame tables, then
>> it makes things significantly more involved.  Not impossible by any
>> means, but a lot more complicated.
>>
>> Hope all that makes sense -- thanks again for your help.
> 
> I think it does, but it seems namespaces are out of reach for Xen
> without some agent / enabling that can execute the necessary AML
> methods.

Sure, we're pretty much used to that. :-)  We'll have Linux read the
label area and tell Xen what it needs to know.  But:

* Xen can know the SPA ranges of all potential NVDIMMs before dom0
starts.  So it can tell, for instance, if a page mapped by dom0 is
inside an NVDIMM range, even if dom0 hasn't yet told it anything.

* Linux doesn't actually need to map these NVDIMMs to read the label
area and the NFIT and know where the PMEM namespaces live in system memory.

With that sorted out, let me go back and see whether it makes sense to
respond to your original response, or to write up a new design doc and
send it out.

Thanks for your help!

 -George
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
