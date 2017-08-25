Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 321B52095DCB2
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 17:11:20 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id r9so9064027oie.3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 17:13:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824152207.30729-4-hch@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 17:13:54 -0700
Message-ID: <CAPcyv4i0kNowtfDQpjJPU+o1xnsAskB+-O8cFzdLivdeoEEJkw@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: support for synchronous DAX faults
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 8:22 AM, Christoph Hellwig <hch@lst.de> wrote:
> Return IOMAP_F_NEEDDSYNC from xfs_file_iomap_begin() for a synchronous
> write fault when inode is pinned, and has dirty fields other than the
> timestamps.  In xfs_filemap_huge_fault() we then detect this case and
> call dax_finish_sync_fault() to make sure all metadata is committed, and
> to insert the page table entry.
>
> Note that this will also dirty corresponding radix tree entry which is
> what we want - fsync(2) will still provide data integrity guarantees for
> applications not using userspace flushing. And applications using
> userspace flushing can avoid calling fsync(2) and thus avoid the
> performance overhead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c  | 6 +++++-
>  fs/xfs/xfs_iomap.c | 5 +++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 460ca9639e66..5c3597b7dbf9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1031,7 +1031,11 @@ __xfs_filemap_fault(
>
>         xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>         if (IS_DAX(inode)) {
> -               ret = dax_iomap_fault(vmf, pe_size, NULL, &xfs_iomap_ops);
> +               pfn_t pfn;
> +
> +               ret = dax_iomap_fault(vmf, pe_size, &pfn, &xfs_iomap_ops);
> +               if (ret & VM_FAULT_NEEDDSYNC)
> +                       ret = dax_finish_sync_fault(vmf, pe_size, pfn);
>         } else {
>                 if (write_fault)
>                         ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 813394c62849..e7c762c8fe27 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -33,6 +33,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
> +#include "xfs_inode_item.h"
>  #include "xfs_iomap.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> @@ -1085,6 +1086,10 @@ xfs_file_iomap_begin(
>                 trace_xfs_iomap_found(ip, offset, length, 0, &imap);
>         }
>
> +       if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> +           (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> +               iomap->flags |= IOMAP_F_NEEDDSYNC;
> +

So this behaves differently than ext4 that returns EOPNOTSUP in the !DAX case.

Are we generally documenting MAP_SYNC to be ignored in the pagecache
case? Or should we explicitly fail MAP_SYNC for the !DAX case on all
filesystems?

Another option is to finish block allocations at fault time in the
pagecache+MAP_SYNC case, but still require fsync to writeback dirty
pages, but that seems pointless.

Whatever we do I think all implementations should agree.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
