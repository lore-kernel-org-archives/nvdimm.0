From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [patch] nd_blk,nd_pmem,nd_btt: add endio blktrace events
Date: Tue, 15 Nov 2016 21:56:57 -0700
Message-ID: <20161116045657.GA30049@linux.intel.com>
References: <x49twbgo4i6.fsf@segfault.boston.devel.redhat.com>
 <20161109191715.GA20314@infradead.org>
 <x49mvh8o3fx.fsf@segfault.boston.devel.redhat.com>
 <20161109193441.GA17343@infradead.org>
 <x49inrwo2v5.fsf@segfault.boston.devel.redhat.com>
 <20161110193333.GA10865@infradead.org>
 <x4937iyf4mp.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x4937iyf4mp.fsf@segfault.boston.devel.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, linux-nvdimm@ml01.01.org, axboe@kernel.dk
List-Id: linux-nvdimm@lists.01.org

On Fri, Nov 11, 2016 at 09:55:10AM -0500, Jeff Moyer wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Wed, Nov 09, 2016 at 02:43:58PM -0500, Jeff Moyer wrote:
> >> But on the issue side, we have different trace actions: Q vs. I.  On the
> >> completion side, we just have C.  You'd end up getting two C events for
> >> each Q, and that may confuse existing utilities (such as blkparse, btt,
> >> iowatcher, fio, etc), not to mention any scripts built around the
> >> tracepoints, and any users looking at the raw blkparse output.
> >> 
> >> So, are you suggesting we add another action on the endio side?  If so,
> >> that's a different patch set.  ;-)  If you're suggesting this multiple C
> >> event thing, I'm not on board with that.
> >
> > Ok, good point.  It's a little bit annoying how asymetic the tracepoints
> > are, but fixing it now might cause more harm than it helps.
> >
> > That being said, it might still be a good idea to have bio_endio call
> > the tracepoint, we'll just need a __bio_endio to bypass the tracepoints
> > for calls from the request layer.  That way all bio-based drivers will
> > automatically do the right thing.
> 
> OK, I'll look into that.  I'm also still trying to decide whether a
> separate endio event would be useful.  Any opinions on that are welcome.
> It could show up in blkparse as 'E'.  For btt, I guess we could add a
> Q2E column.  I'm not sure C2E would ever be interesting, but maybe?

FWIW I think BRD has this same issue where we get block_bio_queue tracepoint
events but not block_bio_complete.  Solving this in bio_endio() would fix that
driver as well.

Where does the Q (bio enqueue), I (req insert), etc. naming show up?  Looking
at a tracepoint trace in perf I don't see that naming.  Is that just a short
hand used between developers, or is it something else?
