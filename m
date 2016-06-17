From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] xfs: initial/partial support for badblocks
Date: Fri, 17 Jun 2016 12:53:45 -0700
Message-ID: <20160617195345.GA5046@birch.djwong.org>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
 <1466125419-17736-3-git-send-email-vishal.l.verma@intel.com>
 <20160617022606.GC11810@birch.djwong.org>
 <20160617192647.GC5893@omniknight.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160617192647.GC5893-PxNA6LsHknajYZd8rzuJLNh3ngVCH38I@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Jun 17, 2016 at 01:26:47PM -0600, Vishal Verma wrote:
> On 06/16, Darrick J. Wong wrote:
> > On Thu, Jun 16, 2016 at 07:03:39PM -0600, Vishal Verma wrote:
> > > RFC/WIP commit.
> > > 
> > > This adds the foollowing:
> > > 1. In xfs_mountfs(), get an initial badblocks list from gendisk's
> > > badblocks infrastructure.
> > > 2. Register with the badblocks notifier to get updates for this disk's
> > > badblocks
> > > 
> > > TODO:
> > > 1. Add badblocks info to the reverse mapping tree (and remove if a
> > > badblock was cleared).
> > 
> > Well... there are a number of things we /could/ do... theoretically one
> > could use the rmap info to find all the affected inodes and simply convert
> > that part of their extent trees to 'unwritten'.  Reads will just get zeroes,
> 
> Hm, not sure we can do that - if a block became bad at some point,
> subsequent reads _have to_ error out (-EIO) so that the user doesn't see
> silent data corruption.

Ooh, right, forgot about that whole MCE-on-bad-read thing...

> > and writes will remove the unwritten flag (for that file, anyway).  Will a
> > successful write trigger the BB_CLEAR notifier?
> 
> Currently, a successful write that goes through the driver (i.e. not
> DAX) will cause the badblock to get cleared, and trigger BB_CLEAR. DAX
> is trickier, and currently DAX writes won't clear errors.

Oh...?

> > 
> > I guess you could punch out the bad blocks too... not clear if you'd want
> > all the owner files staying mapped to data they'll never get back.
> 
> The block mappings don't have to be maintained, but some sort of a flag
> needs to be kept that will allow us to return errors on reads like I
> said above.

What happens if pmem signals a bad block and we try to read anyway?  I know
about the read-error-MCE thing, but what's the "more expensive" alternative?
CPU exception?

(Really what I'm digging at is, if the whole thing becomes a soft exception
that we can handle in the OS by, say, 2020, do we care about reintroducing
the whole ext2 badblocks thing?)

(Beats me...)

--D

