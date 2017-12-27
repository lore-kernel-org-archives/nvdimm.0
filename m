Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18965221ED76C
 for <linux-nvdimm@lists.01.org>; Tue, 26 Dec 2017 16:12:11 -0800 (PST)
Date: Tue, 26 Dec 2017 17:17:05 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 07/18] dax: store pfns in the radix
Message-ID: <20171227001705.GA4802@linux.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407699792.38751.2859846645388380112.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407699792.38751.2859846645388380112.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:56:38PM -0800, Dan Williams wrote:
> In preparation for examining the busy state of dax pages in the truncate
> path, switch from sectors to pfns in the radix.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/super.c |   15 ++++++++--
>  fs/dax.c            |   75 ++++++++++++++++++---------------------------------
>  2 files changed, 39 insertions(+), 51 deletions(-)
<>
> @@ -688,7 +685,7 @@ static int dax_writeback_one(struct block_device *bdev,
>  	 * compare sectors as we must not bail out due to difference in lockbit
>  	 * or entry type.
>  	 */

Can you please also fix the comment above this test so it talks about pfns
instead of sectors?

> -	if (dax_radix_sector(entry2) != dax_radix_sector(entry))
> +	if (dax_radix_pfn(entry2) != dax_radix_pfn(entry))
>  		goto put_unlocked;
>  	if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
>  				dax_is_zero_entry(entry))) {
> @@ -718,29 +715,11 @@ static int dax_writeback_one(struct block_device *bdev,
>  	 * 'entry'.  This allows us to flush for PMD_SIZE and not have to
>  	 * worry about partial PMD writebacks.
>  	 */

Ditto for this comment ^^^

> -	sector = dax_radix_sector(entry);
> +	pfn = dax_radix_pfn(entry);
>  	size = PAGE_SIZE << dax_radix_order(entry);
>  
> -	id = dax_read_lock();
> -	ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
> -	if (ret)
> -		goto dax_unlock;
> -
> -	/*
> -	 * dax_direct_access() may sleep, so cannot hold tree_lock over
> -	 * its invocation.
> -	 */
> -	ret = dax_direct_access(dax_dev, pgoff, size / PAGE_SIZE, &kaddr, &pfn);
> -	if (ret < 0)
> -		goto dax_unlock;
> -
> -	if (WARN_ON_ONCE(ret < size / PAGE_SIZE)) {
> -		ret = -EIO;
> -		goto dax_unlock;
> -	}
> -
> -	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
> -	dax_flush(dax_dev, kaddr, size);
> +	dax_mapping_entry_mkclean(mapping, index, pfn);
> +	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), size);
>  	/*
>  	 * After we have flushed the cache, we can clear the dirty tag. There
>  	 * cannot be new dirty data in the pfn after the flush has completed as
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
