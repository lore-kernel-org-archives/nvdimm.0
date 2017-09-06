Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0DEA421E9781F
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 16:08:29 -0700 (PDT)
Date: Wed, 6 Sep 2017 17:11:18 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 7/9] ext4: prevent data corruption with inline data + DAX
Message-ID: <20170906231118.GA12679@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <20170905223541.20594-8-ross.zwisler@linux.intel.com>
 <F454DBB5-FF0B-46F7-B1D8-40764AAC4657@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F454DBB5-FF0B-46F7-B1D8-40764AAC4657@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 06, 2017 at 02:55:31PM -0600, Andreas Dilger wrote:
> On Sep 5, 2017, at 4:35 PM, Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> > 
> > If an inode has inline data it is currently prevented from using DAX by a
> > check in ext4_should_use_dax().  When the inode grows inline data via
> > ext4_create_inline_data() or removes its inline data via
> > ext4_destroy_inline_data_nolock(), the value of S_DAX can change.
> > 
> > Currently these changes are unsafe because we don't hold off page faults
> > and I/O, write back dirty radix tree entries and invalidate all mappings.
> > This work is done in XFS via xfs_ioctl_setattr_dax_invalidate(), for
> > example.  This unsafe transitioning of S_DAX could potentially lead to data
> > corruption.
> > 
> > Fix this issue by preventing the DAX mount option from being used on
> > filesystems that were created to support inline data.  Inline data is an
> > option given to mkfs.ext4.
> > 
> > We prevent DAX from being used with inline data as opposed to trying to
> > safely manage the transition of S_DAX because of the locking complexities:
> > 
> > 1) filemap_write_and_wait() eventually calls ext4_writepages(), which
> > acquires the sbi->s_journal_flag_rwsem.  This lock ranks above the
> > jbdw_handle which is eventually taken by ext4_journal_start().  This
> > essentially means that the writeback has to happen outside of the context
> > of an active journal handle (outside of ext4_journal_start() to
> > ext4_journal_stop().)
> > 
> > 2) To lock out page faults we take a write lock on the ei->i_mmap_sem, and
> > this lock again ranks above the jbd2_handle taken by ext4_journal_start().
> > So, as with the writeback code in 1) above we have to take ei->i_mmap_sem
> > outside of the context of an active journal handle.
> > 
> > We are able to work around both of these restrictions and safely transition
> > S_DAX when we change the journaling mode, but for inline data it's much
> > harder because each of ext4_create_inline_data() and
> > ext4_destroy_inline_data_nolock() are passed in journal handles that have
> > already been started.
> > 
> > To be able to safely writeback and invalidate our dirty inode data we'd
> > either need to uplevel the locking, writeback and invalidate into all the
> > callers of those two functions, or we'd need to stop our current journal
> > handle, do the appropriate locking, writeback and invalidate, unlock and
> > restart the journal handle.
> > 
> > These both seem too complex, and I don't know if we have a valid use case
> > where we need to combine a filesystem with inline data and DAX, so just
> > prevent them from being used together.
> 
> The one reason I can see to use inline data + DAX is that inline data saves
> space for very small files, even if the performance improvement is minimal.
> Since NVDIMMs are still relatively expensive, storing very small files and
> directories directly in the inode is probably worthwhile.
> 
> That said, there are still occasional bugs in the inline data code, so it
> makes sense to ensure these two features are not enabled at the same time
> if they don't play well together.

Yep, unfortunately it's increasingly looking like we just can't ever safely
transition S_DAX at runtime:

https://www.spinics.net/lists/linux-xfs/msg09859.html

I think the current thought is to just avoid it completely until/unless we can
figure out a way to make it safe that is worthwhile.

> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > CC: stable@vger.kernel.org
> > ---
> > fs/ext4/inline.c | 10 ----------
> > fs/ext4/super.c  |  5 +++++
> > 2 files changed, 5 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index 28c5c3a..fd95019 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -302,11 +302,6 @@ static int ext4_create_inline_data(handle_t *handle,
> > 	EXT4_I(inode)->i_inline_size = len + EXT4_MIN_INLINE_DATA_SIZE;
> > 	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
> > 	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> > -	/*
> > -	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
> > -	 * get cleared
> > -	 */
> > -	ext4_set_inode_flags(inode);
> 
> What about other flags in the inode?  It doesn't make sense to drop this
> entirely.  The S_DAX flag shouldn't be set if the inode has the inline
> data flag set, according to ext4_set_inode_flags().

AFAICT all the other flags in the inode are independent of
EXT4_INODE_INLINE_DATA.  The only one that could switch as a side-effect of
EXT4_INODE_INLINE_DATA is S_DAX.

The lines I'm deleting were added explicitly for the side-effect transition of
S_DAX (commit a3caa24b703794), so I don't think we still need them at all if
we prevent S_DAX from transitioning.

Ditto for the other deletion.

> 
> > 	get_bh(is.iloc.bh);
> > 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
> > 
> > @@ -451,11 +446,6 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
> > 		}
> > 	}
> > 	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> > -	/*
> > -	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
> > -	 * get set.
> > -	 */
> > -	ext4_set_inode_flags(inode);
> 
> Same?
> 
> > 	get_bh(is.iloc.bh);
> > 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index d61a70e2..d549dfb 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -3686,6 +3686,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> > 	}
> > 
> > 	if (sbi->s_mount_opt & EXT4_MOUNT_DAX) {
> > +		if (ext4_has_feature_inline_data(sb)) {
> > +			ext4_msg(sb, KERN_ERR, "Cannot use DAX on a filesystem"
> > +					" that may contain inline data");
> > +			goto failed_mount;
> > +		}
> 
> Wouldn't it be enough to just prevent modification of inodes that are stored
> in the inode?  It should be OK to read such files.  At a minimum that means
> there should not be an error in case of read-only mounting.  A better choice
> would be to return an error only at runtime in case of open-for-write, or
> only if the file is actually being written.

Hmm...yes?  I think this *could* work - we'd have to prevent anything that
would make the inode switch from using inline data to using extents.  This
includes writes (all writes?  Or just ones that would trigger the
transition?), fallocate, etc.

I think we could make this work, but the consequence would be that
applications would receive I/O errors or errors for seemingly random syscalls,
and they might have a hard time understanding why.  

It seems cleaner and simpler to me to just disallow the combination of inline
data + DAX, and to print a descriptive message in dmesg?  The combination of
the two features would end up being pretty unfriendly anyway, and the
implementation to make it safe would probably be more complex.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
