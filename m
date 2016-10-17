Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 798F01A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 09:45:13 -0700 (PDT)
Date: Mon, 17 Oct 2016 10:45:12 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 07/20] mm: Add orig_pte field into vm_fault
Message-ID: <20161017164512.GA25175@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-8-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474992504-20133-8-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 27, 2016 at 06:08:11PM +0200, Jan Kara wrote:
> Add orig_pte field to vm_fault structure to allow ->page_mkwrite
> handlers to fully handle the fault. This also allows us to save some
> passing of extra arguments around.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f88b2d3810a7..66bc77f2d1d2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -890,11 +890,12 @@ static bool __collapse_huge_page_swapin(struct mm_struct *mm,
>  	vmf.pte = pte_offset_map(pmd, address);
>  	for (; vmf.address < address + HPAGE_PMD_NR*PAGE_SIZE;
>  			vmf.pte++, vmf.address += PAGE_SIZE) {
> -		pteval = *vmf.pte;
> +		vmf.orig_pte = *vmf.pte;
> +		pteval = vmf.orig_pte;
>  		if (!is_swap_pte(pteval))
>  			continue;

'pteval' is now only used once.  It's probably cleaner to just remove it and
use vmf.orig_pte for the is_swap_pte() check.

> @@ -3484,8 +3484,7 @@ static int handle_pte_fault(struct vm_fault *vmf)
>  		 * So now it's safe to run pte_offset_map().
>  		 */
>  		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
> -
> -		entry = *vmf->pte;
> +		vmf->orig_pte = *vmf->pte;
>  
>  		/*
>  		 * some architectures can have larger ptes than wordsize,
> @@ -3496,6 +3495,7 @@ static int handle_pte_fault(struct vm_fault *vmf)
>  		 * ptl lock held. So here a barrier will do.
>  		 */
>  		barrier();
> +		entry = vmf->orig_pte;

This set of 'entry' is now on the other side of the barrier().  I'll admit
that I don't fully grok the need for the barrier. Does it apply to only the
setting of vmf->pte and vmf->orig_pte, or does 'entry' also matter because it
too is of type pte_t, and thus could be bigger than the architecture's word
size?

My guess is that 'entry' matters, too, and should remain before the barrier()
call.  If not, can you help me understand why?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
