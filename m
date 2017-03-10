Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22e.google.com (mail-ot0-x22e.google.com
 [IPv6:2607:f8b0:4003:c0f::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB5148039E
 for <linux-nvdimm@lists.01.org>; Thu,  9 Mar 2017 16:03:53 -0800 (PST)
Received: by mail-ot0-x22e.google.com with SMTP id 19so67472237oti.0
 for <linux-nvdimm@lists.01.org>; Thu, 09 Mar 2017 16:03:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <148910376733.27406.9048213402296101821.stgit@djiang5-desk3.ch.intel.com>
References: <148910376176.27406.3341100457410288547.stgit@djiang5-desk3.ch.intel.com>
 <148910376733.27406.9048213402296101821.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Mar 2017 16:03:52 -0800
Message-ID: <CAPcyv4hX1Uf+wJ6Qw4ymVpqCpGZQd8M_A9EaPm42AKSFhONtdw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dax: fix device-dax fault handling so that it would
 fallback
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 9, 2017 at 3:56 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Jeff Moyer reports that:
> "
> With a device dax alignment of 4KB or 2MB, I get sigbus when running the
> attached fio job file for the current kernel (4.11.0-rc1+).  If I
> specify an alignment of 1GB, it works.
>
> I turned on debug output, and saw that it was failing in the huge fault
> code.
>
> [ 4614.138357] dax dax1.0: dax_open
> [ 4614.154838] dax dax1.0: dax_mmap
> [ 4614.171898] dax dax1.0: dax_dev_huge_fault: fio: write (0x7f08f0a00000 - 0x7f0ce0800000)
> [ 4614.211720] dax dax1.0: __dax_dev_pud_fault: phys_to_pgoff(0xffffffffcf600) failed
> [ 4614.568911] dax dax1.0: dax_release
>
> fio config for reproduce:
> [global]
> ioengine=dev-dax
> direct=0
> filename=/dev/dax0.0
> bs=2m
>
> [write]
> rw=write
>
> [read]
> stonewall
> rw=read
> "
>
> It looks like the code does not fallback at all when handling faults. The
> fault handlers are missing some boundary checking for the VMA. Also, we need
> to fall back if the alignment requested is less than the P-entry size.
>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dax/dax.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
> index 174690a..5c7998e 100644
> --- a/drivers/dax/dax.c
> +++ b/drivers/dax/dax.c
> @@ -480,12 +480,21 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
>                 return VM_FAULT_SIGBUS;
>         }
>
> +       /* fall back if we are outside of the VMA */
> +       if (pmd_addr < vmf->vma->vm_start)
> +               return VM_FAULT_FALLBACK;
> +       if ((pmd_addr + PMD_SIZE) > vmf->vma->vm_end)
> +               return VM_FAULT_FALLBACK;

I think these are already handled by check_vma(), and we only want to
fallback if dax_region->align < PMD_SIZE, otherwise we're violating
device-dax's guaranteed fault granularity.

> +
> +       if (dax_region->align < PMD_SIZE)
> +               return VM_FAULT_FALLBACK;
> +
>         pgoff = linear_page_index(vmf->vma, pmd_addr);
>         phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
>         if (phys == -1) {
>                 dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
>                                 pgoff);
> -               return VM_FAULT_SIGBUS;
> +               return VM_FAULT_FALLBACK;

If we get past all the checks above then this is a failure.

>         }
>
>         pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
> @@ -519,12 +528,21 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
>                 return VM_FAULT_SIGBUS;
>         }
>
> +       /* fall back if we are outside of the VMA */
> +       if (pud_addr < vmf->vma->vm_start)
> +               return VM_FAULT_FALLBACK;
> +       if ((pud_addr + PUD_SIZE) > vmf->vma->vm_end)
> +               return VM_FAULT_FALLBACK;
> +
> +       if (dax_region->align < PUD_SIZE)
> +               return VM_FAULT_FALLBACK;
> +
>         pgoff = linear_page_index(vmf->vma, pud_addr);
>         phys = pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
>         if (phys == -1) {
>                 dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
>                                 pgoff);
> -               return VM_FAULT_SIGBUS;
> +               return VM_FAULT_FALLBACK;

Same comments as above. The dax_region->align check should catch all
the valid fallback cases and check_vma() should clean up everything
else.

>         }
>
>         pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
