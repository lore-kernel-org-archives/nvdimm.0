Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F5C2211F8862
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 00:59:57 -0700 (PDT)
Date: Mon, 2 Jul 2018 09:59:48 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2 2/2] ext4: handle layout changes to pinned DAX mappings
Message-ID: <20180702075948.i4aqjg5rrorwoxqj@localhost.localdomain>
References: <20180627212252.31032-1-ross.zwisler@linux.intel.com>
 <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180629120223.oaslngsvspnwf4ae@localhost.localdomain>
 <20180629151300.GA3006@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180629151300.GA3006@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 29, 2018 at 09:13:00AM -0600, Ross Zwisler wrote:
> On Fri, Jun 29, 2018 at 02:02:23PM +0200, Lukas Czerner wrote:
> > On Wed, Jun 27, 2018 at 03:22:52PM -0600, Ross Zwisler wrote:
> > > Follow the lead of xfs_break_dax_layouts() and add synchronization between
> > > operations in ext4 which remove blocks from an inode (hole punch, truncate
> > > down, etc.) and pages which are pinned due to DAX DMA operations.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/ext4/ext4.h     |  1 +
> > >  fs/ext4/extents.c  | 12 ++++++++++++
> > >  fs/ext4/inode.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/ext4/truncate.h |  4 ++++
> > >  4 files changed, 63 insertions(+)
> > > 
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index 0b127853c584..34bccd64d83d 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -2460,6 +2460,7 @@ extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
> > >  extern int ext4_inode_attach_jinode(struct inode *inode);
> > >  extern int ext4_can_truncate(struct inode *inode);
> > >  extern int ext4_truncate(struct inode *);
> > > +extern int ext4_break_layouts(struct inode *);
> > >  extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
> > >  extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
> > >  extern void ext4_set_inode_flags(struct inode *);
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index 0057fe3f248d..a6aef06f455b 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -4820,6 +4820,13 @@ static long ext4_zero_range(struct file *file, loff_t offset,
> > >  		 * released from page cache.
> > >  		 */
> > >  		down_write(&EXT4_I(inode)->i_mmap_sem);
> > > +
> > > +		ret = ext4_break_layouts(inode);
> > > +		if (ret) {
> > > +			up_write(&EXT4_I(inode)->i_mmap_sem);
> > > +			goto out_mutex;
> > > +		}
> > > +
> > >  		ret = ext4_update_disksize_before_punch(inode, offset, len);
> > >  		if (ret) {
> > >  			up_write(&EXT4_I(inode)->i_mmap_sem);
> > > @@ -5493,6 +5500,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
> > >  	 * page cache.
> > >  	 */
> > >  	down_write(&EXT4_I(inode)->i_mmap_sem);
> > > +
> > > +	ret = ext4_break_layouts(inode);
> > > +	if (ret)
> > > +		goto out_mmap;
> > 
> > Hi,
> > 
> > don't we need to do the same for ext4_insert_range() since we're about
> > to truncate_pagecache() as well ?
> > 
> > /thinking out loud/
> > Xfs seems to do this before every fallocate operation, but in ext4
> > it does not seem to be needed at least for simply allocating falocate...
> 
> I saw the case in ext4_insert_range(), and decided that we didn't need to
> worry about synchronizing with DAX because no blocks were being removed from
> the inode's extent map.  IIUC the truncate_pagecache() call is needed because
> we are unmapping and removing any page cache mappings for the part of the file
> after the insert because those blocks are now at a different offset in the
> inode.  Because at the end of the operation we haven't removed any DAX pages
> from the inode, we have nothing that we need to synchronize.
> 
> Hmm, unless this is a failure case we care about fixing?
>  1) schedule I/O via O_DIRECT to page X
>  2) fallocate(FALLOC_FL_INSERT_RANGE) to block < X, shifting X to a larger
>     offset
>  3) O_DIRECT I/O from 1) completes, but ends up writing into the *new* block
>     that resides at X - the I/O from 1) completes
> 
> In this case the user is running I/O and issuing the fallocate at the same
> time, and the sequencing could have worked out that #1 and #2 were reversed,
> giving you the same behavior.  IMO this seems fine and that we shouldn't have
> the DAX synchronization call in ext4_insert_range(), but I'm happy to add it
> if I'm wrong.

Hi,

I think you're right, this case might mot matter much. I am just worried
about unforeseen consequences of changing the layout with dax pages
mapped. I guess we can also add this later fi we discover anything.

You can add

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
