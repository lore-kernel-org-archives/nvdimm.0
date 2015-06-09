Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1433874431.32607.37.camel@linux.intel.com>
Subject: Re: [PATCH v5 18/21] nd_btt: atomic sector updates
From: Vishal Verma <vishal.l.verma@linux.intel.com>
Date: Tue, 09 Jun 2015 12:27:11 -0600
In-Reply-To: <20150609064425.GF9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150602001546.4506.15713.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150609064425.GF9804@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-06-09 at 08:44 +0200, Christoph Hellwig wrote:
> I really want to see a good explanation why this is not a blk-mq driver
> given that it does fairly substantial work and has synchronization
> in its make_request function.

The biggest reason, I think, is that the BTT (just like pmem, brd etc),
does all its IOs synchronously. There isn't any queuing being done by
the device.

There are three places where we do synchronization in the BTT. Two of
them - map locks, and lanes are intrinsic to the BTT algorithm, so the
one you referred to must be the 'RTT' (the path that stalls writes if
the free block they picked to write to is being read from). My reasoning
is that since we're talking about DRAM-like speeds,  and the reader(s)
will be reading at most one LBA, the wait for the writer is really
bounded, and queuing and switching to a different IO on a CPU seems more
expensive than just waiting out the readers.

Even for the lane locks, we did a comparison between two lane lock
strategies - first where we kept an atomic counter around that tracked
which was the last lane that was used, and 'our' lane was determined by
atomically incrementing that. That way, if there are more CPUs than
lanes available, theoretically, no CPU would be blocked waiting for a
lane. The other strategy was to use the cpu number we're scheduled on to
and hash it to a lane number. Theoretically, this could block an IO that
could've otherwise run using a different, free lane. But some fio
workloads showed that the direct cpu -> lane hash performed faster than
tracking 'last lane' - my reasoning is the cache thrash caused by moving
the atomic variable made that approach slower than simply waiting out
the in-progress IO. Wouldn't adding to a queue be even more overhead
than a bit of cache thrash on a single variable?

The devices being synchronous, there is also no question of async
completions that might need to be handled - so I don't really see any
benefits that request queues might get us. Allow me to turn the question
around, and ask what will blk-mq get us?

Thanks,
	-Vishal

