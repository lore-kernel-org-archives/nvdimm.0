Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143])
 by ml01.01.org (Postfix) with ESMTP id F104821D49188
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 17:37:16 -0700 (PDT)
Date: Tue, 1 Aug 2017 10:30:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Message-ID: <20170801003032.GL17762@dastard>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135742076.35318.12884268722541769179.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170731170939.GC4477@magnolia>
 <CAPcyv4hPr8b3UsshQ086hi7_KrE3-y0uGTpdi1eXc5R59mYmUw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hPr8b3UsshQ086hi7_KrE3-y0uGTpdi1eXc5R59mYmUw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 11:25:34AM -0700, Dan Williams wrote:
> On Mon, Jul 31, 2017 at 10:09 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >> index 93e955262d07..c4fc79a0704f 100644
> >> --- a/fs/xfs/xfs_bmap_util.c
> >> +++ b/fs/xfs/xfs_bmap_util.c
> >> @@ -1387,6 +1387,92 @@ xfs_zero_file_space(
> >>
> >>  }
> >>
> >> +int
> >> +xfs_seal_file_space(
> >> +     struct xfs_inode        *ip,
> >> +     xfs_off_t               offset,
> >> +     xfs_off_t               len)
> >> +{
> >> +     struct inode            *inode = VFS_I(ip);
> >> +     struct address_space    *mapping = inode->i_mapping;
> >> +     int                     error = 0;
> >> +
> >> +     if (offset)
> >> +             return -EINVAL;
> >> +
> >> +     i_mmap_lock_read(mapping);
> >
> > (Are we allowed to take address_space->i_mmap_rwsem while holding
> > xfs_inode->i_mmaplock?)
> 
> Empirically, yes. Lockdep complains when those locks are taken in the
> reverse order.

My pet hate: people who rely on lockdep to tell them that locking is
wrong rather than understanding what the correct locking order is
before writing code.

> That seems to be inconsistent with the "mmap_sem -> i_mmap_lock ->
> page_lock" note in the xfs_ilock comment. Am I confusing what
> i_mmap_lock means in that comment, is that the i_mmap_lock_read(), or
> the i_mmaplock in the xfs_inode?

The latter. The lock orders you need to pay attention to are
documented in mm/filemap.c. (Which, incidentally, needs updating to
refer to i_rwsem, not i_mutex.)

 *  ->i_mutex
 *    ->i_mmap_rwsem            (truncate->unmap_mapping_range)

 *  ->mmap_sem                                                                   
 *    ->i_mmap_rwsem                                                             
 *      ->page_table_lock or pte_lock   (various, mainly in memory.c)            
 *        ->mapping->tree_lock  (arch-dependent flush_dcache_mmap_lock)

As it is, I think we shold not be taking internal mm/ state locks
deep inside filesystem code as it smells of layering violations. We
don't do this anywhere else for mapping checks - if we already hold
the XFS_MMAPLOCK_EXCL here, then we've already locked out page
faults from changing the state of the inode. In which case, we
should not need a mmap internal lock to be held here, same as all
the other filesystem operations that lock out page faults....

> >> +     xfs_ilock(ip, XFS_ILOCK_EXCL);
> >> +     if (len == 0) {
> >> +             /*
> >> +              * Clear the immutable flag provided there are no active
> >> +              * mappings. The active mapping check prevents an
> >> +              * application that is assuming a static block map, for
> >> +              * DAX or peer-to-peer DMA, from having this state
> >> +              * silently change behind its back.
> >> +              */
> >> +             if (RB_EMPTY_ROOT(&mapping->i_mmap))

			mapping_mapped(mapping)

> >> +                     inode->i_flags &= ~S_IOMAP_IMMUTABLE;
> >> +             else
> >> +                     error = -EBUSY;
> >> +     } else if (IS_IOMAP_IMMUTABLE(inode)) {
> >> +             if (len == i_size_read(inode)) {
> >> +                     /*
> >> +                      * The file is already in the correct state,
> >> +                      * bail out without error below.
> >> +                      */
> >> +                     len = 0;

> >> +             } else {
> >> +                     /* too late to allocate more space */
> >> +                     error = -ETXTBSY;
> >> +             }
> >> +     } else {
> >> +             if (len < i_size_read(inode)) {
> >> +                     /*
> >> +                      * Since S_IOMAP_IMMUTABLE is inode global it
> >> +                      * does not make sense to fallocate(immutable)
> >> +                      * on a sub-range of the file.
> >> +                      */
> >> +                     error = -EINVAL;
> >> +             } else if (!RB_EMPTY_ROOT(&mapping->i_mmap)) {
> >> +                     /*
> >> +                      * It's not strictly required to prevent setting
> >> +                      * immutable while a file is already mapped, but
> >> +                      * we do it for simplicity and symmetry with the
> >> +                      * S_IOMAP_IMMUTABLE disable case.
> >> +                      */
> >> +                     error = -EBUSY;
> >> +             } else
> >> +                     inode->i_flags |= S_IOMAP_IMMUTABLE;
> >> +     }
> >> +     xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >> +     i_mmap_unlock_read(mapping);
> >> +
> >> +     if (error || len == 0)
> >> +             return error;

I have to say, I find this checking to be fairly grotty. The "len ==
0" API to remove the immutable flag is a gross hack.  IMO, it's
better to add a separate fallocate command to "unseal" the extent
map, and let that happen according to whether the file is mapped or
not.  Perhaps it would be better to start with a man page
documenting the desired API?

FWIW, the if/else if/else structure could be cleaned up with a
simple "goto out_unlock" construct such as:

	/* don't make immutable if inode is currently mapped */
	error = -EBUSY;
	if (mapping_mapped(mapping))
		goto out_unlock;

	/* can't do anything if inode is already immutable */
	error = -ETXTBSY;
	if (IS_IMMUTABLE(inode) || IS_IOMAP_IMMUTABLE(inode))
		goto out_unlock;

	/* XFS only supports whole file extent immutability */
	error = -EINVAL;
	if (len != i_size_read(inode))
		goto out_unlock;

	/* all good to go */
	error = 0;

out_unlock:
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	i_mmap_unlock_read(mapping);

	if (error)
	     return error;

	/* now unshare, allocate and add immutable flag */

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
