Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FAB321A143E3
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 03:56:17 -0700 (PDT)
Date: Wed, 14 Jun 2017 12:57:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 04/14] dax, pmem: introduce an optional 'flush'
 dax_operation
Message-ID: <20170614105731.GG21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703984722.20620.1577767383686219477.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703984722.20620.1577767383686219477.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri 09-06-17 13:24:07, Dan Williams wrote:
> Filesystem-DAX flushes caches whenever it writes to the address returned
> through dax_direct_access() and when writing back dirty radix entries.
> That flushing is only required in the pmem case, so add a dax operation
> to allow pmem to take this extra action, but skip it for other dax
> capable devices that do not provide a flush routine.
> 
> An example for this differentiation might be a volatile ram disk where
> there is no expectation of persistence. In fact the pmem driver itself might
> front such an address range specified by the NFIT. So, this "no flush"
> property might be something passed down by the bus / libnvdimm.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/nvdimm/pmem.c |    7 +++++++
>  include/linux/dax.h   |    2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 2f3aefe565c6..823b07774244 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -242,9 +242,16 @@ static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  	return copy_from_iter_flushcache(addr, bytes, i);
>  }
>  
> +static void pmem_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff,
> +		void *addr, size_t size)
> +{
> +	wb_cache_pmem(addr, size);
> +}
> +
>  static const struct dax_operations pmem_dax_ops = {
>  	.direct_access = pmem_dax_direct_access,
>  	.copy_from_iter = pmem_copy_from_iter,
> +	.flush = pmem_dax_flush,
>  };
>  
>  static void pmem_release_queue(void *q)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 28e398f8c59e..407dd3ff6e54 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -19,6 +19,8 @@ struct dax_operations {
>  	/* copy_from_iter: dax-driver override for default copy_from_iter */
>  	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
>  			struct iov_iter *);
> +	/* flush: optional driver-specific cache management after writes */
> +	void (*flush)(struct dax_device *, pgoff_t, void *, size_t);
>  };
>  
>  #if IS_ENABLED(CONFIG_DAX)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
