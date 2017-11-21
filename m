Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A22221B00DC1
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 15:07:00 -0800 (PST)
Date: Tue, 21 Nov 2017 15:11:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/4] mm: introduce get_user_pages_longterm
Message-Id: <20171121151114.de95a3eb730ce602e52e891d@linux-foundation.org>
In-Reply-To: <151068939435.7446.13560129395419350737.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151068938905.7446.12333914805308312313.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151068939435.7446.13560129395419350737.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
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
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 14 Nov 2017 11:56:34 -0800 Dan Williams <dan.j.williams@intel.com> wrote:

> Until there is a solution to the dma-to-dax vs truncate problem it is
> not safe to allow long standing memory registrations against
> filesytem-dax vmas. Device-dax vmas do not have this problem and are
> explicitly allowed.
> 
> This is temporary until a "memory registration with layout-lease"
> mechanism can be implemented for the affected sub-systems (RDMA and
> V4L2).
> 
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1095,6 +1095,70 @@ long get_user_pages(unsigned long start, unsigned long nr_pages,
>  }
>  EXPORT_SYMBOL(get_user_pages);
>  
> +#ifdef CONFIG_FS_DAX
> +/*
> + * This is the same as get_user_pages() in that it assumes we are
> + * operating on the current task's mm, but it goes further to validate
> + * that the vmas associated with the address range are suitable for
> + * longterm elevated page reference counts. For example, filesystem-dax
> + * mappings are subject to the lifetime enforced by the filesystem and
> + * we need guarantees that longterm users like RDMA and V4L2 only
> + * establish mappings that have a kernel enforced revocation mechanism.
> + *
> + * "longterm" == userspace controlled elevated page count lifetime.
> + * Contrast this to iov_iter_get_pages() usages which are transient.
> + */
> +long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
> +		unsigned int gup_flags, struct page **pages,
> +		struct vm_area_struct **vmas_arg)
> +{
> +	struct vm_area_struct **vmas = vmas_arg;
> +	struct vm_area_struct *vma_prev = NULL;
> +	long rc, i;
> +
> +	if (!pages)
> +		return -EINVAL;
> +
> +	if (!vmas) {
> +		vmas = kzalloc(sizeof(struct vm_area_struct *) * nr_pages,
> +				GFP_KERNEL);
> +		if (!vmas)
> +			return -ENOMEM;
> +	}
>
> ...
>

I'll do this:

--- a/mm/gup.c~mm-introduce-get_user_pages_longterm-fix
+++ a/mm/gup.c
@@ -1120,8 +1120,8 @@ long get_user_pages_longterm(unsigned lo
 		return -EINVAL;
 
 	if (!vmas) {
-		vmas = kzalloc(sizeof(struct vm_area_struct *) * nr_pages,
-				GFP_KERNEL);
+		vmas = kcalloc(nr_pages, sizeof(struct vm_area_struct *),
+			       GFP_KERNEL);
 		if (!vmas)
 			return -ENOMEM;
 	}
_

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
