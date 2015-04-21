Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hFgDscNX5JDp91p19ycpw7oSizLse1oFM4inc0MNEhiQ@mail.gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013525.25237.45181.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150420070624.GB13876@gmail.com>
	<CAPcyv4g8wAzWq34onfYKreoh+qEv6KWzaAmAmGnvW5KhoB07xA@mail.gmail.com>
	<20150420125338.GA5463@lst.de>
	<CAPcyv4hFgDscNX5JDp91p19ycpw7oSizLse1oFM4inc0MNEhiQ@mail.gmail.com>
Date: Tue, 21 Apr 2015 06:38:51 -0700
Message-ID: <CAPcyv4j3S1Cp8VAV+Amg_RV5KxRJEDQyD7VYTSdLpb8=e1Y6Hg@mail.gmail.com>
Subject: Re: [PATCH 02/21] ND NFIT-Defined/NVIDIMM Subsystem
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 20, 2015 at 8:57 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Apr 20, 2015 at 5:53 AM, Christoph Hellwig <hch@lst.de> wrote:
>> Once I'll go through this in more detail I'll comment more.
>
> Sounds good.

Given that the ACPICA folks are going to define their own nfit.h with
possibly different structure names, that damage should be limited to
just acpi.c.  Currently, changing nfit.h structure field names would
impact multiple files.  It's a straightforward rework to disentangle,
I'll post patches soon.
