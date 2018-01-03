Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9F6E2034B421
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jan 2018 07:22:40 -0800 (PST)
Date: Wed, 3 Jan 2018 16:27:41 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 05/18] dax: stop using VM_MIXEDMAP for dax
Message-ID: <20180103152741.GI4911@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407698763.38751.8605535379424429182.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407698763.38751.8605535379424429182.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, linux-nvdimm@lists.01.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat 23-12-17 16:56:27, Dan Williams wrote:
> VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
> the memory page it is dealing with is not typical memory from the linear
> map. The get_user_pages_fast() path, since it does not resolve the vma,
> is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
> use that as a VM_MIXEDMAP replacement in some locations. In the cases
> where there is no pte to consult we fallback to using vma_is_dax() to
> detect the VM_MIXEDMAP special case.
> 
> Now that we have explicit driver pfn_t-flag opt-in/opt-out for
> get_user_pages() support for DAX we can stop setting VM_MIXEDMAP.  This
> also means we no longer need to worry about safely manipulating vm_flags
> in a future where we support dynamically changing the dax mode of a
> file.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

...

> diff --git a/mm/madvise.c b/mm/madvise.c
> index 751e97aa2210..eff3ec1e2574 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -96,7 +96,7 @@ static long madvise_behavior(struct vm_area_struct *vma,
>  		new_flags |= VM_DONTDUMP;
>  		break;
>  	case MADV_DODUMP:
> -		if (new_flags & VM_SPECIAL) {
> +		if (vma_is_dax(vma) || (new_flags & VM_SPECIAL)) {
>  			error = -EINVAL;
>  			goto out;
>  		}

Why do you add the check here? I assume it's because VM_SPECIAL contains
VM_MIXEDMAP... But then why don't we allow dumping of DAX VMAs? Possibly
just keep the addition of the check in this patch and then add a separate
patch removing it with proper justification.

> diff --git a/mm/memory.c b/mm/memory.c
> index 48a13473b401..1efb005e8fab 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
...
> @@ -1228,7 +1232,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	 * efficient than faulting.
>  	 */
>  	if (!(vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP)) &&
> -			!vma->anon_vma)
> +			!vma->anon_vma && !vma_is_dax(vma))
>  		return 0;
>  
>  	if (is_vm_hugetlb_page(vma))

Ditto here... Page fault will fill DAX vmas just fine so I don't see a
reason why fork would need to copy page tables by hand.

Also I suppose comments about VM_MIXEDMAP in do_wp_page() and
wp_pfn_shared() would use some updating.

I'm not sure but I think VM_SPECIAL checks in mm/hmm.c needs treatment as
well?

If the replacement was really strict you should also add the check to
vma_merge() AFAICT. But as in some other cases, we can enable vma merging
for DAX vmas just fine so as the end result vma_merge() should IMO treat
DAX vmas. But it would be good to have this change recorded in a changelog
of a separate patch removing this additional check.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
