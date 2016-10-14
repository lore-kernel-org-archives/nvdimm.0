Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 898ED1A1E9E
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 11:42:52 -0700 (PDT)
Date: Fri, 14 Oct 2016 12:42:51 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 03/20] mm: Use pgoff in struct vm_fault instead of
 passing it separately
Message-ID: <20161014184251.GB27575@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474992504-20133-4-git-send-email-jack@suse.cz>
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

On Tue, Sep 27, 2016 at 06:08:07PM +0200, Jan Kara wrote:
> struct vm_fault has already pgoff entry. Use it instead of passing pgoff
> as a separate argument and then assigning it later.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mm/memory.c | 35 ++++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 447a1ef4a9e3..4c2ec9a9d8af 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2275,7 +2275,7 @@ static int wp_pfn_shared(struct vm_fault *vmf, pte_t orig_pte)
>  	if (vma->vm_ops && vma->vm_ops->pfn_mkwrite) {
>  		struct vm_fault vmf2 = {
>  			.page = NULL,
> -			.pgoff = linear_page_index(vma, vmf->address),
> +			.pgoff = vmf->pgoff,

I think there is one path where vmf->pgoff isn't set here.  Here's the path:

__collapse_huge_page_swapin()
  do_swap_page()
    do_wp_page()
      wp_pfn_shared()

We then use an uninitialized vmf->pgoff to set up vmf2->pgoff, which we pass
to vm_ops->pfn_mkwrite().

I think all we need to do to fix this is initialize .pgoff in
__collapse_huge_page_swapin().  With this one change:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
