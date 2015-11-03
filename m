Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 14:18:27 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 14/15] dax: dirty extent notification
Message-ID: <20151103211827.GE23366@linux.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151103011653.GO10656@dastard>
 <CAPcyv4hof4rVN0EZHhV9Q7VBE0WMw6hcSrLK-HvB5FOrOwY+tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hof4rVN0EZHhV9Q7VBE0WMw6hcSrLK-HvB5FOrOwY+tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 02, 2015 at 08:56:24PM -0800, Dan Williams wrote:
> On Mon, Nov 2, 2015 at 5:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Nov 01, 2015 at 11:30:58PM -0500, Dan Williams wrote:
<>
> > Yes, that's a basic feature of Ross's patches. Hence I think this
> > special case DAX<->bdev interface is the wrong direction to be
> > taking.
> 
> So here's my problem with the "track dirty mappings" in the core
> mm/vfs approach, it's harder to unwind and delete when it turns out no
> application actually needs it, or the platform gives us an O(1) flush
> method that is independent of dirty pte tracking.

I don't think that we'll ever be able to "unwind and delete" the dirty page
tracking.  Even if *some* platform gives us an 0(1) flush method independent
of PTE tracking, that will be an optimized path that will need to live along
side the path that we'll need to keep for other architectures (like all the
ones that exist today).
