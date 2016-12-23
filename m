Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 51344820AD
 for <linux-nvdimm@lists.01.org>; Fri, 23 Dec 2016 05:45:02 -0800 (PST)
Date: Fri, 23 Dec 2016 14:44:57 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/4] dax: add stub for pmdp_huge_clear_flush()
Message-ID: <20161223134457.GG22679@quack2.suse.cz>
References: <1482441536-14550-1-git-send-email-ross.zwisler@linux.intel.com>
 <1482441536-14550-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1482441536-14550-3-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: linux-arch@vger.kernel.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 22-12-16 14:18:54, Ross Zwisler wrote:
> Add a pmdp_huge_clear_flush() stub for configs that don't define
> CONFIG_TRANSPARENT_HUGEPAGE.
> 
> We use a WARN_ON_ONCE() instead of a BUILD_BUG() because in the DAX code at
> least we do want this compile successfully even for configs without
> CONFIG_TRANSPARENT_HUGEPAGE.  It'll be a runtime decision whether we call
> this code gets called, based on whether we find DAX PMD entries in our
> tree.  We shouldn't ever find such PMD entries for
> !CONFIG_TRANSPARENT_HUGEPAGE configs, so this function should never be
> called.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/asm-generic/pgtable.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 18af2bc..65e9536 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -178,9 +178,19 @@ extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
>  #endif
>  
>  #ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  extern pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
>  			      unsigned long address,
>  			      pmd_t *pmdp);
> +#else
> +static inline pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
> +			      unsigned long address,
> +			      pmd_t *pmdp)
> +{
> +	WARN_ON_ONCE(1);
> +	return *pmdp;
> +}
> +#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  #endif
>  
>  #ifndef __HAVE_ARCH_PTEP_SET_WRPROTECT
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
