Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [103.22.144.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA4BE21A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 17:33:29 -0700 (PDT)
Date: Wed, 12 Apr 2017 10:33:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 4/9] powerpc/mm: Reshuffle vmemmap_free()
Message-ID: <20170412103327.3bfe4291@canb.auug.org.au>
In-Reply-To: <20170411174233.21902-5-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-5-oohall@gmail.com>
MIME-Version: 1.0
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Oliver,

On Wed, 12 Apr 2017 03:42:28 +1000 Oliver O'Halloran <oohall@gmail.com> wrote:
>
> diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
> index ec84b31c6c86..f8124edb6ffa 100644
> --- a/arch/powerpc/mm/init_64.c
> +++ b/arch/powerpc/mm/init_64.c
> @@ -234,12 +234,15 @@ static unsigned long vmemmap_list_free(unsigned long start)
>  void __ref vmemmap_free(unsigned long start, unsigned long end)
>  {
>  	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
> +	unsigned long page_order = get_order(page_size);
>  
>  	start = _ALIGN_DOWN(start, page_size);
>  
>  	pr_debug("vmemmap_free %lx...%lx\n", start, end);
>  
>  	for (; start < end; start += page_size) {
> +		struct page *page = pfn_to_page(addr >> PAGE_SHIFT);

The declaration of addr is below here and, even so, it would be
uninitialised ...

> +		unsigned int nr_pages;
>  		unsigned long addr;

-- 
Cheers,
Stephen Rothwell
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
