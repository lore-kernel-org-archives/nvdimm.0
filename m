Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x244.google.com (mail-lf0-x244.google.com
 [IPv6:2a00:1450:4010:c07::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 739D220352134
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 22:59:22 -0700 (PDT)
Received: by mail-lf0-x244.google.com with SMTP id m18-v6so992026lfb.0
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 22:59:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180417132842.GA30189@jordon-HP-15-Notebook-PC>
References: <20180417132842.GA30189@jordon-HP-15-Notebook-PC>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Fri, 27 Apr 2018 11:29:19 +0530
Message-ID: <CAFqt6zY9E=XSiP5Q4N6Dh+oeVRkRf+wCBJx3XcD4MDJ=NdYG4g@mail.gmail.com>
Subject: Re: [PATCH v3] dax: Change return type to vm_fault_t
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Matthew/ Ross,

There are two changes exist in mm/huge_memory.c as part of this
patch. vmf_insert_pfn_pmd() and vmf_insert_pfn_pud() functions are
invoked from this patch.

Shall we put both in a single patch that it will easy to bisect in case
we have any issue ?

On Tue, Apr 17, 2018 at 6:58 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> Use new return type vm_fault_t for fault and huge_fault
> handler. For now, this is just documenting that the
> function returns a VM_FAULT value rather than an errno.
> Once all instances are converted, vm_fault_t will become
> a distinct type.
>
> Reference id -> 1c8f422059ae ("mm: change return type to
> vm_fault_t")
>
> Previously vm_insert_mixed() returns err which driver
> mapped into VM_FAULT_* type. The new function
> vmf_insert_mixed() will replace this inefficiency by
> returning VM_FAULT_* type.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
> v2: Modified the change log
>
> v3: Updated the change log and
>     added Ross in review list
>
>  drivers/dax/device.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 2137dbc..a122701 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -243,11 +243,11 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
>         return -1;
>  }
>
> -static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
> +static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
> +                               struct vm_fault *vmf)
>  {
>         struct device *dev = &dev_dax->dev;
>         struct dax_region *dax_region;
> -       int rc = VM_FAULT_SIGBUS;
>         phys_addr_t phys;
>         pfn_t pfn;
>         unsigned int fault_size = PAGE_SIZE;
> @@ -274,17 +274,11 @@ static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
>
>         pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
>
> -       rc = vm_insert_mixed(vmf->vma, vmf->address, pfn);
> -
> -       if (rc == -ENOMEM)
> -               return VM_FAULT_OOM;
> -       if (rc < 0 && rc != -EBUSY)
> -               return VM_FAULT_SIGBUS;
> -
> -       return VM_FAULT_NOPAGE;
> +       return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
>  }
>
> -static int __dev_dax_pmd_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
> +static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
> +                               struct vm_fault *vmf)
>  {
>         unsigned long pmd_addr = vmf->address & PMD_MASK;
>         struct device *dev = &dev_dax->dev;
> @@ -335,7 +329,8 @@ static int __dev_dax_pmd_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
>  }
>
>  #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> -static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
> +static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
> +                               struct vm_fault *vmf)
>  {
>         unsigned long pud_addr = vmf->address & PUD_MASK;
>         struct device *dev = &dev_dax->dev;
> @@ -386,13 +381,14 @@ static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
>                         vmf->flags & FAULT_FLAG_WRITE);
>  }
>  #else
> -static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
> +static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
> +                               struct vm_fault *vmf)
>  {
>         return VM_FAULT_FALLBACK;
>  }
>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>
> -static int dev_dax_huge_fault(struct vm_fault *vmf,
> +static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>                 enum page_entry_size pe_size)
>  {
>         int rc, id;
> @@ -423,7 +419,7 @@ static int dev_dax_huge_fault(struct vm_fault *vmf,
>         return rc;
>  }
>
> -static int dev_dax_fault(struct vm_fault *vmf)
> +static vm_fault_t dev_dax_fault(struct vm_fault *vmf)
>  {
>         return dev_dax_huge_fault(vmf, PE_SIZE_PTE);
>  }
> --
> 1.9.1
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
