Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F44D2098EABD
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 12:44:22 -0700 (PDT)
Date: Tue, 31 Jul 2018 13:44:20 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Message-ID: <20180731194420.GB3473@linux.intel.com>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 10, 2018 at 01:10:29PM -0600, Ross Zwisler wrote:
> Changes since v3:
>  * Added an ext4_break_layouts() call to ext4_insert_range() to ensure
>    that the {ext4,xfs}_break_layouts() calls have the same meaning.
>    (Dave, Darrick and Jan)
> 
> ---
> 
> This series from Dan:
> 
> https://lists.01.org/pipermail/linux-nvdimm/2018-March/014913.html
> 
> added synchronization between DAX dma and truncate/hole-punch in XFS.
> This short series adds analogous support to ext4.
> 
> I've added calls to ext4_break_layouts() everywhere that ext4 removes
> blocks from an inode's map.
> 
> The timings in XFS are such that it's difficult to hit this race.  Dan
> was able to show the race by manually introducing delays in the direct
> I/O path.
> 
> For ext4, though, its trivial to hit this race, and a hit will result in
> a trigger of this WARN_ON_ONCE() in dax_disassociate_entry():
> 
>         WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> 
> I've made an xfstest which tests all the paths where we now call
> ext4_break_layouts(). Each of the four paths easily hits this race many
> times in my test setup with the xfstest.  You can find that test here:
> 
> https://lists.01.org/pipermail/linux-nvdimm/2018-June/016435.html
> 
> With these patches applied, I've still seen occasional hits of the above
> WARN_ON_ONCE(), which tells me that we still have some work to do.  I'll
> continue looking at these more rare hits.

One last ping on this - do we want to merge this for v4.19?  I've tracked down
the more rare warnings, and have reported the race I'm seeing here:

https://lists.01.org/pipermail/linux-nvdimm/2018-July/017205.html

AFAICT the race exists equally for XFS and ext4, and I'm not sure how to solve
it easily.  Essentially it seems like we need to synchronize not just page
faults but calls to get_page() with truncate/hole punch operations, else we
can have the reference count for a given DAX page going up and down while we
are in the middle of a truncate.  I'm not sure if this is even feasible.

The equivalent code for this series already exists in XFS, so taking the
series now gets ext4 and XFS on the same footing moving forward, so I guess
I'm in favor of merging it now, though I can see the argument that it's not a
complete solution.

Thoughts?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
