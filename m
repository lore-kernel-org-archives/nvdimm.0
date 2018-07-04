Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131])
 by ml01.01.org (Postfix) with ESMTP id 862FE202E541E
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 17:49:28 -0700 (PDT)
Date: Wed, 4 Jul 2018 10:49:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/2] ext4: handle layout changes to pinned DAX mappings
Message-ID: <20180704004923.GT19934@dastard>
References: <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180702172912.329-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180702172912.329-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 02, 2018 at 11:29:12AM -0600, Ross Zwisler wrote:
> Follow the lead of xfs_break_dax_layouts() and add synchronization between
> operations in ext4 which remove blocks from an inode (hole punch, truncate
> down, etc.) and pages which are pinned due to DAX DMA operations.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> ---
> 
> Changes since v2:
>  * Added a comment to ext4_insert_range() explaining why we don't call
>    ext4_break_layouts(). (Jan)

Which I think is wrong and will cause data corruption.

> @@ -5651,6 +5663,11 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
>  			LLONG_MAX);
>  	if (ret)
>  		goto out_mmap;
> +	/*
> +	 * We don't need to call ext4_break_layouts() because we aren't
> +	 * removing any blocks from the inode.  We are just changing their
> +	 * offset by inserting a hole.
> +	 */

The entire point of these leases is so that a thrid party can
directly access the blocks underlying the file. That means they are
keeping their own file offset<->disk block mapping internally, and
they are assuming that it is valid for as long as they hold the
lease. If the filesystem modifies the extent map - even something
like a shift here which changes the offset<->disk block mapping -
the userspace app now has a stale mapping and so the lease *must be
broken* to tell it that it's mappings are now stale and it needs to
refetch them.

If the app doesn't refetch it's mappings after something like a
shift, it will be reading and writing data from the wrong file
offset, and that will lead to the app silently corrupting it's data.
IOWs, layouts need to be broken by any operation that modifies the
extent map in any way, not just those operations that remove blocks.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