> 
> > 
> > We could also create another rmap "special owner" (XFS_RMAP_OWN_BAD?) for bad
> > blocks, so we'd know which parts are just plain bad.  It might be useful to
> > know that kind of thing.
> > 
> > I think earlier Dave was talking about adding a new 'badblocks' bit to both
> > the file extent records and the rmap records to signify that something's
> > wrong with the extent.  <shrug> I'll let him write about that.
> > 
> > > 2. Before doing file IO, refer the rmap/badblocks to error out early if
> > > the IO will attempt wo read a bad sector
> > > 3. Figure out interactions with mmap/DAX.
> > 
> > Woot.
> > 
> > > Cc: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
> > > Signed-off-by: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  fs/xfs/xfs_linux.h |   1 +
> > >  fs/xfs/xfs_mount.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_mount.h |   1 +
> > >  3 files changed, 106 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> > > index 7e749be..f66d181 100644
> > > --- a/fs/xfs/xfs_linux.h
> > > +++ b/fs/xfs/xfs_linux.h
> > > @@ -78,6 +78,7 @@ typedef __u32			xfs_nlink_t;
> > >  #include <linux/freezer.h>
> > >  #include <linux/list_sort.h>
> > >  #include <linux/ratelimit.h>
> > > +#include <linux/badblocks.h>
> > >  
> > >  #include <asm/page.h>
> > >  #include <asm/div64.h>
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 5e68b2c..1a47737 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -618,6 +618,96 @@ xfs_default_resblks(xfs_mount_t *mp)
> > >  	return resblks;
> > >  }
> > >  
> > > +STATIC int
> > > +xfs_notifier_call(
> > > +	struct notifier_block	*nb,
> > > +	unsigned long		action,
> > > +	void			*data)
> > > +{
> > > +	struct bb_notifier_data *bb_data = data;
> > > +	struct xfs_mount *mp;
> > > +
> > > +	mp = container_of(nb, struct xfs_mount, m_badblocks_nb);
> > > +	/* TODO xfs_add_bb_to_rmap(mp, bb_data->sector, bb_data->count); */
> > > +	xfs_warn(mp, "xfs badblock %s sector %lu (count %d)\n",
> > > +		(action == BB_ADD)?"added":"cleared",
> > > +		bb_data->sector, bb_data->count);
> > > +	return 0;
> > 
> > Probably a xfs_rmapbt_query_range here?
> > 
> > > +}
> > > +
> > > +STATIC int
> > > +xfs_init_badblocks(struct xfs_mount *mp)
> > > +{
> > > +	struct badblocks *bb = mp->m_super->s_bdev->bd_disk->bb;
> > > +	int done = 0, error = 0;
> > > +	ssize_t len, off = 0;
> > > +	char *p;
> > > +
> > > +	/*
> > > +	 * TODO: get a list of known badblocks so far and process it.
> > > +	 * Can we just parse the sysfs format that badblocks_show()
> > > +	 * returns? That should be the fastest way to get this.
> > > +	 * Something like: (Is this too hacky? Should we just do
> > > +	 * badblocks_check() in a (rather large) loop?)
> > > +	 */
> > > +	p = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > > +	len = badblocks_show(bb, p, 0);
> > > +	while (len) {
> > > +		int count, n;
> > > +		sector_t s;
> > > +
> > > +		/*
> > > +		 * The sysfs badblocks format is multiple lines of:
> > > +		 * "<sector> <count>"
> > > +		 */
> > > +		n = sscanf(p + off, "%lu %d\n%n", &s, &count, &done);
> > 
> > Ick, there's got to be a better way to iterate the badblocks list than this.
> > 
> > It would be very nice to have a single function that deals with a change in
> > badness status, which would be called by both the notifier and the badblocks
> > iterator.
> > 
> There is a function in block/badblocks.c - badblocks_check() which can
> tell you for a given range, what is the first bad sector in that range,
> and the number of bad sectors after that first sector. Using that would
> certainly be cleaner, as it uses the well-defined API, but it would be
> much slower, as you have to iterate through the entire address space.
> The above function - badblocks_show - just looks at the actual stored
> representation of the badblocks, and lists them out, which is quick
> (reading a 4K page from memory), and so in the above, I just parse it..
> 
> > > +		if (n < 2 || done < 3) {
> > > +			error = -1;
> > > +			break;
> > > +		}
> > > +		off += done;
> > > +		len -= done;
> > > +		xfs_warn(mp, "got badblocks: sector %ld, count %d", s, count);
> > > +		/* TODO xfs_add_bb_to_rmap(mp, s, count); */
> > > +	}
> > > +	kfree(p);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	mp->m_badblocks_nb.notifier_call = xfs_notifier_call;
> > > +	error = bb_notifier_register(bb, &mp->m_badblocks_nb);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/*
> > > +	 * TODO: There is probably a TOCTOU race hiding here - what if the
> > > +	 * badblocks list gets updated before we register for notifications..
> > > +	 * Can likely be solved by registering for notifications _first_ (the
> > > +	 * above xfs_add_bb_to_rmap function has to be ready to accept new
> > > +	 * blocks), then querying for the initial list (there could be overlap
> > > +	 * here, shich the above function could handle), and then setting the
> > > +	 * mount flag below.
> > > +	 */
> > 
> > (Yeah, pretty much. :))
> > 
> > > +
> > > +	/*
> > > +	 * TODO: set some flag (mount flag?) in xfs so that xfs knows
> > > +	 * it will be doing error checking, and can possibly, later,
> > > +	 * tell the block layer (possibly using a REQ_ flag in its IO
> > > +	 * requests) not to do further badblock checking for those IOs.
> > > +	 */
> > > +
> > > +	/* mp->m_flags |= XFS_MOUNT_FS_BADBLOCKS; */
> > > +	return 0;
> > > +}
> > > +
> > > +STATIC void
> > > +xfs_badblocks_unmount(struct xfs_mount *mp)
> > > +{
> > > +	struct badblocks *bb = mp->m_super->s_bdev->bd_disk->bb;
> > > +
> > > +	bb_notifier_unregister(bb, &mp->m_badblocks_nb);
> > > +}
> > > +
> > >  /*
> > >   * This function does the following on an initial mount of a file system:
> > >   *	- reads the superblock from disk and init the mount struct
> > > @@ -955,6 +1045,19 @@ xfs_mountfs(
> > >  	}
> > >  
> > >  	/*
> > > +	 * Register with the badblocks notifier chain
> > > +	 */
> > > +	error = xfs_init_badblocks(mp);
> > > +	if (error) {
> > > +		xfs_warn(mp, "Unable to register to badblocks notifications\n");
> > > +		/*
> > > +		 * TODO is this a hard error or can we simply
> > > +		 * warn and continue?
> > > +		 */
> > > +		goto out_rtunmount;
> > > +	}
> > > +
> > > +	/*
> > >  	 * Now we are mounted, reserve a small amount of unused space for
> > >  	 * privileged transactions. This is needed so that transaction
> > >  	 * space required for critical operations can dip into this pool
> > > @@ -1085,6 +1188,7 @@ xfs_unmountfs(
> > >  	xfs_log_unmount(mp);
> > >  	xfs_da_unmount(mp);
> > >  	xfs_uuid_unmount(mp);
> > > +	xfs_badblocks_unmount(mp);
> > >  
> > >  #if defined(DEBUG)
> > >  	xfs_errortag_clearall(mp, 0);
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index 0ca9244..f0d1111 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -139,6 +139,7 @@ typedef struct xfs_mount {
> > >  						/* low free space thresholds */
> > >  	struct xfs_kobj		m_kobj;
> > >  	struct xstats		m_stats;	/* per-fs stats */
> > > +	struct notifier_block	m_badblocks_nb;	/* disk badblocks notifier */
> > >  
> > >  	struct workqueue_struct *m_buf_workqueue;
> > >  	struct workqueue_struct	*m_data_workqueue;
> > > -- 
> > > 2.5.5
> > > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> > > http://oss.sgi.com/mailman/listinfo/xfs
