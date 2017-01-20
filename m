Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3813581E9C
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jan 2017 02:27:27 -0800 (PST)
Date: Fri, 20 Jan 2017 11:27:17 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/13] x86, dax: replace clear_pmem() with open coded
 memset + dax_ops->flush
Message-ID: <20170120102717.GI14115@quack2.suse.cz>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148488423988.37913.16814081637297710444.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148488423988.37913.16814081637297710444.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 19-01-17 19:50:39, Dan Williams wrote:
> The clear_pmem() helper simply combines a memset() plus a cache flush.
> Now that the flush routine is optionally provided by the dax device
> driver we can avoid unnecessary cache management on dax devices fronting
> volatile memory.
> 
> With clear_pmem() gone we can follow on with a patch to make pmem cache
> management completely defined within the pmem driver.
...
> diff --git a/fs/dax.c b/fs/dax.c
> index 160024e403f6..8883ce4d391e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -986,6 +986,7 @@ static bool dax_range_is_aligned(struct block_device *bdev,
>  int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
>  		unsigned int offset, unsigned int length)
>  {
> +	const struct dax_operations *dax_ops = to_dax_ops(bdev);
>  	struct blk_dax_ctl dax = {
>  		.sector		= sector,
>  		.size		= PAGE_SIZE,
> @@ -999,7 +1000,9 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
>  	} else {
>  		if (dax_map_atomic(bdev, &dax) < 0)
>  			return PTR_ERR(dax.addr);
> -		clear_pmem(dax.addr + offset, length);
> +		memset(dax.addr + offset, 0, length);
> +		if (dax_ops->flush)
> +			dax_ops->flush(dax.addr + offset, length);
>  		dax_unmap_atomic(bdev, &dax);
>  	}
>  	return 0;

Shouldn't we rather have some callback in dax_ops for clearing memory?
If we had all accesses to persistent memory inside DAX code wrapped inside
appropriate device wrappers that can report errors, we can have proper
error handling for the case we hit MCE, can't we?

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
