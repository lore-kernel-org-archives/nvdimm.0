Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB01521A143E3
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 03:55:21 -0700 (PDT)
Date: Wed, 14 Jun 2017 12:56:35 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 06/14] filesystem-dax: convert to dax_flush()
Message-ID: <20170614105635.GF21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703985873.20620.14408850278717601623.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703985873.20620.14408850278717601623.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri 09-06-17 13:24:18, Dan Williams wrote:
> Filesystem-DAX flushes caches whenever it writes to the address returned
> through dax_direct_access() and when writing back dirty radix entries.
> That flushing is only required in the pmem case, so the dax_flush()
> helper skips cache management work when the underlying driver does not
> specify a flush method.
> 
> We still do all the dirty tracking since the radix entry will already be
> there for locking purposes. However, the work to clean the entry will be
> a nop for some dax drivers.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index b459948de427..0933fc460ada 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -784,7 +784,7 @@ static int dax_writeback_one(struct block_device *bdev,
>  	}
>  
>  	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
> -	wb_cache_pmem(kaddr, size);
> +	dax_flush(dax_dev, pgoff, kaddr, size);
>  	/*
>  	 * After we have flushed the cache, we can clear the dirty tag. There
>  	 * cannot be new dirty data in the pfn after the flush has completed as
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
