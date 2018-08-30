Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3C3421107857
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 14:43:56 -0700 (PDT)
Subject: Re: [PATCH] dax: Fix use of zero page
References: <20180830162032.GA25345@bombadil.infradead.org>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <96487ace-f807-5df5-49e1-a888ad26af3e@intel.com>
Date: Thu, 30 Aug 2018 14:43:55 -0700
MIME-Version: 1.0
In-Reply-To: <20180830162032.GA25345@bombadil.infradead.org>
Content-Language: en-US
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
To: Matthew Wilcox <willy@infradead.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 08/30/2018 09:20 AM, Matthew Wilcox wrote:
> 
> This patch got caught in the crossfire and didn't make it into 4.18
> as planned.  Can it make 4.19 please?
> 
> ---- >8 ----
> 
> Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
> works on MIPS and s390.
> 
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Applied

> ---
>  fs/dax.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 467601a134bc..c7917b46a75b 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1093,21 +1093,12 @@ static vm_fault_t dax_load_hole(struct address_space *mapping, void *entry,
>  {
>  	struct inode *inode = mapping->host;
>  	unsigned long vaddr = vmf->address;
> -	vm_fault_t ret = VM_FAULT_NOPAGE;
> -	struct page *zero_page;
> -	pfn_t pfn;
> -
> -	zero_page = ZERO_PAGE(0);
> -	if (unlikely(!zero_page)) {
> -		ret = VM_FAULT_OOM;
> -		goto out;
> -	}
> +	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
> +	vm_fault_t ret;
>  
> -	pfn = page_to_pfn_t(zero_page);
>  	dax_insert_mapping_entry(mapping, vmf, entry, pfn, RADIX_DAX_ZERO_PAGE,
>  			false);
>  	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
> -out:
>  	trace_dax_load_hole(inode, vmf, ret);
>  	return ret;
>  }
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
