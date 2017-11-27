Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74D3A21A1099D
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 08:10:52 -0800 (PST)
Date: Mon, 27 Nov 2017 17:15:11 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/4] mm: fail get_vaddr_frames() for filesystem-dax
 mappings
Message-ID: <20171127161511.GE5977@quack2.suse.cz>
References: <151068938905.7446.12333914805308312313.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151068939985.7446.15684639617389154187.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151068939985.7446.15684639617389154187.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Joonyoung Shim <jy0922.shim@samsung.com>, linux-nvdimm@lists.01.org, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Inki Dae <inki.dae@samsung.com>, linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>, Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 14-11-17 11:56:39, Dan Williams wrote:
> Until there is a solution to the dma-to-dax vs truncate problem it is
> not safe to allow V4L2, Exynos, and other frame vector users to create
> long standing / irrevocable memory registrations against filesytem-dax
> vmas.
> 
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: Jan Kara <jack@suse.cz>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: <stable@vger.kernel.org>
> Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Makes sense. I'd just note that in principle get_vaddr_frames() is no more
long-term than get_user_pages(). It is just so that all the users of
get_vaddr_frames() currently want a long-term reference. Maybe could you
add here also a comment that the vma_is_fsdax() check is there because all
users of this function want a long term page reference? With that you can
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/frame_vector.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/frame_vector.c b/mm/frame_vector.c
> index 72ebec18629c..d2fdbeaadc8b 100644
> --- a/mm/frame_vector.c
> +++ b/mm/frame_vector.c
> @@ -52,6 +52,10 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
>  		ret = -EFAULT;
>  		goto out;
>  	}
> +
> +	if (vma_is_fsdax(vma))
> +		return -EOPNOTSUPP;
> +
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
>  		vec->got_ref = true;
>  		vec->is_pfns = false;
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
