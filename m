Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id C841D1A1E40
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 14:55:18 -0800 (PST)
Date: Fri, 11 Mar 2016 15:54:23 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 01/12] DAX: move RADIX_DAX_ definitions to dax.c
Message-ID: <20160311225423.GB30106@linux.intel.com>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457637535-21633-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 10, 2016 at 08:18:44PM +0100, Jan Kara wrote:
> From: NeilBrown <neilb@suse.com>
> 
> These don't belong in radix-tree.c any more than PAGECACHE_TAG_* do.
> Let's try to maintain the idea that radix-tree simply implements an
> abstract data type.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> ---
>  fs/dax.c                   | 9 +++++++++
>  include/linux/radix-tree.h | 9 ---------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 711172450da6..9c4d697fb6fc 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -32,6 +32,15 @@
>  #include <linux/pfn_t.h>
>  #include <linux/sizes.h>
>  
> +#define RADIX_DAX_MASK	0xf
> +#define RADIX_DAX_SHIFT	4
> +#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
> +#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
> +#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
> +#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
> +#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
> +		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
> +
>  static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
>  {
>  	struct request_queue *q = bdev->bd_queue;
> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index f54be7082207..968150ab8a1c 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -51,15 +51,6 @@
>  #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
>  #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
>  
> -#define RADIX_DAX_MASK	0xf
> -#define RADIX_DAX_SHIFT	4
> -#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
> -#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
> -#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
> -#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
> -#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
> -		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
> -
>  static inline int radix_tree_is_indirect_ptr(void *ptr)
>  {
>  	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
> -- 
> 2.6.2
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
