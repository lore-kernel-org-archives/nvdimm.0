Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20160105035147.GJ19802@dastard>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160105035147.GJ19802@dastard>
Date: Mon, 4 Jan 2016 20:25:16 -0800
Message-ID: <CAPcyv4i=5-e6mobC5yu1SgESBNgCeqU5jwbaxhN8ZmNW+xUnJA@mail.gmail.com>
Subject: Re: [resend PATCH 1/3] block, fs: reliably communicate bdev end-of-life
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 4, 2016 at 7:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jan 04, 2016 at 10:20:05AM -0800, Dan Williams wrote:
>> Historically we have waited for filesystem specific heuristics to
>> attempt to guess when a block device is gone.  Sometimes this works, but
>> in other cases the system can hang waiting for the fs to trigger its
>> shutdown protocol.
>>
>> The initial motivation for this investigation was to prevent DAX
>> mappings (direct mmap access to persistent memory) from leaking past the
>> lifetime of the hosting block device.  However, Dave points out that
>> these shutdown operations are needed in other scenarios.  Quoting Dave:
>>
>>     For example, if we detect a free space corruption during allocation,
>>     it is not safe to trust *any active mapping* because we can't trust
>>     that we having handed out the same block to multiple owners. Hence
>>     on such a filesystem shutdown, we have to prevent any new DAX
>>     mapping from occurring and invalidate all existing mappings as we
>>     cannot allow userspace to modify any data or metadata until we've
>>     resolved the corruption situation.
>>
>> The current block device shutdown sequence of del_gendisk +
>> blk_cleanup_queue is problematic.  We want to tell the fs after
>> blk_cleanup_queue that there is no possibility of recovery, but by that
>> time we have deleted partitions and lost the ability to find all the
>> super-blocks on a block device.
>>
>> Introduce del_gendisk_queue to trigger ->quiesce() and ->bdi_gone()
>
> I don't see anything that introduces a ->quiesce() method.
>

Right, we only have generic_quiesce_super() as no fs had a need to do
anything but the generic actions.

>> notifications to all the filesystems hosted on the disk.  Where
>> ->quiesce() are 'shutdown' operations while the bdev may still be alive,
>
> So you are saying "quiesce == invalidation", which is in conflict
> with what we typically think quiesce means. i.e.  "Quiesce" is what
> we do when doing orderly writeback of all outstanding dirty objects
> in a filesystem - what we do during freeze, remount-ro, and unmount.
> e.g. See the functions xfs_log_quiesce() and xfs_attr_quiesce()

Fair enough, I should have called this one invalidate_super.

>
>> and ->bdi_gone() is a set of actions to take after the backing device
>> is known to be permanently dead.
>
> In which case, bdi_gone == shutdown.
>

True, and following this logic I think the existing
generic_shutdown_super() should be renamed generic_kill_super() to
match the fs actions, but see below...

> Operation methods should be named after what they do, not what their
> calling context is. i.e. these are "invalidate" and "shutdown"
> superblock operations, not "quiesce" and "bdi_gone".

I was running out of colors to paint the bike shed given
generic_shutdown_super() was already in use.  Also, since
generic_shutdown_super() has had its current meaning since forever I
didn't think it was worth the risk to change the meaning of such a
long standing symbol.  Other ideas, generic_stop_super?

>> generic_quiesce_super and generic_bdi_gone, are the default operations
>> when a filesystem does not implement ->quiesce(), ->bdi_gone().  They
>> invalidate inodes and unmap DAX-inodes respectively.  For now only
>> ->bdi_gone() has an associated super operation as xfs will implement
>> ->bdi_gone() in a later patch.
>
> I don't quite understand what the point of factoring
> __invalidate_device() like this is - it's not used by anyone, so it
> seems completely unnecessary to me.
>

You're right, without a need for an fs to intercept the 'invalidation'
event there's no need to do this refactor.

> And really, that points out that there are multiple changes in this
> patch set that should be done separately.  The rework of
> del_gendisk() into del_gendisk_start/del_gendisk_end should be the
> first patch.  The del_gendisk/blk_cleanup_queue to
> blk_cleanup_queue() combining should be the second part, as it
> builds on the factoring of del_gendisk(). Then, if we really need to
> keep it, the factoring to introduce generic_quiesce_super. And
> finally, the patch that allows the shutdown callout can be
> introduced.

Ok, will split.

>
> [snip]
>>
>> +static void generic_bdi_gone(struct super_block *sb)
>> +{
>> +     struct inode *inode, *_inode = NULL;
>> +
>> +     spin_lock(&sb->s_inode_list_lock);
>> +     list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>> +             spin_lock(&inode->i_lock);
>> +             if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
>> +                             || !IS_DAX(inode)) {
>> +                     spin_unlock(&inode->i_lock);
>> +                     continue;
>> +             }
>> +             __iget(inode);
>> +             spin_unlock(&inode->i_lock);
>> +             spin_unlock(&sb->s_inode_list_lock);
>> +
>> +             unmap_mapping_range(inode->i_mapping, 0, 0, 1);
>> +             iput(_inode);
>> +             _inode = inode;
>> +             cond_resched();
>> +
>> +             spin_lock(&sb->s_inode_list_lock);
>> +     }
>> +     spin_unlock(&sb->s_inode_list_lock);
>> +     iput(_inode);
>> +}
>
> This belongs in fs/inode.c, right next to invalidate_inodes(), and
> with a name that describes what it does, not the context in which
> it is called. e.g. unmap_dax_inodes().
>

Sounds good.

>> +void shutdown_partition(struct gendisk *disk, int partno)
>> +{
>> +     struct block_device *bdev = bdget_disk(disk, partno);
>> +     struct super_block *sb = get_super(bdev);
>> +
>> +     if (!bdev)
>> +             return;
>
> Null pointer deref. Certainly a landmine waiting for someone to
> tread on.
>

Nope, get_super() checks for a NULL argument.

>> +     if (!sb) {
>> +             bdput(bdev);
>> +             return;
>> +     }
>> +
>> +     if (sb->s_op->bdi_gone)
>> +             sb->s_op->bdi_gone(sb);
>> +     else
>> +             generic_bdi_gone(sb);
>
>         if (sb->s_op->shutdown)
>                 sb->s_op->shutdown(sb);
>         else
>                 unmap_dax_inodes(sb);
>
> name things correctly, and the code documents itself.

How about 'stop' or 'halt' instead of 'shutdown' to preserve the
historical meaning of generic_shutdown_super?
