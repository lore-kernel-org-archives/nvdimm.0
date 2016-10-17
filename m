Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E9BFE1A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 12:40:41 -0700 (PDT)
Date: Mon, 17 Oct 2016 13:40:41 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 11/20] mm: Remove unnecessary vma->vm_ops check
Message-ID: <20161017194041.GB21002@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-12-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474992504-20133-12-git-send-email-jack@suse.cz>
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

On Tue, Sep 27, 2016 at 06:08:15PM +0200, Jan Kara wrote:
> We don't check whether vma->vm_ops is NULL in do_shared_fault() so
> there's hardly any point in checking it in wp_page_shared() which gets
> called only for shared file mappings as well.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index a4522e8999b2..63d9c1a54caf 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2301,7 +2301,7 @@ static int wp_page_shared(struct vm_fault *vmf, struct page *old_page)
>  
>  	get_page(old_page);
>  
> -	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
> +	if (vma->vm_ops->page_mkwrite) {
>  		int tmp;
>  
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
> -- 
> 2.6.6

Does this apply equally to the check in wp_pfn_shared()?  Both
wp_page_shared() and wp_pfn_shared() are called for shared file mappings via
do_wp_page().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
