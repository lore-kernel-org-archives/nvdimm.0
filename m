Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BED821A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 10:40:42 -0700 (PDT)
Date: Mon, 17 Oct 2016 11:40:42 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 09/20] mm: Factor out functionality to finish page faults
Message-ID: <20161017174042.GB6104@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-10-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474992504-20133-10-git-send-email-jack@suse.cz>
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

On Tue, Sep 27, 2016 at 06:08:13PM +0200, Jan Kara wrote:
> Introduce function finish_fault() as a helper function for finishing
> page faults. It is rather thin wrapper around alloc_set_pte() but since
> we'd want to call this from DAX code or filesystems, it is still useful
> to avoid some boilerplate code.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

> diff --git a/mm/memory.c b/mm/memory.c
> index 17db88a38e8a..f54cfad7fe04 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3029,6 +3029,36 @@ int alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
>  	return 0;
>  }
>  
> +
> +/**
> + * finish_fault - finish page fault once we have prepared the page to fault
> + *
> + * @vmf: structure describing the fault
> + *
> + * This function handles all that is needed to finish a page fault once the
> + * page to fault in is prepared. It handles locking of PTEs, inserts PTE for
> + * given page, adds reverse page mapping, handles memcg charges and LRU
> + * addition. The function returns 0 on success, VM_FAULT_ code in case of
> + * error.
> + *
> + * The function expects the page to be locked.
> + */
> +int finish_fault(struct vm_fault *vmf)
> +{
> +	struct page *page;
> +	int ret;
> +
> +	/* Did we COW the page? */
> +	if (vmf->flags & FAULT_FLAG_WRITE && !(vmf->vma->vm_flags & VM_SHARED))

Oh, sorry, I did have one bit of feedback.  Maybe added parens around the flag
check for readability:

	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vmf->vma->vm_flags & VM_SHARED))

Aside from that one nit:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
