Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from SMTP03.CITRIX.COM (smtp03.citrix.com [162.221.156.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00E35209603EB
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 07:19:12 -0700 (PDT)
Subject: Re: Draft NVDIMM proposal
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
 <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
From: George Dunlap <george.dunlap@citrix.com>
Message-ID: <b0ccf9f3-56f7-e061-a5b6-4c5e1bcbecb0@citrix.com>
Date: Tue, 15 May 2018 15:19:08 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
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

On 05/11/2018 05:33 PM, Dan Williams wrote:
> [ adding linux-nvdimm ]
> 
> Great write up! Some comments below...

Thanks for the quick response!

It seems I still have some fundamental misconceptions about what's going
on, so I'd better start with that. :-)

Here's the part that I'm having a hard time getting.

If actual data on the NVDIMMs is a noun, and the act of writing is a
verb, then the SPA and interleave sets are adverbs: they define *how*
the write happens.  When the processor says, "Write to address X", the
memory controller converts address X into a <dimm number, dimm-physical
address> tuple to actually write the data.

So, who decides what this SPA range and interleave set is?  Can the
operating system change these interleave sets and mappings, or change
data from PMEM to BLK, and is so, how?

If you read through section 13.19 of the UEFI manual, it seems to imply
that this is determined by the label area -- that each DIMM has a
separate label area describing regions local to that DIMM; and that if
you have 4 DIMMs you'll have 4 label areas, and each label area will
have a label describing the DPA region on that DIMM which corresponds to
the interleave set.  And somehow someone sets up the interleave sets and
SPA based on what's written there.

Which would mean that an operating system could change how the
interleave sets work by rewriting the various labels on the DIMMs; for
instance, changing a single 4-way set spanning the entirety of 4 DIMMs,
to one 4-way set spanning half of 4 DIMMs, and 2 2-way sets spanning
half of 2 DIMMs each.

But then you say:

> Unlike NVMe an NVDIMM itself has no concept of namespaces. Some DIMMs
> provide a "label area" which is an out-of-band non-volatile memory
> area where the OS can store whatever it likes. The UEFI 2.7
> specification defines a data format for the definition of namespaces
> on top of persistent memory ranges advertised to the OS via the ACPI
> NFIT structure.

OK, so that sounds like no, that's that what happens.  So where do the
SPA range and interleave sets come from?

Random guess: The BIOS / firmware makes it up.  Either it's hard-coded,
or there's some menu in the BIOS you can use to change things around;
but once it hits the operating system, that's it -- the mapping of SPA
range onto interleave sets onto DIMMs is, from the operating system's
point of view, fixed.

And so (here's another guess) -- when you're talking about namespaces
and label areas, you're talking about namespaces stored *within a
pre-existing SPA range*.  You use the same format as described in the
UEFI spec, but ignore all the stuff about interleave sets and whatever,
and use system physical addresses relative to the SPA range rather than
DPAs.

Is that right?

But then there's things like this:

> There is no obligation for an NVDIMM to provide a label area, and as
> far as I know all NVDIMMs on the market today do not provide a label
> area.
[snip]
> Linux supports "label-less" mode where it exposes
> the raw capacity of a region in 1:1 mapped namespace without a label.
> This is how Linux supports "legacy" NVDIMMs that do not support
> labels.

So are "all NVDIMMs on the market today" then classed as "legacy"
NVDIMMs because they don't support labels?  And if labels are simply the
NVDIMM equivalent of a partition table, then what does it mena to
"support" or "not support" labels?

And then there's this:

> In any
> event we do the DIMM to SPA association first before reading labels.
> The OS calculates a so called "Interleave Set Cookie" from the NFIT
> information to compare against a similar value stored in the labels.
> This lets the OS determine that the Interleave Set composition has not
> changed from when the labels were initially written. An Interleave Set
> Cookie mismatch indicates the labels are stale, corrupted, or that the
> physical composition of the Interleave Set has changed.

So wait, the SPA and interleave sets can actually change?  And the
labels which the OS reads actually are per-DIMM, and do control somehow
how the DPA ranges of individual DIMMs are mapped into interleave sets
and exposed as SPAs?  (And perhaps, can be changed by the operating system?)

And:

> There are checksums in the Namespace definition to account label
> validity. Starting with ACPI 6.2 DSMs for labels are deprecated in
> favor of the new / named methods for label access _LSI, _LSR, and
> _LSW.

Does this mean the methods will use checksums to verify writes to the
label area, and refuse writes which create invalid labels?

If all of the above is true, then in what way can it be said that
"NVDIMM has no concept of namespaces", that an OS can "store whatever it
likes" in the label area, and that UEFI namespaces are "on top of
persistent memory ranges advertised to the OS via the ACPI NFIT structure"?

I'm sorry if this is obvious, but I am exactly as confused as I was
before I started writing this. :-)

This is all pretty foundational.  Xen can read static ACPI tables, but
it can't do AML.  So to do a proper design for Xen, we need to know:
1. If Xen can find out, without Linux's help, what namespaces exist and
if there is one it can use for its own purposes
2. If the SPA regions can change at runtime.

If SPA regions don't change after boot, and if Xen can find its own
Xen-specific namespace to use for the frame tables by reading the NFIT
table, then that significantly reduces the amount of interaction it
needs with Linux.

If SPA regions *can* change after boot, and if Xen must rely on Linux to
read labels and find out what it can safely use for frame tables, then
it makes things significantly more involved.  Not impossible by any
means, but a lot more complicated.

Hope all that makes sense -- thanks again for your help.

 -George
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
