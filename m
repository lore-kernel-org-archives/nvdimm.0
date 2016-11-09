From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] nd_blk,nd_pmem,nd_btt: add endio blktrace events
Date: Wed, 09 Nov 2016 14:43:58 -0500
Message-ID: <x49inrwo2v5.fsf@segfault.boston.devel.redhat.com>
References: <x49twbgo4i6.fsf@segfault.boston.devel.redhat.com>
        <20161109191715.GA20314@infradead.org>
        <x49mvh8o3fx.fsf@segfault.boston.devel.redhat.com>
        <20161109193441.GA17343@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161109193441.GA17343@infradead.org> (Christoph Hellwig's
        message of "Wed, 9 Nov 2016 11:34:41 -0800")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Dan J. Williams" <dan.j.williams@intel.com>, linux-nvdimm@ml01.01.org, linux-block@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Nov 09, 2016 at 02:31:30PM -0500, Jeff Moyer wrote:
>> bio_endio is still called for request_fn drivers, so you'd see two
>> completion events for those drivers if we did that, no?
>
> We'd see the bio_endio trace in addition to the request one, but
> they are at different granularities.  Similar to how on the issue side
> we have trace_block_bio_queue for each bio, and trace_block_rq_issue
> for each request.

But on the issue side, we have different trace actions: Q vs. I.  On the
completion side, we just have C.  You'd end up getting two C events for
each Q, and that may confuse existing utilities (such as blkparse, btt,
iowatcher, fio, etc), not to mention any scripts built around the
tracepoints, and any users looking at the raw blkparse output.

So, are you suggesting we add another action on the endio side?  If so,
that's a different patch set.  ;-)  If you're suggesting this multiple C
event thing, I'm not on board with that.

Cheers,
Jeff
