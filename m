Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 86DD321107846
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 13:12:29 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] mm: fix BUG_ON() in vmf_insert_pfn_pud() from VM_MIXEDMAP
 removal
References: <153565957352.35524.1005746906902065126.stgit@djiang5-desk3.ch.intel.com>
Date: Thu, 30 Aug 2018 16:12:16 -0400
In-Reply-To: <153565957352.35524.1005746906902065126.stgit@djiang5-desk3.ch.intel.com>
 (Dave Jiang's message of "Thu, 30 Aug 2018 13:06:13 -0700")
Message-ID: <x49va7r8vhb.fsf@segfault.boston.devel.redhat.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-nvdimm@lists.01.org, jack@suse.com
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> writes:

> It looks like I missed the PUD path when doing VM_MIXEDMAP removal.
> This can be triggered by:
> 1. Boot with memmap=4G!8G
> 2. build ndctl with destructive flag on
> 3. make TESTS=device-dax check
>
> [  +0.000675] kernel BUG at mm/huge_memory.c:824!
>
> Applying the same change that was applied to vmf_insert_pfn_pmd() in the
> original patch.
>
> Fixes: e1fb4a08649 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
>
> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>


> ---
>  mm/huge_memory.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c3bc7e9c9a2a..533f9b00147d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -821,11 +821,11 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>  	 * but we need to be consistent with PTEs and architectures that
>  	 * can't support a 'special' bit.
>  	 */
> -	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
> +	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
> +			!pfn_t_devmap(pfn));
>  	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
>  						(VM_PFNMAP|VM_MIXEDMAP));
>  	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
> -	BUG_ON(!pfn_t_devmap(pfn));
>  
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
>  		return VM_FAULT_SIGBUS;
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
