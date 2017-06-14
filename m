Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B67721A143C3
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 03:47:59 -0700 (PDT)
Date: Wed, 14 Jun 2017 12:49:12 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 09/14] x86, libnvdimm, pmem: move
 arch_invalidate_pmem() to libnvdimm
Message-ID: <20170614104912.GC21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703987543.20620.15705330305343743783.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703987543.20620.15705330305343743783.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri 09-06-17 13:24:35, Dan Williams wrote:
> Kill this globally defined wrapper and move to libnvdimm so that we can
> ultimately remove include/linux/pmem.h.
> 
> Cc: <x86@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/nvdimm/claim.c |    3 ++-
>  drivers/nvdimm/pmem.c  |    2 +-
>  drivers/nvdimm/pmem.h  |    3 +++
>  include/linux/pmem.h   |   19 -------------------
>  4 files changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index b8b9c8ca7862..d2e16c0401df 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -14,6 +14,7 @@
>  #include <linux/sizes.h>
>  #include <linux/pmem.h>
>  #include "nd-core.h"
> +#include "pmem.h"
>  #include "pfn.h"
>  #include "btt.h"
>  #include "nd.h"
> @@ -272,7 +273,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  				cleared /= 512;
>  				badblocks_clear(&nsio->bb, sector, cleared);
>  			}
> -			invalidate_pmem(nsio->addr + offset, size);
> +			arch_invalidate_pmem(nsio->addr + offset, size);
>  		} else
>  			rc = -EIO;
>  	}
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 3b87702d46bb..68737bc68a07 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -71,7 +71,7 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
>  		badblocks_clear(&pmem->bb, sector, cleared);
>  	}
>  
> -	invalidate_pmem(pmem->virt_addr + offset, len);
> +	arch_invalidate_pmem(pmem->virt_addr + offset, len);
>  
>  	return rc;
>  }
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index 9137ec80b85f..d579c7095a45 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -10,6 +10,9 @@
>  static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  {
>  }
> +static inline void arch_invalidate_pmem(void *addr, size_t size)
> +{
> +}
>  #endif
>  
>  /* this definition is in it's own header for tools/testing/nvdimm to consume */
> diff --git a/include/linux/pmem.h b/include/linux/pmem.h
> index 33ae761f010a..559c00848583 100644
> --- a/include/linux/pmem.h
> +++ b/include/linux/pmem.h
> @@ -30,11 +30,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
>  {
>  	BUG();
>  }
> -
> -static inline void arch_invalidate_pmem(void *addr, size_t size)
> -{
> -	BUG();
> -}
>  #endif
>  
>  static inline bool arch_has_pmem_api(void)
> @@ -61,18 +56,4 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
>  	else
>  		memcpy(dst, src, n);
>  }
> -
> -/**
> - * invalidate_pmem - flush a pmem range from the cache hierarchy
> - * @addr:	virtual start address
> - * @size:	bytes to invalidate (internally aligned to cache line size)
> - *
> - * For platforms that support clearing poison this flushes any poisoned
> - * ranges out of the cache
> - */
> -static inline void invalidate_pmem(void *addr, size_t size)
> -{
> -	if (arch_has_pmem_api())
> -		arch_invalidate_pmem(addr, size);
> -}
>  #endif /* __PMEM_H__ */
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
