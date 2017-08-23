Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A3B32095B9E0
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 02:55:54 -0700 (PDT)
Date: Wed, 23 Aug 2017 11:58:25 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/2] dax: use PG_PMD_COLOUR instead of open coding
Message-ID: <20170823095825.GB2100@quack2.suse.cz>
References: <20170822220926.13799-1-ross.zwisler@linux.intel.com>
 <20170822222436.18926-1-ross.zwisler@linux.intel.com>
 <20170822222436.18926-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170822222436.18926-2-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Slusarz, Marcin" <marcin.slusarz@intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 22-08-17 16:24:36, Ross Zwisler wrote:
> Use ~PG_PMD_COLOUR in dax_entry_waitqueue() instead of open coding an
> equivalent page offset mask.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 865d42c..0e2a1fd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -42,6 +42,9 @@
>  #define DAX_WAIT_TABLE_BITS 12
>  #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
>  
> +/* The 'colour' (ie low bits) within a PMD of a page offset.  */
> +#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
> +
>  static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
>  
>  static int __init init_dax_wait_table(void)
> @@ -98,7 +101,7 @@ static wait_queue_head_t *dax_entry_waitqueue(struct address_space *mapping,
>  	 * the range covered by the PMD map to the same bit lock.
>  	 */
>  	if (dax_is_pmd_entry(entry))
> -		index &= ~((1UL << (PMD_SHIFT - PAGE_SHIFT)) - 1);
> +		index &= ~PG_PMD_COLOUR;
>  
>  	key->mapping = mapping;
>  	key->entry_start = index;
> @@ -1262,12 +1265,6 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
>  }
>  
>  #ifdef CONFIG_FS_DAX_PMD
> -/*
> - * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
> - * more often than one might expect in the below functions.
> - */
> -#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
> -
>  static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
>  		loff_t pos, void **entryp)
>  {
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
