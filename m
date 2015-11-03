Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 15:48:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 02/15] dax: increase granularity of dax_clear_blocks()
 operations
Message-ID: <20151103044802.GP10656@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151102042952.6610.7185.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151103005113.GN10656@dastard>
 <CAPcyv4jDVRz79-iucQRjBdGyZ6Bc=UVDBJkmORugBMZ8Pm4RnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jDVRz79-iucQRjBdGyZ6Bc=UVDBJkmORugBMZ8Pm4RnQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 02, 2015 at 07:27:26PM -0800, Dan Williams wrote:
> On Mon, Nov 2, 2015 at 4:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Nov 01, 2015 at 11:29:53PM -0500, Dan Williams wrote:
> > The zeroing (and the data, for that matter) doesn't need to be
> > committed to persistent store until the allocation is written and
> > committed to the journal - that will happen with a REQ_FLUSH|REQ_FUA
> > write, so it makes sense to deploy the big hammer and delay the
> > blocking CPU cache flushes until the last possible moment in cases
> > like this.
> 
> In pmem terms that would be a non-temporal memset plus a delayed
> wmb_pmem at REQ_FLUSH time.  Better to write around the cache than
> loop over the dirty-data issuing flushes after the fact.  We'll bump
> the priority of the non-temporal memset implementation.

Why is it better to do two synchronous physical writes to memory
within a couple of microseconds of CPU time rather than writing them
through the cache and, in most cases, only doing one physical write
to memory in a separate context that expects to wait for a flush
to complete?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
