Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 20 Apr 2015 14:53:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/21] ND NFIT-Defined/NVIDIMM Subsystem
Message-ID: <20150420125338.GA5463@lst.de>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com> <20150418013525.25237.45181.stgit@dwillia2-desk3.amr.corp.intel.com> <20150420070624.GB13876@gmail.com> <CAPcyv4g8wAzWq34onfYKreoh+qEv6KWzaAmAmGnvW5KhoB07xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g8wAzWq34onfYKreoh+qEv6KWzaAmAmGnvW5KhoB07xA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

[I haven't much time to look through the patches, so only high level
 hand wavey comments for now, sorry..]

On Mon, Apr 20, 2015 at 01:14:42AM -0700, Dan Williams wrote:
> > So why on earth is this whole concept and the naming itself
> > ('drivers/block/nd/' stands for 'NFIT Defined', apparently) revolving
> > around a specific 'firmware' mindset and revolving around specific,
> > weirdly named, overly complicated looking firmware interfaces that
> > come with their own new weird glossary??
> 
> There's only three core properties of NVDIMMs that this implementation
> cares about.
> 
> 1/ directly mapped interleaved persistent memory (PMEM)
> 2/ indirect mmio aperture accessed (windowed) persistent memory (BLK)
> 3/ the possibility that those 2 access modes may alias the same
> on-media addresses
> 
> Most of complexity of the implementation is dealing with aspect 3, but
> that complexity can and is bypassed in places.
> 
> > Firmware might be a discovery method - or not. A non-volatile device
> > might be e820 enumerated, or PCI discovered - potentially with all
> > discovery handled by the driver.
> 
> PCI attached non-volatile memory is NVMe.  ND is handling address
> ranges that support direct cpu load store.

But those can't be attached in all kinds of different ways.  It's not like
this is a new thing - they've been used in Storage OEM systems for a long
time, both on Intel platforms and other CPUs.

And the current pmem.c can also handle cases like a PCI card exposing
a large mmio region that can be used as persistent memory.

So a big vote from me into namving this the pmem subsystem and trying
to have names not too tied to one specific firmware interface.  Once
I'll go through this in more detail I'll comment more.
