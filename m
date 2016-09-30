From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 00/12] re-enable DAX PMD support
Date: Thu, 29 Sep 2016 21:00:55 -0700
Message-ID: <20160930040055.GE9309@birch.djwong.org>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160929234345.GG27872@dastard>
 <20160930030343.GA12464@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160930030343.GA12464@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@ml01.01.org, linux-xfs@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Thu, Sep 29, 2016 at 09:03:43PM -0600, Ross Zwisler wrote:
> On Fri, Sep 30, 2016 at 09:43:45AM +1000, Dave Chinner wrote:
> > Finally: none of the patches in your tree have reviewed-by tags.
> > That says to me that none of this code has been reviewed yet.
> > Reviewed-by tags are non-negotiable requirement for anything going
> > through my trees. I don't have time right now to review this code,
> > so you're going to need to chase up other reviewers before merging.
> > 
> > And, really, this is getting very late in the cycle to be merging
> > new code - we're less than one working day away from the merge
> > window opening and we've missed the last linux-next build. I'd
> > suggest that we'd might be best served by slipping this to the PMD
> > support code to the next cycle when there's no time pressure for
> > review and we can get a decent linux-next soak on the code.
> 
> I absolutely support your policy of only sending code to Linux that has passed
> peer review.
> 
> However, I do feel compelled to point out that this is not new code.  I didn't
> just spring it on everyone in the hours before the v4.8 merge window.  I
> posted the first version of this patch set on August 15th, *seven weeks ago*:
> 
> https://lkml.org/lkml/2016/8/15/613
> 
> This was the day after v4.7-rc2 was released.
> 
> Since then I have responded promptly to the little review feedback
> that I've received.  I've also reviewed and tested other DAX changes,
> like the struct iomap changes from Christoph.  Those changes were
> first posted to the mailing list on September 9th, four weeks after
> mine.  Nevertheless, I was happy to rebase my changes on top of his,
> which meant a full rewrite of the DAX PMD fault handler so it would be
> based on struct iomap.  His changes are going to be merged for v4.9,
> and mine are not.

I'm not knocking the iomap migration, but it did cause a fair amount of
churn in the XFS reflink patchset -- and that's for a filesystem that
already /had/ iomap implemented.  It'd be neat to have all(?) the DAX
filesystems (ext[24], XFS) move over to iomap so that you wouldn't have
to support multiple ways of talking to FSes.  AFAICT ext4 hasn't gotten
iomap, which complicates things.  But that's my opinion, maybe you're
fine with supporting iomap and not-iomap.

The thing that (personally) makes it harder to review these
multi-subsystem patches is that I'm not a domain expert in some of those
subsystems -- memory in this case.  I get to the point where I'm
thinking "Uh, this looks ok, and it seems to work on my test VM, but is
that enough to stick my neck out and Reviewed-by?" and then get stuck.
It's hard to get unstuck with a complex piece of machinery.

> Please, help me understand what I can do to get my code reviewed.  Do
> I need to more aggressively ping my patch series, asking people by
> name for reviews?  Do we need to rework our code flow to Linus so that
> the DAX changes go through a filesystem tree like XFS or ext4, and ask
> the developers of that filesystem to help with reviews?  Something
> else?

FWIW, I /think/ it looks fine, though I'm afraid enough of the memory
manager that I haven't said anything yet.  I'll look it over more
tomorrow when my brain is fresher.  If reflink for XFS lands in 4.9 I'll
start looking again at pagecache sharing and/or dax+reflink.

> I'm honestly very frustrated by this because I've done my best to be
> open to constructive criticism and I've tried to respond promptly to
> the feedback that I've received.  In the end, though, a system where
> it's a requirement that all upstreamed code be peer reviewed but in
> which I can't get any feedback is essentially a system where I'm not
> allowed to contribute.

I have the same frustrations with getting non-XFS/non-ext4 patches
reviewed and upstreamed by whomever the maintainer is.  I wish we had a
broader range of people who knew both FS and MM, but wow is that a long
onboarding process. :/

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
