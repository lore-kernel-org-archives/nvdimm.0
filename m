Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0DB622225C18
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 18:16:12 -0800 (PST)
Received: by mail-ot0-x22c.google.com with SMTP id n18so248323otd.1
 for <linux-nvdimm@lists.01.org>; Tue, 02 Jan 2018 18:21:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180102230027.GV5858@dastard>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407705701.38751.6157642918168721562.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102230027.GV5858@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jan 2018 18:21:13 -0800
Message-ID: <CAPcyv4gXxoLwZUyHYGUN2i71fjT_r=Mf+USYDLKwPGEYco+1PQ@mail.gmail.com>
Subject: Re: [PATCH v4 18/18] xfs, dax: wire up dax_flush_dma support via a
 new xfs_sync_dma helper
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 2, 2018 at 3:00 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Dec 23, 2017 at 04:57:37PM -0800, Dan Williams wrote:
>> xfs_break_layouts() scans for active pNFS layouts, drops locks and
>> rescans for those layouts to be broken. xfs_sync_dma performs
>> xfs_break_layouts and also scans for active dax-dma pages, drops locks
>> and rescans for those pages to go idle.
>>
>> dax_flush_dma handles synchronizing against new page-busy events
>> (get_user_pages). iIt invalidates all mappings to trigger the
>> get_user_pages slow path which will eventually block on the
>> XFS_MMAPLOCK. If it finds a dma-busy page it waits for a page-idle
>> callback that will fire when the page reference count reaches 1 (recall
>> ZONE_DEVICE pages are idle at count 1). While it is waiting, it drops
>> locks so we do not deadlock the process that might be trying to elevate
>> the page count of more pages before arranging for any of them to go idle
>> as is typically the case of iov_iter_get_pages.
>>
>> dax_flush_dma relies on the fs-provided wait_atomic_t_action_f
>> (xfs_wait_dax_page) to handle evaluating the page reference count and
>> dropping locks when waiting.
>
> I don't see a problem with supporting this functionality, but I
> see lots of problems with the code being presented. First of all,
> I think the "sync dma" abstraction here is all wrong.
>
> In the case of the filesystem, we don't care about whether DMA has
> completed or not, and we *shouldn't have to care* about deep, dark
> secrets of other subsystems.
>
> If I read the current code, I see this in all the "truncate" paths:
>
>         start op
>         break layout leases
>         change layout
>
> and in the IO path:
>
>         start IO
>         break layout leases
>         map IO
>         issue IO
>
> What this change does is make the truncate paths read:
>
>         start op
>         sync DMA
>         change layout
>
> but the IO path is unchanged. (This is not explained in comments or
> commit messages).
>
> And I look at that "sync DMA" step and wonder why the hell we need
> to "sync DMA" because DMA has nothing to do with high level
> filesystem code. It doesn't tell me anything obvious about why we
> need to do this, nor does it tell me what we're actually
> synchronising against.
>
> What we care about in the filesystem code is whether there are
> existing external references to file layout. If there's an external
> reference, then it has to be broken before we can proceed and modify
> the file layout. We don't care what owns that reference, just that
> it has to broken before we continue.
>
> AFAIC, these DMA references are just another external layout
> reference that needs to be broken.  IOWs, this "sync DMA" complexity
> needs to go inside xfs_break_layouts() as it is part of breaking the
> external reference to the file layout - it does not replace the
> layout breaking abstraction and so the implementation needs to
> reflect that.

These two sentences from the xfs_break_layouts() comment scared me
down this path of distinguishing dax-dma waiting from pNFS layout
lease break waiting:

---

"Additionally we call it during the write operation, where aren't
concerned about exposing unallocated blocks but just want to provide
basic synchronization between a local writer and pNFS clients.  mmap
writes would also benefit from this sort of synchronization, but due
to the tricky locking rules in the page fault path we don't bother."

---

I was not sure about holding XFS_MMAPLOCK_EXCL over
xfs_break_layouts() where it has historically not been held, and I was
worried about the potential deadlock of requiring all pages to be
unmapped and idle during a write. I.e. would we immediately deadlock
if userspace performed  direct-I/O to a file with a source buffer that
was mapped from that same file?

In general though, I agree that xfs_break_layouts() should comprehend
both cases. I'll investigate if the deadlock is real and perhaps add a
flag to xfs_break_layouts to distinguish the IO path from the truncate
paths to at least make that detail internal to the layout breaking
mechanism.

>> + * Synchronize [R]DMA before changing the file's block map. For pNFS,
>> + * recall all layouts. For DAX, wait for transient DMA to complete. All
>> + * other DMA is handled by pinning page cache pages.
>> + *
>> + * iolock must held XFS_IOLOCK_SHARED or XFS_IOLOCK_EXCL on entry and
>> + * will be XFS_IOLOCK_EXCL and XFS_MMAPLOCK_EXCL on exit.
>> + */
>> +int xfs_sync_dma(
>> +     struct inode            *inode,
>> +     uint                    *iolock)
>> +{
>> +     struct xfs_inode        *ip = XFS_I(inode);
>> +     int                     error;
>> +
>> +     while (true) {
>> +             error = xfs_break_layouts(inode, iolock);
>> +             if (error)
>> +                     break;
>> +
>> +             xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>> +             *iolock |= XFS_MMAPLOCK_EXCL;
>> +
>> +             error = dax_flush_dma(inode->i_mapping, xfs_wait_dax_page);
>> +             if (error <= 0)
>> +                     break;
>> +             xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>> +             *iolock &= ~XFS_MMAPLOCK_EXCL;
>> +     }
>
> At this level the loop seems sub-optimal. If we don't drop the
> IOLOCK, then we have no reason to call xfs_break_layouts() a second
> time.  Hence in isolation this loop doesn' make sense. Yes, I
> realise that dax_flush_dma() can result in all locks on the inode
> being dropped, but that's hidden in another function whose calling
> scope is not at all obvious from this code.
>
> Also, xfs_wait_dax_page() assumes we have IOLOCK_EXCL held when it
> is called. Nothing enforces the requirement that xfs_sync_dma() is
> passed XFS_IOLOCK_EXCL, and so such assumptions cannot be made.
> Even if it was, I really dislike the idea of a function that
> /assumes/ lock state - that's a landmine that will bite us in the
> rear end at some unexpected point in the future. If you need to
> cycle held locks on an inode, you need to pass the held lock state
> to the function.

I agree, and I thought about this, but at the time the callback is
made the only way we could pass the lock context to
xfs_wait_dax_page() would be to temporarily store it in the 'struct
page' which seemed ugly at first glance.

However, we do have space, we could alias it with the other unused
8-bytes of page->lru.

At least that cleans up the filesystem interface to not need to make
implicit locking assumptions... I'll go that route.

> Another gripe I have is that calling xfs_sync_dma() implies the mmap
> lock is held exclusively on return. Hiding this locking inside
> xfs_sync_dma removes the code documentation that large tracts of
> code are protected against page faults by the XFS_MMAPLOCK_EXCL lock
> call.  Instead of knowing at a glance that the truncate path
> (xfs_vn_setattr) is protected against page faults, I have to
> remember that xfs_sync_dma() now does this.
>
> This goes back to my initial comments of "what the hell does "sync
> dma" mean in a filesystem context?" - it certainly doesn't make me
> think about inode locking. I don't like hidden/implicitly locking
> like this, because it breaks both the least-surprise and the
> self-documenting code principles....

Thanks for this Dave, it's clear. I'll a spin a new version with some
of the reworks proposed above, but holler if those don't address your
core concern.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
