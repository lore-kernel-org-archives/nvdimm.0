Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143])
 by ml01.01.org (Postfix) with ESMTP id 5EDD32095E010
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 16:31:05 -0700 (PDT)
Date: Sat, 12 Aug 2017 09:33:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 6/6] mm, xfs: protect swapfile contents with immutable
 + unwritten extents
Message-ID: <20170811233323.GU21024@dastard>
References: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150243358949.8777.17308615269167142735.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150243358949.8777.17308615269167142735.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, darrick.wong@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 10, 2017 at 11:39:49PM -0700, Dan Williams wrote:
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 851982a5dfbc..a0f099289520 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -113,6 +113,15 @@ struct xfs_extent_free_item
>  /* Only convert delalloc space, don't allocate entirely new extents */
>  #define XFS_BMAPI_DELALLOC	0x400
>  
> +/*
> + * Permit extent manipulations even if S_IOMAP_IMMUTABLE is set on the
> + * inode. This is only expected to be used in the swapfile activation
> + * case where we want to mark all swap space as unwritten so that reads
> + * return zero and writes fail with ETXTBSY. Storage access in this
> + * state can only occur via swap operations.
> + */
> +#define XFS_BMAPI_FORCE		0x800

Urk. No. Immutable means immutable.

And, as a matter of policy, we should not be changing the on disk
layout of the swapfile that is provided inside the kernel.  If the
swap file is already allocated as unwritten, great. If not, we
should not force it to be unwritten to be because then if the user
downgrades their kernel the swapfile suddenly can not be used by the
older kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
