Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 20 Nov 2015 10:17:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
Message-ID: <20151119231704.GG19199@dastard>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
 <20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
 <20151118150945.GE6097@quack.suse.cz>
 <1447892533.13153.8.camel@intel.com>
 <20151119125541.GC18581@quack.suse.cz>
 <CAPcyv4iGYPGz6n6YxdEWFJ4c0BZRXrWpa2188K2z9zz4_ez0TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iGYPGz6n6YxdEWFJ4c0BZRXrWpa2188K2z9zz4_ez0TA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "jack@suse.com" <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 19, 2015 at 08:55:48AM -0800, Dan Williams wrote:
> On Thu, Nov 19, 2015 at 4:55 AM, Jan Kara <jack@suse.cz> wrote:
> >> Subject: mm, dax: unmap dax mappings at bdev or fs shutdown
> >> From: Dan Williams <dan.j.williams@intel.com>
> >>
> >> Currently dax mappings leak past / survive block_device shutdown.  While
> >> page cache pages are permitted to be read/written after the block_device
> >> is torn down this is not acceptable in the dax case as all media access
> >> must end when the device is disabled.  The pfn backing a dax mapping is
> >> permitted to be invalidated after bdev shutdown and this is indeed the
> >> case with brd.
> >>
> >> When a dax capable block_device driver calls del_gendisk() in its
> >> shutdown path del_gendisk() needs to ensure that all DAX pfns are
> >> unmapped.  This is different than the pagecache backed case where the
> >> disk is protected by the queue being torn down which ends I/O to the
> >> device.  Since dax bypasses the page cache we need to unconditionally
> >> unmap the inode.
> > ...
> >> +static void unmap_list(struct list_head *head)
> >> +{
> >> +     struct inode *inode, *_i;
> >> +
> >> +     list_for_each_entry_safe(inode, _i, head, i_lru) {
> >> +             list_del_init(&inode->i_lru);
> >> +             unmap_mapping_range(&inode->i_data, 0, 0, 1);
> >> +             iput(inode);
> >> +             cond_resched();
> >> +     }
> >> +}
> >> +
> >>  /**
> >>   * evict_inodes      - evict all evictable inodes for a superblock
> >>   * @sb:              superblock to operate on
> >> @@ -642,6 +654,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
> >>       int busy = 0;
> >>       struct inode *inode, *next;
> >>       LIST_HEAD(dispose);
> >> +     LIST_HEAD(unmap);
> >>
> >>       spin_lock(&sb->s_inode_list_lock);
> >>       list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
> >> @@ -655,6 +668,19 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
> >>                       busy = 1;
> >>                       continue;
> >>               }
> >> +             if (IS_DAX(inode) && atomic_read(&inode->i_count)) {
> >> +                     /*
> >> +                      * dax mappings can't live past this invalidation event
> >> +                      * as there is no page cache present to allow the data
> >> +                      * to remain accessible.
> >> +                      */
> >> +                     __iget(inode);
> >> +                     inode_lru_list_del(inode);
> >> +                     spin_unlock(&inode->i_lock);
> >> +                     list_add(&inode->i_lru, &unmap);
> >> +                     busy = 1;
> >> +                     continue;
> >> +             }
> >
> > I'm somewhat concerned about the abuse of i_lru list here. The inodes have
> > i_count > 0 and so the code generally assumes such inodes should be removed
> > from LRU list if they are there. Now I didn't find a place where this could
> > really hit you but it is fragile. And when that happens, you have a
> > corruption of your unmap list (since you access it without any locks) and
> > also you will not unmap your inode.
> 
> "i_lru" list abuse was my main concern with this patch, I'll look into
> a different way.

Yeah, you can't use i_lru at all for purposes like this - even if
there are active references to the inode, the shrinker could be
walking the LRU list and accessing this inode (e.g.
inode_lru_isolate()) at the same time this code is removing it from
the LRU. Then things will go real bad....

> > Also are you sure that your unmapping cannot race with other process
> > mapping the pfns again?
> 
> You're right, there is indeed a gap between the unmap and when
> get_blocks() will start returning errors in the fault path.

get_blocks() won't start returning errors until the filesystem has
had an IO error. Given they cache metadata and do async
transactions, it could be some time before the filesystem notices
that the device has gone away in a fatal way.

> I think I
> need to defer the unmapping until after blk_cleanup_queue() where we
> know that no new I/o to the device is possible.

Actually, I think we need to trigger a filesystem shutdown before
doing anything else (e.g. before unmapping the inodes). That way the
filesystem will error out new calls to get_blocks() and prevent any
new IO submission while the block device teardown and inode
unmapping is done. i.e. solving the problem at the block device
level is hard, but we already have all the necessary infrastructure
to shut off IO and new block mappings at the filesystem level....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
