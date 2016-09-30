Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43A921A1E3E
 for <linux-nvdimm@lists.01.org>; Thu, 29 Sep 2016 20:03:44 -0700 (PDT)
Date: Thu, 29 Sep 2016 21:03:43 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 00/12] re-enable DAX PMD support
Message-ID: <20160930030343.GA12464@linux.intel.com>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160929234345.GG27872@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160929234345.GG27872@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 30, 2016 at 09:43:45AM +1000, Dave Chinner wrote:
> Finally: none of the patches in your tree have reviewed-by tags.
> That says to me that none of this code has been reviewed yet.
> Reviewed-by tags are non-negotiable requirement for anything going
> through my trees. I don't have time right now to review this code,
> so you're going to need to chase up other reviewers before merging.
> 
> And, really, this is getting very late in the cycle to be merging
> new code - we're less than one working day away from the merge
> window opening and we've missed the last linux-next build. I'd
> suggest that we'd might be best served by slipping this to the PMD
> support code to the next cycle when there's no time pressure for
> review and we can get a decent linux-next soak on the code.

I absolutely support your policy of only sending code to Linux that has passed
peer review.

However, I do feel compelled to point out that this is not new code.  I didn't
just spring it on everyone in the hours before the v4.8 merge window.  I
posted the first version of this patch set on August 15th, *seven weeks ago*:

https://lkml.org/lkml/2016/8/15/613

This was the day after v4.7-rc2 was released.

Since then I have responded promptly to the little review feedback that I've
received.  I've also reviewed and tested other DAX changes, like the struct
iomap changes from Christoph.  Those changes were first posted to the mailing
list on September 9th, four weeks after mine.  Nevertheless, I was happy to
rebase my changes on top of his, which meant a full rewrite of the DAX PMD
fault handler so it would be based on struct iomap.  His changes are going to
be merged for v4.9, and mine are not.

Please, help me understand what I can do to get my code reviewed.  Do I need
to more aggressively ping my patch series, asking people by name for reviews?
Do we need to rework our code flow to Linus so that the DAX changes go through
a filesystem tree like XFS or ext4, and ask the developers of that filesystem
to help with reviews?  Something else?

I'm honestly very frustrated by this because I've done my best to be open to
constructive criticism and I've tried to respond promptly to the feedback that
I've received.  In the end, though, a system where it's a requirement that all
upstreamed code be peer reviewed but in which I can't get any feedback is
essentially a system where I'm not allowed to contribute.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
