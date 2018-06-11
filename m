Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 855FC211C1B32
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 10:12:27 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 w5BH9acJ069430
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 13:12:26 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2jhu83p5rq-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 13:12:26 -0400
Received: from localhost
 by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <ldufour@linux.vnet.ibm.com>;
 Mon, 11 Jun 2018 18:12:23 +0100
Subject: Re: [PATCH v4 02/12] device-dax: Cleanup vm_fault de-reference chains
References: <152850182079.38390.8280340535691965744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152850183221.38390.15042297366983937566.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Date: Mon, 11 Jun 2018 19:12:19 +0200
MIME-Version: 1.0
In-Reply-To: <152850183221.38390.15042297366983937566.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Message-Id: <29908ce4-a8cf-bda6-4952-86c0afc3a9a2@linux.vnet.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On 09/06/2018 01:50, Dan Williams wrote:
> Define a local 'vma' variable rather than repetitively de-referencing
> the passed in 'struct vm_fault *' instance.

Hi Dan,

Why is this needed ?

I can't see the real benefit, having the vma deferenced from the vm_fault
structure is not obfuscating the code and it eases to follow the use of vmf->vma.

Am I missing something ?

Cheers,
Laurent.

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/device.c |   30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index d44d98c54d0f..686de08e120b 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -247,13 +247,14 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
>  static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
>  				struct vm_fault *vmf)
>  {
> +	struct vm_area_struct *vma = vmf->vma;
>  	struct device *dev = &dev_dax->dev;
>  	struct dax_region *dax_region;
>  	phys_addr_t phys;
>  	pfn_t pfn;
>  	unsigned int fault_size = PAGE_SIZE;
> 
> -	if (check_vma(dev_dax, vmf->vma, __func__))
> +	if (check_vma(dev_dax, vma, __func__))
>  		return VM_FAULT_SIGBUS;
> 
>  	dax_region = dev_dax->region;
> @@ -274,13 +275,14 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
> 
>  	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
> 
> -	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
> +	return vmf_insert_mixed(vma, vmf->address, pfn);
>  }
> 
>  static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
>  				struct vm_fault *vmf)
>  {
>  	unsigned long pmd_addr = vmf->address & PMD_MASK;
> +	struct vm_area_struct *vma = vmf->vma;
>  	struct device *dev = &dev_dax->dev;
>  	struct dax_region *dax_region;
>  	phys_addr_t phys;
> @@ -288,7 +290,7 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
>  	pfn_t pfn;
>  	unsigned int fault_size = PMD_SIZE;
> 
> -	if (check_vma(dev_dax, vmf->vma, __func__))
> +	if (check_vma(dev_dax, vma, __func__))
>  		return VM_FAULT_SIGBUS;
> 
>  	dax_region = dev_dax->region;
> @@ -310,11 +312,10 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
>  		return VM_FAULT_FALLBACK;
> 
>  	/* if we are outside of the VMA */
> -	if (pmd_addr < vmf->vma->vm_start ||
> -			(pmd_addr + PMD_SIZE) > vmf->vma->vm_end)
> +	if (pmd_addr < vma->vm_start || (pmd_addr + PMD_SIZE) > vma->vm_end)
>  		return VM_FAULT_SIGBUS;
> 
> -	pgoff = linear_page_index(vmf->vma, pmd_addr);
> +	pgoff = linear_page_index(vma, pmd_addr);
>  	phys = dax_pgoff_to_phys(dev_dax, pgoff, PMD_SIZE);
>  	if (phys == -1) {
>  		dev_dbg(dev, "pgoff_to_phys(%#lx) failed\n", pgoff);
> @@ -323,7 +324,7 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
> 
>  	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
> 
> -	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd, pfn,
> +	return vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
>  			vmf->flags & FAULT_FLAG_WRITE);
>  }
> 
> @@ -332,6 +333,7 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  				struct vm_fault *vmf)
>  {
>  	unsigned long pud_addr = vmf->address & PUD_MASK;
> +	struct vm_area_struct *vma = vmf->vma;
>  	struct device *dev = &dev_dax->dev;
>  	struct dax_region *dax_region;
>  	phys_addr_t phys;
> @@ -340,7 +342,7 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  	unsigned int fault_size = PUD_SIZE;
> 
> 
> -	if (check_vma(dev_dax, vmf->vma, __func__))
> +	if (check_vma(dev_dax, vma, __func__))
>  		return VM_FAULT_SIGBUS;
> 
>  	dax_region = dev_dax->region;
> @@ -362,11 +364,10 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  		return VM_FAULT_FALLBACK;
> 
>  	/* if we are outside of the VMA */
> -	if (pud_addr < vmf->vma->vm_start ||
> -			(pud_addr + PUD_SIZE) > vmf->vma->vm_end)
> +	if (pud_addr < vma->vm_start || (pud_addr + PUD_SIZE) > vma->vm_end)
>  		return VM_FAULT_SIGBUS;
> 
> -	pgoff = linear_page_index(vmf->vma, pud_addr);
> +	pgoff = linear_page_index(vma, pud_addr);
>  	phys = dax_pgoff_to_phys(dev_dax, pgoff, PUD_SIZE);
>  	if (phys == -1) {
>  		dev_dbg(dev, "pgoff_to_phys(%#lx) failed\n", pgoff);
> @@ -375,7 +376,7 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
> 
>  	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
> 
> -	return vmf_insert_pfn_pud(vmf->vma, vmf->address, vmf->pud, pfn,
> +	return vmf_insert_pfn_pud(vma, vmf->address, vmf->pud, pfn,
>  			vmf->flags & FAULT_FLAG_WRITE);
>  }
>  #else
> @@ -390,12 +391,13 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>  		enum page_entry_size pe_size)
>  {
>  	int rc, id;
> -	struct file *filp = vmf->vma->vm_file;
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct file *filp = vma->vm_file;
>  	struct dev_dax *dev_dax = filp->private_data;
> 
>  	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
>  			(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
> -			vmf->vma->vm_start, vmf->vma->vm_end, pe_size);
> +			vma->vm_start, vma->vm_end, pe_size);
> 
>  	id = dax_read_lock();
>  	switch (pe_size) {
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
