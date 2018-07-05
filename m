Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6939C210DBE7F
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 21:00:01 -0700 (PDT)
Date: Wed, 4 Jul 2018 20:59:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 2/2] ext4: handle layout changes to pinned DAX mappings
Message-ID: <20180705035952.GB5699@magnolia>
References: <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180702172912.329-1-ross.zwisler@linux.intel.com>
 <20180704004923.GT19934@dastard>
 <20180704122723.lup2wovzb6u6ta6v@quack2.suse.cz>
 <20180704235414.GU19934@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180704235414.GU19934@dastard>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 05, 2018 at 09:54:14AM +1000, Dave Chinner wrote:
> On Wed, Jul 04, 2018 at 02:27:23PM +0200, Jan Kara wrote:
> > On Wed 04-07-18 10:49:23, Dave Chinner wrote:
> > > On Mon, Jul 02, 2018 at 11:29:12AM -0600, Ross Zwisler wrote:
> > > > Follow the lead of xfs_break_dax_layouts() and add synchronization between
> > > > operations in ext4 which remove blocks from an inode (hole punch, truncate
> > > > down, etc.) and pages which are pinned due to DAX DMA operations.
> > > > 
> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> > > > ---
> > > > 
> > > > Changes since v2:
> > > >  * Added a comment to ext4_insert_range() explaining why we don't call
> > > >    ext4_break_layouts(). (Jan)
> > > 
> > > Which I think is wrong and will cause data corruption.
> > > 
> > > > @@ -5651,6 +5663,11 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
> > > >  			LLONG_MAX);
> > > >  	if (ret)
> > > >  		goto out_mmap;
> > > > +	/*
> > > > +	 * We don't need to call ext4_break_layouts() because we aren't
> > > > +	 * removing any blocks from the inode.  We are just changing their
> > > > +	 * offset by inserting a hole.
> > > > +	 */

Does calling ext4_break_layouts from insert range not work?

It's my understanding that file leases work are a mechanism for the
filesystem to delegate some of its authority over physical space
mappings to "client" software.  AFAICT it's used for mmap'ing pmem
directly into userspace and exporting space on shared storage over
pNFS.  Some day we might use the same mechanism for the similar things
that RDMA does, or the swapfile code since that's essentially how it
works today.

The other part of these file leases is that the filesystem revokes them
any time it wants to perform a mapping operation on a file.  This breaks
my mental model of how leases work, and if you commit to this for ext4
then I'll have to remember that leases are different between xfs and
ext4.  Worse, since the reason for skipping ext4_break_layouts seems to
be the implementation detail that "DAX won't care", then someone else
wiring up pNFS/future RDMA/whatever will also have to remember to put it
back into ext4 or else kaboom.

Granted, Dave said all these things already, but I actually feel
strongly enough to reiterate.

--D

> > > 
> > > The entire point of these leases is so that a thrid party can
> > > directly access the blocks underlying the file. That means they are
> > > keeping their own file offset<->disk block mapping internally, and
> > > they are assuming that it is valid for as long as they hold the
> > > lease. If the filesystem modifies the extent map - even something
> > > like a shift here which changes the offset<->disk block mapping -
> > > the userspace app now has a stale mapping and so the lease *must be
> > > broken* to tell it that it's mappings are now stale and it needs to
> > > refetch them.
> > 
> > Well, ext4 has no real concept of leases and no pNFS support. And DAX
> > requirements wrt consistency are much weaker than those of pNFS. This is
> > mostly caused by the fact that calls like invalidate_mapping_pages() will
> > flush offset<->pfn mappings DAX maintains in the radix tree automatically
> > (similarly as it happens when page cache is used).
> 
> I'm more concerned about apps that use file leases behaving the same
> way, not just the pNFS stuff. if we are /delegating file layouts/ to
> 3rd parties, then all filesystems *need* to behave the same way.
> We've already defined those semantics with XFS - every time the
> filesystem changes an extent layout in any way it needs to break
> existing layout delegations...
> 
> > What Ross did just keeps ext4 + DAX behave similarly as ext4 + page cache
> > does
> 
> Sure. But the issue I'm raising is that ext4 is not playing by the
> same extent layout delegation rules that XFS has already defined for
> 3rd party use.
> 
> i.e. don't fuck up layout delegation behaviour consistency right
> from the start just because "<this subset of functionality> is all
> we need right now for ext4". All the filesystems should implement
> the same semantics and behaviour right from the start, otherwise
> we're just going to make life a misery for anyone who tries to use
> layout delegations in future.
> 
> Haven't we learnt this lesson the hard way enough times already?
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
