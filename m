Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EADDD21959700
 for <linux-nvdimm@lists.01.org>; Mon, 22 May 2017 07:45:01 -0700 (PDT)
Date: Mon, 22 May 2017 16:44:57 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: Fix race between colliding PMD & PTE entries
Message-ID: <20170522144457.GE25118@quack2.suse.cz>
References: <20170517171639.14501-1-ross.zwisler@linux.intel.com>
 <20170517171639.14501-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170517171639.14501-2-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 17-05-17 11:16:39, Ross Zwisler wrote:
> We currently have two related PMD vs PTE races in the DAX code.  These can
> both be easily triggered by having two threads reading and writing
> simultaneously to the same private mapping, with the key being that private
> mapping reads can be handled with PMDs but private mapping writes are
> always handled with PTEs so that we can COW.
> 
> Here is the first race:
> 
> CPU 0					CPU 1
> 
> (private mapping write)
> __handle_mm_fault()
>   create_huge_pmd() - FALLBACK
>   handle_pte_fault()
>     passes check for pmd_devmap()
> 
> 					(private mapping read)
> 					__handle_mm_fault()
> 					  create_huge_pmd()
> 					    dax_iomap_pmd_fault() inserts PMD
> 
>     dax_iomap_pte_fault() does a PTE fault, but we already have a DAX PMD
>     			  installed in our page tables at this spot.
> 
> Here's the second race:
> 
> CPU 0					CPU 1
> 
> (private mapping write)
> __handle_mm_fault()
>   create_huge_pmd() - FALLBACK
> 					(private mapping read)
> 					__handle_mm_fault()
> 					  passes check for pmd_none()
> 					  create_huge_pmd()
> 
>   handle_pte_fault()
>     dax_iomap_pte_fault() inserts PTE
> 					    dax_iomap_pmd_fault() inserts PMD,
> 					       but we already have a PTE at
> 					       this spot.
> 
> The core of the issue is that while there is isolation between faults to
> the same range in the DAX fault handlers via our DAX entry locking, there
> is no isolation between faults in the code in mm/memory.c.  This means for
> instance that this code in __handle_mm_fault() can run:
> 
> 	if (pmd_none(*vmf.pmd) && transparent_hugepage_enabled(vma)) {
> 		ret = create_huge_pmd(&vmf);
> 
> But by the time we actually get to run the fault handler called by
> create_huge_pmd(), the PMD is no longer pmd_none() because a racing PTE
> fault has installed a normal PMD here as a parent.  This is the cause of
> the 2nd race.  The first race is similar - there is the following check in
> handle_pte_fault():
> 
> 	} else {
> 		/* See comment in pte_alloc_one_map() */
> 		if (pmd_devmap(*vmf->pmd) || pmd_trans_unstable(vmf->pmd))
> 			return 0;
> 
> So if a pmd_devmap() PMD (a DAX PMD) has been installed at vmf->pmd, we
> will bail and retry the fault.  This is correct, but there is nothing
> preventing the PMD from being installed after this check but before we
> actually get to the DAX PTE fault handlers.
> 
> In my testing these races result in the following types of errors:
> 
>  BUG: Bad rss-counter state mm:ffff8800a817d280 idx:1 val:1
>  BUG: non-zero nr_ptes on freeing mm: 15
> 
> Fix this issue by having the DAX fault handlers verify that it is safe to
> continue their fault after they have taken an entry lock to block other
> racing faults.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Pawel Lebioda <pawel.lebioda@intel.com>
> Cc: stable@vger.kernel.org
> 
> ---
> 
> I've written a new xfstest for this race, which I will send in response to
> this patch series.  This series has also survived an xfstest run without
> any new issues.
> 
> ---
>  fs/dax.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index c22eaf1..3cc02d1 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1155,6 +1155,15 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
>  	}
>  
>  	/*
> +	 * It is possible, particularly with mixed reads & writes to private
> +	 * mappings, that we have raced with a PMD fault that overlaps with
> +	 * the PTE we need to set up.  Now that we have a locked mapping entry
> +	 * we can safely unmap the huge PMD so that we can install our PTE in
> +	 * our page tables.
> +	 */
> +	split_huge_pmd(vmf->vma, vmf->pmd, vmf->address);
> +

Can we just check the PMD and if is isn't as we want it, bail out and retry
the fault? IMHO it will be more obvious that way (and also more in line
like these races are handled for the classical THP). Otherwise the patch
looks good to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
