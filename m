Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id DB39B21CAD998
 for <linux-nvdimm@lists.01.org>; Sun,  5 Aug 2018 20:55:53 -0700 (PDT)
Date: Mon, 6 Aug 2018 13:55:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Message-ID: <20180806035550.GE7395@dastard>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz>
 <20180725222839.GA28304@linux.intel.com>
 <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
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
To: Ross Zwisler <zwisler@kernel.org>
Cc: Jan Kara <jack@suse.cz>, darrick.wong@oracle.com, linux-nvdimm@lists.01.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 27, 2018 at 10:28:51AM -0600, Ross Zwisler wrote:
> + fsdevel and the xfs list.
> 
> On Wed, Jul 25, 2018 at 4:28 PM Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Wed, Jul 11, 2018 at 10:17:41AM +0200, Jan Kara wrote:
> > > On Tue 10-07-18 13:10:29, Ross Zwisler wrote:
> > > > Changes since v3:
> > > >  * Added an ext4_break_layouts() call to ext4_insert_range() to ensure
> > > >    that the {ext4,xfs}_break_layouts() calls have the same meaning.
> > > >    (Dave, Darrick and Jan)
> > >
> > > How about the occasional WARN_ON_ONCE you mention below. Were you able to
> > > hunt them down?
> >
> > The root cause of this issue is that while the ei->i_mmap_sem provides
> > synchronization between ext4_break_layouts() and page faults, it doesn't
> > provide synchronize us with the direct I/O path.  This exact same issue exists
> > in XFS AFAICT, with the synchronization tool there being the XFS_MMAPLOCK.

That's not correct for XFS.

Truncate/holepunch in XFS hold *both* the MMAPLOCK and the IOLOCK in
exclusive mode. Holding the MMAPLOCK serialises against page faults,
holding the IOLOCK serialises against buffered IO and Direct IO
submission. The inode_dio_wait() call that truncate/holepunch does
after gaining the IOLOCK ensures that we wait for all direct IO in
progress to complete (e.g. AIO) before the truncate/holepunch goes
ahead. e.g:

STATIC long
xfs_file_fallocate(
        struct file             *file,
        int                     mode,
        loff_t                  offset,
        loff_t                  len)
{
.....
        uint                    iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
.....
        xfs_ilock(ip, iolock);
        error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
.....
	if (mode & FALLOC_FL_PUNCH_HOLE) {
		error = xfs_free_file_space(ip, offset, len);


and then xfs_free_file_space calls xfs_flush_unmap_range() which
waits for direct IO to complete, flushes all the dirty cached pages
and then invalidates the page cache before doing any extent
manipulation. The cannot be any IO or page faults in progress after
this point.....

truncate (through xfs_vn_setattr() essentially does the same thing,
except that it's called with the IOLOCK already held exclusively
(remember the IOLOCK is the vfs inode->i_rwsem).

> > This allows the direct I/O path to do I/O and raise & lower page->_refcount
> > while we're executing a truncate/hole punch.  This leads to us trying to free
> > a page with an elevated refcount.

I don't see how this is possible in XFS - maybe I'm missing
something, but "direct IO submission during truncate" is not
something that should ever be happening in XFS, DAX or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
