Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2110120955F0F
 for <linux-nvdimm@lists.01.org>; Tue, 27 Feb 2018 09:08:18 -0800 (PST)
Date: Tue, 27 Feb 2018 09:14:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
Message-ID: <20180227171419.GJ19312@magnolia>
References: <151880058592.43131.558230052922233871.stgit@djiang5-desk3.ch.intel.com>
 <151880066614.43131.15847174332875373188.stgit@djiang5-desk3.ch.intel.com>
 <20180216172247.GS5217@magnolia> <20180218002317.GU7000@dastard>
 <20180220230109.GG27629@magnolia> <20180220231524.GD7000@dastard>
 <20180220232358.GH27629@magnolia>
 <1e6ed5f9-fdc1-f0f4-1ff7-e068f6506f39@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1e6ed5f9-fdc1-f0f4-1ff7-e068f6506f39@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 27, 2018 at 09:46:54AM -0700, Dave Jiang wrote:
> 
> 
> On 02/20/2018 04:23 PM, Darrick J. Wong wrote:
> > On Wed, Feb 21, 2018 at 10:15:24AM +1100, Dave Chinner wrote:
> >> On Tue, Feb 20, 2018 at 03:01:09PM -0800, Darrick J. Wong wrote:
> >>> On Sun, Feb 18, 2018 at 11:23:17AM +1100, Dave Chinner wrote:
> >>>> On Fri, Feb 16, 2018 at 09:22:47AM -0800, Darrick J. Wong wrote:
> >>>>> On Fri, Feb 16, 2018 at 10:04:26AM -0700, Dave Jiang wrote:
> >>>>>> In a situation where the rt_dev is DAX and data_dev is not DAX, if the user
> >>>>>> requests to remove the realtime flag via ioctl we can no longer support DAX
> >>>>>> for that file. Dynamic changing of S_DAX on the inode is not supported due
> >>>>>> to various complications in the existing implementation. Therefore until we
> >>>>>> address the dynamic S_DAX change issues, we must disallow realtime flag
> >>>>>> being removed.
> >>>>>>
> >>>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >>>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >>>>>> ---
> >>>>>>  fs/xfs/xfs_ioctl.c |   14 ++++++++++++++
> >>>>>>  1 file changed, 14 insertions(+)
> >>>>>>
> >>>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> >>>>>> index 2c70a0a4f59f..edd97d527fe8 100644
> >>>>>> --- a/fs/xfs/xfs_ioctl.c
> >>>>>> +++ b/fs/xfs/xfs_ioctl.c
> >>>>>> @@ -1030,6 +1030,20 @@ xfs_ioctl_setattr_xflags(
> >>>>>>  {
> >>>>>>  	struct xfs_mount	*mp = ip->i_mount;
> >>>>>>  	uint64_t		di_flags2;
> >>>>>> +	struct inode		*inode = VFS_I(ip);
> >>>>>> +	struct super_block	*sb = inode->i_sb;
> >>>>>> +
> >>>>>> +	/*
> >>>>>> +	 * In the case that the inode is realtime, and we are trying to remove
> >>>>>> +	 * the realtime flag, and the rtdev supports DAX but the datadev does
> >>>>>> +	 * not support DAX, we can't allow the realtime flag to be removed
> >>>>>> +	 * since we do not support dynamic S_DAX flag removal yet.
> >>>>>> +	 */
> >>>>>> +	if (XFS_IS_REALTIME_INODE(ip) &&
> >>>>>> +	    !(fa->fsx_xflags & FS_XFLAG_REALTIME) &&
> >>>>>> +	    bdev_dax_supported(mp->m_rtdev_targp->bt_bdev, sb->s_blocksize) &&
> >>>>>> +	    !bdev_dax_supported(mp->m_ddev_targp->bt_bdev, sb->s_blocksize))
> >>>>>
> >>>>> What happens here if we have a non-rt file that we're trying to turn
> >>>>> into an rt file and the data dev supports dax but not the rt dev?
> >>>>>
> >>>>> Changing the rt flag is only supported on files with no data blocks (no
> >>>>> extents, no delalloc blocks), so why can't we remove S_DAX from an empty
> >>>>> file?  There aren't any memory mappings or page cache to get in the way,
> >>>>> correct?
> >>>>
> >>>> File size can be non-zero, so you can have DAX read-over-hole
> >>>> mappings present. I simply don't think it's safe to remove/add S_DAX
> >>>> flags via ioctls right now. If we have a DAX capable rtdev, then the
> >>>> only way we should allow rtdev+dax to be used right now is via the
> >>>> RT inherit bit on the dir that creates files in the rtdev right from
> >>>> the start. i.e. we can't set/remove the RT inode flag on an inode
> >>>> via ioctl if rtdev+dax is enabled until the whole dynamic S_DAX
> >>>> inode flag thing is resolved.
> >>>
> >>> Could we deal with the restriction that the DAX flag can't change
> >>> (whether by user ioctl or by toggling the rt flag) unless the file size
> >>> is zero?  That adds another way setting/clearing the realtime flag can
> >>> fail, but at least it'd be the same EINVAL.
> >>
> >> I thought we still mmap a zero length file and get a page fault that
> >> returns a zeroed page? Or does that segv?
> > 
> > I think it segfaults, but let's see...
> > 
> > $ rm -rf /opt/b ; xfs_io -f -c 'mmap -rw 0 1m' -c 'mread 512 20' /opt/b
> > Bus error
> > $ rm -rf /opt/b ; xfs_io -f -c 'mmap -rw 0 1m' -c 'mwrite 512 20' /opt/b
> > Bus error
> 
> Darrick,
> So you want the change to be if the file size is 0 then we can modify
> the RT bit, otherwise reject if DAX is involved?

The other way around -- reject any change to the DAX flag if the file
size is not zero, regardless of whether the user tried to change the DAX
flag directly or the change is happening because the user changed the RT
flag and the device dax support is different between the rt & data
devices.

We'll need more rigorous testing of this current theory that we can
change S_DAX without problems if the file size is zero, once this change
has been written.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
