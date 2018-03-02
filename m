Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5871821F6A6FD
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 14:33:39 -0800 (PST)
Date: Fri, 2 Mar 2018 14:39:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2/3] mm, hugetlbfs: introduce ->pagesize() to
 vm_operations_struct
Message-Id: <20180302143947.ed00df85530df46ec98dbd3e@linux-foundation.org>
In-Reply-To: <151996254734.27922.15813097401404359642.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151996253609.27922.9983044853291257359.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151996254734.27922.15813097401404359642.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 01 Mar 2018 19:49:07 -0800 Dan Williams <dan.j.williams@intel.com> wrote:

> When device-dax is operating in huge-page mode we want it to behave like
> hugetlbfs and report the MMU page mapping size that is being enforced by
> the vma. Similar to commit 31383c6865a5 "mm, hugetlbfs: introduce
> ->split() to vm_operations_struct" it would be messy to teach
> vma_mmu_pagesize() about device-dax page mapping sizes in the same
> (hstate) way that hugetlbfs communicates this attribute.  Instead, these
> patches introduce a new ->pagesize() vm operation.
> 
> ...
>
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -383,6 +383,7 @@ struct vm_operations_struct {
>  	int (*huge_fault)(struct vm_fault *vmf, enum page_entry_size pe_size);
>  	void (*map_pages)(struct vm_fault *vmf,
>  			pgoff_t start_pgoff, pgoff_t end_pgoff);
> +	unsigned long (*pagesize)(struct vm_area_struct * area);

fwiw, vm_operations_struct is documented in
Documentation/filesystems/Locking.  Some bitrotting has occurred :(

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
