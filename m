From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] nd_blk,nd_pmem,nd_btt: add endio blktrace events
Date: Thu, 10 Nov 2016 11:33:33 -0800
Message-ID: <20161110193333.GA10865@infradead.org>
References: <x49twbgo4i6.fsf@segfault.boston.devel.redhat.com>
 <20161109191715.GA20314@infradead.org>
 <x49mvh8o3fx.fsf@segfault.boston.devel.redhat.com>
 <20161109193441.GA17343@infradead.org>
 <x49inrwo2v5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49inrwo2v5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Dan J. Williams" <dan.j.williams@intel.com>, linux-nvdimm@ml01.01.org, linux-block@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Nov 09, 2016 at 02:43:58PM -0500, Jeff Moyer wrote:
> But on the issue side, we have different trace actions: Q vs. I.  On the
> completion side, we just have C.  You'd end up getting two C events for
> each Q, and that may confuse existing utilities (such as blkparse, btt,
> iowatcher, fio, etc), not to mention any scripts built around the
> tracepoints, and any users looking at the raw blkparse output.
> 
> So, are you suggesting we add another action on the endio side?  If so,
> that's a different patch set.  ;-)  If you're suggesting this multiple C
> event thing, I'm not on board with that.

Ok, good point.  It's a little bit annoying how asymetic the tracepoints
are, but fixing it now might cause more harm than it helps.

That being said, it might still be a good idea to have bio_endio call
the tracepoint, we'll just need a __bio_endio to bypass the tracepoints
for calls from the request layer.  That way all bio-based drivers will
automatically do the right thing.
