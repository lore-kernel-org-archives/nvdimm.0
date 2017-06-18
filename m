Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2154221A07AA1
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 01:39:18 -0700 (PDT)
Date: Sun, 18 Jun 2017 10:40:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 08/14] x86, dax, libnvdimm: move wb_cache_pmem() to
 libnvdimm
Message-ID: <20170618084036.GC26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
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

> +void clean_cache_range(void *addr, size_t size);
>  
>  static inline int
>  __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
> diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> index f42d2fd86ca3..baa80ff29da8 100644
> --- a/arch/x86/lib/usercopy_64.c
> +++ b/arch/x86/lib/usercopy_64.c
> @@ -85,7 +85,7 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
>   * instruction. Note that @size is internally rounded up to be cache
>   * line size aligned.
>   */
> -static void clean_cache_range(void *addr, size_t size)
> +void clean_cache_range(void *addr, size_t size)

Can you keep clean_cache_range private please?  Just add
arch_wb_cache_pmem to usercopy_64.c just behind it so that the
compiler can tail-call and export that instead.

> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -4,6 +4,13 @@
>  #include <linux/types.h>
>  #include <linux/pfn_t.h>
>  #include <linux/fs.h>
> +#include <asm/pmem.h>
> +
> +#ifndef CONFIG_ARCH_HAS_PMEM_API
> +static inline void arch_wb_cache_pmem(void *addr, size_t size)
> +{
> +}
> +#endif

And our normal Linux style would be to have this linux linux/pmem.h,
which should always be included for the asm version.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
