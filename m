Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150420125338.GA5463@lst.de>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013525.25237.45181.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150420070624.GB13876@gmail.com>
	<CAPcyv4g8wAzWq34onfYKreoh+qEv6KWzaAmAmGnvW5KhoB07xA@mail.gmail.com>
	<20150420125338.GA5463@lst.de>
Date: Mon, 20 Apr 2015 08:57:35 -0700
Message-ID: <CAPcyv4hFgDscNX5JDp91p19ycpw7oSizLse1oFM4inc0MNEhiQ@mail.gmail.com>
Subject: Re: [PATCH 02/21] ND NFIT-Defined/NVIDIMM Subsystem
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 20, 2015 at 5:53 AM, Christoph Hellwig <hch@lst.de> wrote:
> [I haven't much time to look through the patches, so only high level
>  hand wavey comments for now, sorry..]
>
> On Mon, Apr 20, 2015 at 01:14:42AM -0700, Dan Williams wrote:
>> > So why on earth is this whole concept and the naming itself
>> > ('drivers/block/nd/' stands for 'NFIT Defined', apparently) revolving
>> > around a specific 'firmware' mindset and revolving around specific,
>> > weirdly named, overly complicated looking firmware interfaces that
>> > come with their own new weird glossary??
>>
>> There's only three core properties of NVDIMMs that this implementation
>> cares about.
>>
>> 1/ directly mapped interleaved persistent memory (PMEM)
>> 2/ indirect mmio aperture accessed (windowed) persistent memory (BLK)
>> 3/ the possibility that those 2 access modes may alias the same
>> on-media addresses
>>
>> Most of complexity of the implementation is dealing with aspect 3, but
>> that complexity can and is bypassed in places.
>>
>> > Firmware might be a discovery method - or not. A non-volatile device
>> > might be e820 enumerated, or PCI discovered - potentially with all
>> > discovery handled by the driver.
>>
>> PCI attached non-volatile memory is NVMe.  ND is handling address
>> ranges that support direct cpu load store.
>
> But those can't be attached in all kinds of different ways.  It's not like
> this is a new thing - they've been used in Storage OEM systems for a long
> time, both on Intel platforms and other CPUs.
>
> And the current pmem.c can also handle cases like a PCI card exposing
> a large mmio region that can be used as persistent memory.
>
> So a big vote from me into naming this the pmem subsystem and trying
> to have names not too tied to one specific firmware interface.

While I understand a kernel developer's natural aversion to anything
committee defined, NFIT does seem be a superset of all the base
mechanisms needed to describe NVDIMM resources.  Also, it's worth
noting that meaning of 'N' in ND is purposefully vague.  The whole
point of listing it as "Nfit-Defined / NvDimm Subsystem" was to
indicate that ND is generic and could also refer generally to
"Non-volatile-Devices".  What's missing, in my opinion, is an existing
NVDIMM platform that would like to leverage some of base enabling that
this sub-system provides and will never have an NFIT capability.  In
the absence of alternative concerns/implementations we reached for
NFIT terminology out of convenience, but I'm all up for deprecating
"NFIT-Defined" as one of the meanings of 'ND'.

> Once I'll go through this in more detail I'll comment more.

Sounds good.
