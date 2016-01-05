Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20160105042346.GL19802@dastard>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182016.24118.33718.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160105042346.GL19802@dastard>
Date: Tue, 5 Jan 2016 11:59:41 -0800
Message-ID: <CAPcyv4hNy8uewa4AzncfRxrd_Bo0Thpo4mBdr4gTVwO_9bXEqA@mail.gmail.com>
Subject: Re: [resend PATCH 3/3] writeback: fix false positive WARN in __mark_inode_dirty
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 4, 2016 at 8:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jan 04, 2016 at 10:20:16AM -0800, Dan Williams wrote:
>> This warning was added as a debugging aid way back in commit
>> 500b067c5e6c "writeback: check for registered bdi in flusher add and
>> inode dirty" when we were switching over to per-bdi writeback.
>>
>> Once the block device has been torn down it's no longer useful to
>> complain about unregistered bdi's.  Clear the writeback capability under
>> the the wb->list_lock(), so that __mark_inode_dirty has no opportunity
>> to race bdi_unregister() to this WARN() condition.
>>
>> Alternatively we could just delete the warning...
>
> The warning is correct - the filesytem is trying to mark an inode
> dirty on a device that can't do writeback anymore. Seems to me like
> it is functioning as it should.
>
>> Found this while testing block device remove from underneath an active
>> fs triggering traces like:
>>
>>  WARNING: CPU: 6 PID: 2129 at fs/fs-writeback.c:2065 __mark_inode_dirty+0x261/0x350()
>>  bdi-block not registered
>>  [..]
>>  Call Trace:
>>   [<ffffffff81459f02>] dump_stack+0x44/0x62
>>   [<ffffffff810a1f32>] warn_slowpath_common+0x82/0xc0
>>   [<ffffffff810a1fcc>] warn_slowpath_fmt+0x5c/0x80
>>   [<ffffffff812830b1>] __mark_inode_dirty+0x261/0x350
>>   [<ffffffff8126d019>] generic_update_time+0x79/0xd0
>>   [<ffffffff8126d19d>] file_update_time+0xbd/0x110
>>   [<ffffffff812e4ab8>] ext4_dax_fault+0x68/0x110
>>   [<ffffffff811f7f3e>] __do_fault+0x4e/0xf0
>
> This seems like the problem to me - you haven't implemented a
> shutdown hook for ext4, and so it continues to allow page faults to
> make progress after the device has been removed. The DAX fault
> should have been failed before the filesystem gets to the point of
> marking the inode dirty....

xfs doesn't check that the fs is still alive before calling
file_update_time().  Also, I don't think we need/want to sprinkle "is
fs alive?" checks to address this when the block device shutdown path
can simply turn off writeback.

>
>> +     /* tell __mark_inode_dirty that writeback is no longer possible */
>> +     spin_lock(&wb->list_lock);
>> +     wb->bdi->capabilities |= BDI_CAP_NO_WRITEBACK;
>> +     spin_unlock(&wb->list_lock);
>> +
>>       spin_unlock_bh(&wb->work_lock);
>
> Is that lock ordering safe? i.e. it's inside a section using bh-safe
> locking, which tends to imply that it can run from interrupt
> contexts. Can we get something like

This would be a problem if wb_shutdown() was called from softirq
context, but it is always called from process context.  So,
->list_lock doesn't currently need to be upgraded to spin_lock_bh and
lockdep will trigger if this situation changes.
