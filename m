Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au
 [211.29.132.249])
 by ml01.01.org (Postfix) with ESMTP id C3D702131474B
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 16:26:05 -0700 (PDT)
Date: Sat, 10 Aug 2019 09:22:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 08/19] fs/xfs: Fail truncate if page lease can't
 be broken
Message-ID: <20190809232209.GA7777@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-9-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190809225833.6657-9-ira.weiny@intel.com>
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

On Fri, Aug 09, 2019 at 03:58:22PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> If pages are under a lease fail the truncate operation.  We change the order of
> lease breaks to directly fail the operation if the lease exists.
> 
> Select EXPORT_BLOCK_OPS for FS_DAX to ensure that xfs_break_lease_layouts() is
> defined for FS_DAX as well as pNFS.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/Kconfig        | 1 +
>  fs/xfs/xfs_file.c | 5 +++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 14cd4abdc143..c10b91f92528 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -48,6 +48,7 @@ config FS_DAX
>  	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
>  	select FS_IOMAP
>  	select DAX
> +	select EXPORTFS_BLOCK_OPS
>  	help
>  	  Direct Access (DAX) can be used on memory-backed block devices.
>  	  If the block device supports DAX and the filesystem supports DAX,

That looks wrong. If you require xfs_break_lease_layouts() outside
of pnfs context, then move the function in the XFS code base to a
file that is built in. It's only external dependency is on the
break_layout() function, and XFS already has other unconditional
direct calls to break_layout()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
