From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/23] xfs: use uuid_be to implement the uuid_t type
Date: Thu, 18 May 2017 16:34:39 -0700
Message-ID: <20170518233439.GF4519@birch.djwong.org>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170518062705.25902-3-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, May 18, 2017 at 08:26:44AM +0200, Christoph Hellwig wrote:
> Use the generic Linux definition to implement our UUID type, this will
> allow using more generic infrastructure in the future.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Reviewed-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--D

> ---
>  fs/xfs/uuid.h      | 4 ----
>  fs/xfs/xfs_linux.h | 3 +++
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
> index 104db0f3bed6..4f1441ba4fa5 100644
> --- a/fs/xfs/uuid.h
> +++ b/fs/xfs/uuid.h
> @@ -18,10 +18,6 @@
>  #ifndef __XFS_SUPPORT_UUID_H__
>  #define __XFS_SUPPORT_UUID_H__
>  
> -typedef struct {
> -	unsigned char	__u_bits[16];
> -} uuid_t;
> -
>  extern int uuid_is_nil(uuid_t *uuid);
>  extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
>  extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 044fb0e15390..89ee5ec66837 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -19,6 +19,7 @@
>  #define __XFS_LINUX__
>  
>  #include <linux/types.h>
> +#include <linux/uuid.h>
>  
>  /*
>   * Kernel specific type declarations for XFS
> @@ -38,6 +39,8 @@ typedef __s64			xfs_daddr_t;	/* <disk address> type */
>  typedef __u32			xfs_dev_t;
>  typedef __u32			xfs_nlink_t;
>  
> +typedef uuid_be			uuid_t;
> +
>  #include "xfs_types.h"
>  
>  #include "kmem.h"
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
