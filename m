Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59C2481EA3
 for <linux-nvdimm@lists.01.org>; Tue, 15 Nov 2016 14:40:22 -0800 (PST)
Received: by mail-wm0-x244.google.com with SMTP id u144so4913617wmu.0
 for <linux-nvdimm@lists.01.org>; Tue, 15 Nov 2016 14:40:27 -0800 (PST)
Date: Wed, 16 Nov 2016 01:40:23 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 13/21] mm: Pass vm_fault structure into do_page_mkwrite()
Message-ID: <20161115224023.GM23021@node>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-14-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1478233517-3571-14-git-send-email-jack@suse.cz>
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
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 04, 2016 at 05:25:09AM +0100, Jan Kara wrote:
> We will need more information in the ->page_mkwrite() helper for DAX to
> be able to fully finish faults there. Pass vm_fault structure to
> do_page_mkwrite() and use it there so that information propagates
> properly from upper layers.
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mm/memory.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4da66c984c2c..c89f99c270bc 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2038,20 +2038,14 @@ static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
>   *
>   * We do this without the lock held, so that it can sleep if it needs to.
>   */
> -static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
> -	       unsigned long address)
> +static int do_page_mkwrite(struct vm_fault *vmf)
>  {
> -	struct vm_fault vmf;
>  	int ret;
> +	struct page *page = vmf->page;
>  
> -	vmf.address = address;
> -	vmf.pgoff = page->index;
> -	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
> -	vmf.gfp_mask = __get_fault_gfp_mask(vma);
> -	vmf.page = page;
> -	vmf.cow_page = NULL;
> +	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;

This can be destructive: we loose rest of the flags here. It's probably
okay in current state of the code, but may be should restore them before
return from do_page_mkwrite()?

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
