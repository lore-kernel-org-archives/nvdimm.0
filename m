From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/20 v3] dax: Clear dirty bits after flushing caches
Date: Mon, 17 Oct 2016 10:47:32 +0200
Message-ID: <20161017084732.GD3359@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <20160930091418.GC24352@infradead.org>
 <20161003075902.GG6457@quack2.suse.cz>
 <20161003080337.GA13688@infradead.org>
 <20161003081549.GH6457@quack2.suse.cz>
 <20161003093248.GA27720@infradead.org>
 <20161003111358.GQ6457@quack2.suse.cz>
 <20161013203434.GD26922@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161013203434.GD26922@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Thu 13-10-16 14:34:34, Ross Zwisler wrote:
> On Mon, Oct 03, 2016 at 01:13:58PM +0200, Jan Kara wrote:
> > On Mon 03-10-16 02:32:48, Christoph Hellwig wrote:
> > > On Mon, Oct 03, 2016 at 10:15:49AM +0200, Jan Kara wrote:
> > > > Yeah, so DAX path is special because it installs its own PTE directly from
> > > > the fault handler which we don't do in any other case (only driver fault
> > > > handlers commonly do this but those generally don't care about
> > > > ->page_mkwrite or file mappings for that matter).
> > > > 
> > > > I don't say there are no simplifications or unifications possible, but I'd
> > > > prefer to leave them for a bit later once the current churn with ongoing
> > > > work somewhat settles...
> > > 
> > > Allright, let's keep it simple for now.  Being said this series clearly
> > > is 4.9 material, but any chance to get a respin of the invalidate_pages
> > 
> > Agreed (actually 4.10).
> > 
> > > series as that might still be 4.8 material?
> > 
> > The problem with invalidate_pages series is that it depends on the ability
> > to clear the dirty bits in the radix tree of DAX mappings (i.e. the first
> > series). Otherwise radix tree entries that get once dirty can never be safely
> > evicted, invalidate_inode_pages2_range() will keep returning EBUSY and
> > callers get confused (I've tried that few weeks ago).
> > 
> > If I dropped patch 5/6 for 4.9 merge (i.e., we would still happily discard
> > dirty radix tree entries from invalidate_inode_pages2_range()), things
> > would run fine, just fsync() may miss to flush caches for some pages. I'm
> > not sure that's much better than current status quo though. Thoughts?
> 
> I'm not sure if I'm understanding this correctly, but if you're saying
> that we might end up in a case where fsync()/msync() would fail to
> properly flush pages that are/should be dirty, I think this is a no-go.
> That could result in data corruption if a user calls fsync(), thinks
> they've achieved a synchronization point (updating other metadata or
> whatever), then via power loss they lose data they had flushed via that
> previous fsync() because it was still in the CPU cache and never really
> made it out to media.

I know and actually current code is buggy in that way as well and this
patch set is fixing it. But I was arguing that only applying part of the
fixes so that the main problem remains unfixed would not be very beneficial
anyway.

This week I plan to rebase both series on top of rc1 + your THP patches so
that we can move on with merging the stuff.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
