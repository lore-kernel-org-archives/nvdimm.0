Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80F9220336ABD
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 02:59:11 -0700 (PDT)
Date: Mon, 9 Jul 2018 11:59:07 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3 2/2] ext4: handle layout changes to pinned DAX mappings
Message-ID: <20180709095907.i3mnyodvn6gpcidt@localhost.localdomain>
References: <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180702172912.329-1-ross.zwisler@linux.intel.com>
 <20180704004923.GT19934@dastard>
 <20180704122723.lup2wovzb6u6ta6v@quack2.suse.cz>
 <20180704235414.GU19934@dastard> <20180705035952.GB5699@magnolia>
 <CAPcyv4jSNh95XUPh4ZzguKmcJpgNG7AG5_9=+gbLEjsaZUTq4g@mail.gmail.com>
 <20180705232934.GW19934@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180705232934.GW19934@dastard>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 06, 2018 at 09:29:34AM +1000, Dave Chinner wrote:
> On Thu, Jul 05, 2018 at 01:40:17PM -0700, Dan Williams wrote:
> > On Wed, Jul 4, 2018 at 8:59 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > On Thu, Jul 05, 2018 at 09:54:14AM +1000, Dave Chinner wrote:
> > >> On Wed, Jul 04, 2018 at 02:27:23PM +0200, Jan Kara wrote:
> > >> > On Wed 04-07-18 10:49:23, Dave Chinner wrote:
> > >> > > On Mon, Jul 02, 2018 at 11:29:12AM -0600, Ross Zwisler wrote:
> > >> > > > Follow the lead of xfs_break_dax_layouts() and add synchronization between
> > >> > > > operations in ext4 which remove blocks from an inode (hole punch, truncate
> > >> > > > down, etc.) and pages which are pinned due to DAX DMA operations.
> > >> > > >
> > >> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > >> > > > Reviewed-by: Jan Kara <jack@suse.cz>
> > >> > > > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> > >> > > > ---
> > >> > > >
> > >> > > > Changes since v2:
> > >> > > >  * Added a comment to ext4_insert_range() explaining why we don't call
> > >> > > >    ext4_break_layouts(). (Jan)
> > >> > >
> > >> > > Which I think is wrong and will cause data corruption.
> > >> > >
> > >> > > > @@ -5651,6 +5663,11 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
> > >> > > >                         LLONG_MAX);
> > >> > > >         if (ret)
> > >> > > >                 goto out_mmap;
> > >> > > > +       /*
> > >> > > > +        * We don't need to call ext4_break_layouts() because we aren't
> > >> > > > +        * removing any blocks from the inode.  We are just changing their
> > >> > > > +        * offset by inserting a hole.
> > >> > > > +        */
> > >
> > > Does calling ext4_break_layouts from insert range not work?
> > >
> > > It's my understanding that file leases work are a mechanism for the
> > > filesystem to delegate some of its authority over physical space
> > > mappings to "client" software.  AFAICT it's used for mmap'ing pmem
> > > directly into userspace and exporting space on shared storage over
> > > pNFS.  Some day we might use the same mechanism for the similar things
> > > that RDMA does, or the swapfile code since that's essentially how it
> > > works today.
> > >
> > > The other part of these file leases is that the filesystem revokes them
> > > any time it wants to perform a mapping operation on a file.  This breaks
> > > my mental model of how leases work, and if you commit to this for ext4
> > > then I'll have to remember that leases are different between xfs and
> > > ext4.  Worse, since the reason for skipping ext4_break_layouts seems to
> > > be the implementation detail that "DAX won't care", then someone else
> > > wiring up pNFS/future RDMA/whatever will also have to remember to put it
> > > back into ext4 or else kaboom.
> > >
> > > Granted, Dave said all these things already, but I actually feel
> > > strongly enough to reiterate.
> > 
> > This patch kit is only for the DAX fix, this isn't full layout lease
> > support. Even XFS is special casing unmap with the BREAK_UNMAP flag.
> > So ext4 is achieving feature parity for BREAK_UNMAP, just not
> > BREAK_WRITE, yet.
> 
> BREAK_UNMAP is issued unconditionally by XFS for all fallocate
> operations. There is no special except for extent shifting (up or
> down) in XFS as this patch set is making for ext4.  IOWs, this
> patchset does not implement BREAK_UNMAP with the same semantics as
> XFS.

If anything this is very usefull discussion ( at least for me ) and what
I do take away from it is that there is no documentation, nor
specification of the leases nor BREAK_UNMAP nor BREAK_WRITE.

grep -iR -e break_layout -e BREAK_UNMAP -e BREAK_WRITE Documentation/*

Maybe someone with a good understanding of how this stuff is supposed to
be done could write it down so filesystem devs can make it behave the
same.

Thanks!
-Lukas


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
