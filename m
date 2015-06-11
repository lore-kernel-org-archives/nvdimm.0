Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150611201147.25175.87146.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150611201147.25175.87146.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 11 Jun 2015 13:22:48 -0700
Message-ID: <CAPcyv4jwyqkJZ6cd3eZzbhmrv5zpgmMWRo9DVRSMFC+KqVHEAA@mail.gmail.com>
Subject: Re: [PATCH v6 18/21] nd_btt: atomic sector updates
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 11, 2015 at 1:11 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> From: Vishal Verma <vishal.l.verma@linux.intel.com>
>
> BTT stands for Block Translation Table, and is a way to provide power
> fail sector atomicity semantics for block devices that have the ability
> to perform byte granularity IO. It relies on the capability of libnvdimm
> namespace devices to do byte aligned IO.
>
> The BTT works as a stacked blocked device, and reserves a chunk of space
> from the backing device for its accounting metadata. It is a bio-based
> driver because all IO is done synchronously, and there is no queuing or
> asynchronous completions at either the device or the driver level.
>
> The BTT uses 'lanes' to index into various 'on-disk' data structures,
> and lanes also act as a synchronization mechanism in case there are more
> CPUs than available lanes. We did a comparison between two lane lock
> strategies - first where we kept an atomic counter around that tracked
> which was the last lane that was used, and 'our' lane was determined by
> atomically incrementing that. That way, for the nr_cpus > nr_lanes case,
> theoretically, no CPU would be blocked waiting for a lane. The other
> strategy was to use the cpu number we're scheduled on to and hash it to
> a lane number. Theoretically, this could block an IO that could've
> otherwise run using a different, free lane. But some fio workloads
> showed that the direct cpu -> lane hash performed faster than tracking
> 'last lane' - my reasoning is the cache thrash caused by moving the
> atomic variable made that approach slower than simply waiting out the
> in-progress IO. This supports the conclusion that the driver can be a
> very simple bio-based one that does synchronous IOs instead of queuing.
>

Copy / paste error... following 2 paragraphs were from the previous
version of this patch and will be deleted when pushing upstream.

> BTT stands for Block Translation Table, and is a way to provide power
> fail sector atomicity semantics for block devices that have the ability
> to perform byte granularity IO. It relies on the ->rw_bytes() capability
> of libnd namespace devices.
>
> The BTT works as a stacked blocked device, and reserves a chunk of space
> from the backing device for its accounting metadata.
