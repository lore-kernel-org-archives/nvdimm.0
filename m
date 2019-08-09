Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au
 [211.29.132.249])
 by ml01.01.org (Postfix) with ESMTP id 64DBC2131474B
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 16:34:28 -0700 (PDT)
Date: Sat, 10 Aug 2019 09:30:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 07/19] fs/xfs: Teach xfs to use new
 dax_layout_busy_page()
Message-ID: <20190809233037.GB7777@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-8-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190809225833.6657-8-ira.weiny@intel.com>
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
To: ira.weiny@intel.com
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 09, 2019 at 03:58:21PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> dax_layout_busy_page() can now operate on a sub-range of the
> address_space provided.
> 
> Have xfs specify the sub range to dax_layout_busy_page()

Hmmm. I've got patches that change all these XFS interfaces to
support range locks. I'm not sure the way the ranges are passed here
is the best way to do it, and I suspect they aren't correct in some
cases, either....

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ff3c1fae5357..f0de5486f6c1 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1042,10 +1042,16 @@ xfs_vn_setattr(
>  		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>  		iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  
> -		error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
> -		if (error) {
> -			xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> -			return error;
> +		if (iattr->ia_size < inode->i_size) {
> +			loff_t                  off = iattr->ia_size;
> +			loff_t                  len = inode->i_size - iattr->ia_size;
> +
> +			error = xfs_break_layouts(inode, &iolock, off, len,
> +						  BREAK_UNMAP);
> +			if (error) {
> +				xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> +				return error;
> +			}

This isn't right - truncate up still needs to break the layout on
the last filesystem block of the file, and truncate down needs to
extend to "maximum file offset" because we remove all extents beyond
EOF on a truncate down.

i.e. when we use preallocation, the extent map extends beyond EOF,
and layout leases need to be able to extend beyond the current EOF
to allow the lease owner to do extending writes, extending truncate,
preallocation beyond EOF, etc safely without having to get a new
lease to cover the new region in the extended file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
