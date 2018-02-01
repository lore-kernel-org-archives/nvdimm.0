Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D77E222393623
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 16:34:30 -0800 (PST)
Subject: Re: [PATCH] xfs: fix rt_dev usage for DAX
References: <151744400024.39505.6657033185117899561.stgit@djiang5-desk3.ch.intel.com>
 <20180201002953.GJ4849@magnolia>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7a22fabe-2a52-e148-8cd9-5eadd7054160@intel.com>
Date: Wed, 31 Jan 2018 17:40:06 -0700
MIME-Version: 1.0
In-Reply-To: <20180201002953.GJ4849@magnolia>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 01/31/2018 05:29 PM, Darrick J. Wong wrote:
> On Wed, Jan 31, 2018 at 05:13:20PM -0700, Dave Jiang wrote:
>> When using realtime device (rtdev) with xfs where the data device is not
>> DAX capable, two issues arise. One is when data device is not DAX but the
>> realtime device is DAX capable, we currently disable DAX.
>> After passing this check, we are also not marking the inode as DAX capable.
>> This change will allow DAX enabled if the data device or the realtime
>> device is DAX capable. S_DAX will be marked for the inode if the file is
>> residing on a DAX capable device. This will prevent the case of rtdev is not
>> DAX and data device is DAX to create realtime files.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> Reported-by: Darrick Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/xfs_iops.c  |    3 ++-
>>   fs/xfs/xfs_super.c |    2 +-
>>   2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 56475fcd76f2..ab352c325301 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -1204,7 +1204,8 @@ xfs_diflags_to_iflags(
>>   	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
>>   	    !xfs_is_reflink_inode(ip) &&
>>   	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
>> -	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
>> +	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX) &&
>> +	    blk_queue_dax(bdev_get_queue(inode->i_sb->s_bdev)))
>>   		inode->i_flags |= S_DAX;
>>   }
>>   
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 1dacccc367f8..2b2a02bcf72e 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1653,7 +1653,7 @@ xfs_fs_fill_super(
>>   		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>>   
>>   		error = bdev_dax_supported(sb, sb->s_blocksize);
>> -		if (error) {
>> +		if (error && !mp->m_rtdev_targp->bt_daxdev) {
> 
> Don't we have to do all the other __bdev_dax_supported checks on the
> rtdev too?  It seems to want to check that dax_direct_access actually
> works before it commits to returning 0, and I don't see why you wouldn't
> do that for the dax rtdev too.

Ok. I was thinking that fs_dax_get_by_bdev() from xfs_open_devices() was 
sufficient. I think now your comment that __bdev_dax_supported() should 
take a block_device rather than a super_block makes sense.

> 
> --D
> 
>>   			xfs_alert(mp,
>>   			"DAX unsupported by block device. Turning off DAX.");
>>   			mp->m_flags &= ~XFS_MOUNT_DAX;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
