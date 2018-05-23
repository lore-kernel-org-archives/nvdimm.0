Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13C75207E36D4
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 02:03:13 -0700 (PDT)
Date: Wed, 23 May 2018 11:03:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/11] device-dax: enable page_mapping()
Message-ID: <20180523090311.ozyfigjbhy4npkkl@quack2.suse.cz>
References: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152699998750.24093.5270058390086110946.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152699998750.24093.5270058390086110946.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, tony.luck@intel.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 22-05-18 07:39:47, Dan Williams wrote:
> In support of enabling memory_failure() handling for device-dax
> mappings, set the ->mapping association of pages backing device-dax
> mappings. The rmap implementation requires page_mapping() to return the
> address_space hosting the vmas that map the page.
> 
> The ->mapping pointer is never cleared. There is no possibility for the
> page to become associated with another address_space while the device is
> enabled. When the device is disabled the 'struct page' array for the
> device is destroyed / later reinitialized to zero.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
...
> @@ -402,17 +401,33 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>  	id = dax_read_lock();
>  	switch (pe_size) {
>  	case PE_SIZE_PTE:
> -		rc = __dev_dax_pte_fault(dev_dax, vmf);
> +		fault_size = PAGE_SIZE;
> +		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
>  		break;
>  	case PE_SIZE_PMD:
> -		rc = __dev_dax_pmd_fault(dev_dax, vmf);
> +		fault_size = PMD_SIZE;
> +		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
>  		break;
>  	case PE_SIZE_PUD:
> -		rc = __dev_dax_pud_fault(dev_dax, vmf);
> +		fault_size = PUD_SIZE;
> +		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
>  		break;
>  	default:
>  		rc = VM_FAULT_SIGBUS;
>  	}
> +
> +	if (rc == VM_FAULT_NOPAGE) {
> +		unsigned long i;
> +
> +		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
> +			struct page *page;
> +
> +			page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
> +			if (page->mapping)
> +				continue;
> +			page->mapping = filp->f_mapping;
> +		}
> +	}
>  	dax_read_unlock(id);

Careful here. Page fault can return VM_FAULT_NOPAGE even if we raced with
somebody modifying the PTE or if we installed a zero page. With shared DAX
mappings (and device dax does not allow anything else if I'm right) this
does not matter as given file offset is guaranteed to always map to the
same page but I think it deserves a comment.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
