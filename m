Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out0-130.mail.aliyun.com (out0-130.mail.aliyun.com
 [140.205.0.130]) by ml01.01.org (Postfix) with ESMTP id DBA5381D33
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 21:18:16 -0700 (PDT)
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
 <1478039794-20253-5-git-send-email-jack@suse.cz>
In-Reply-To: <1478039794-20253-5-git-send-email-jack@suse.cz>
Subject: Re: [PATCH 02/21] mm: Use vmf->address instead of of
 vmf->virtual_address
Date: Wed, 02 Nov 2016 12:18:10 +0800
Message-ID: <06aa01d234c0$1f85e700$5e91b500$@alibaba-inc.com>
MIME-Version: 1.0
Content-Language: zh-cn
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Hillf Danton <hillf.zj@alibaba-inc.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Jan Kara' <jack@suse.cz>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, 'Andrew Morton' <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wednesday, November 02, 2016 6:36 AM Jan Kara wrote:
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8e8b76d11bb4..2a4ebe3c67c6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -297,8 +297,6 @@ struct vm_fault {
>  	gfp_t gfp_mask;			/* gfp mask to be used for allocations */
>  	pgoff_t pgoff;			/* Logical page offset based on vma */
>  	unsigned long address;		/* Faulting virtual address */
> -	void __user *virtual_address;	/* Faulting virtual address masked by
> -					 * PAGE_MASK */
>  	pmd_t *pmd;			/* Pointer to pmd entry matching
>  					 * the 'address'
>  					 */
We have a pmd field currently?

In  [PATCH 01/20] mm: Change type of vmf->virtual_address we see
[1] __user * gone,
[2] no field of address added
and doubt stray merge occurred.

btw, s:01/20:01/21: in subject line?

Hillf

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ef815b9cd426..a5636d646022 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -295,7 +295,7 @@ struct vm_fault {
>  	unsigned int flags;		/* FAULT_FLAG_xxx flags */
>  	gfp_t gfp_mask;			/* gfp mask to be used for allocations */
>  	pgoff_t pgoff;			/* Logical page offset based on vma */
> -	void __user *virtual_address;	/* Faulting virtual address */
> +	unsigned long virtual_address;	/* Faulting virtual address */
> 
>  	struct page *cow_page;		/* Handler may choose to COW */
>  	struct page *page;		/* ->fault handlers should return a


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
