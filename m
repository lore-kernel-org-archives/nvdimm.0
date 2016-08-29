Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5A5F1A1DEE
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 12:34:22 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id c15so210399827oig.0
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 12:34:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472497881-9323-2-git-send-email-toshi.kani@hpe.com>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
 <1472497881-9323-2-git-send-email-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Aug 2016 12:34:21 -0700
Message-ID: <CAPcyv4hJ1DrCkBCwqm02e1D85wtSPwUaSG2S84JaDJwFWA_4hA@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND 1/2] thp,
 dax: add thp_get_unmapped_area for pmd mappings
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 29, 2016 at 12:11 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using pmd page
> size.  This feature relies on both mmap virtual address and FS
> block (i.e. physical address) to be aligned by the pmd page size.
> Users can use mkfs options to specify FS to align block allocations.
> However, aligning mmap address requires code changes to existing
> applications for providing a pmd-aligned address to mmap().
>
> For instance, fio with "ioengine=mmap" performs I/Os with mmap() [1].
> It calls mmap() with a NULL address, which needs to be changed to
> provide a pmd-aligned address for testing with DAX pmd mappings.
> Changing all applications that call mmap() with NULL is undesirable.
>
> Add thp_get_unmapped_area(), which can be called by filesystem's
> get_unmapped_area to align an mmap address by the pmd size for
> a DAX file.  It calls the default handler, mm->get_unmapped_area(),
> to find a range and then aligns it for a DAX file.
>
> The patch is based on Matthew Wilcox's change that allows adding
> support of the pud page size easily.
>
> [1]: https://github.com/axboe/fio/blob/master/engines/mmap.c
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> ---

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...with one minor nit:


>  include/linux/huge_mm.h |    7 +++++++
>  mm/huge_memory.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 6f14de4..4fca526 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -87,6 +87,10 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
>
>  extern unsigned long transparent_hugepage_flags;
>
> +extern unsigned long thp_get_unmapped_area(struct file *filp,
> +               unsigned long addr, unsigned long len, unsigned long pgoff,
> +               unsigned long flags);
> +
>  extern void prep_transhuge_page(struct page *page);
>  extern void free_transhuge_page(struct page *page);
>
> @@ -169,6 +173,9 @@ void put_huge_zero_page(void);
>  static inline void prep_transhuge_page(struct page *page) {}
>
>  #define transparent_hugepage_flags 0UL
> +
> +#define thp_get_unmapped_area  NULL

Lets make this:

static inline unsigned long thp_get_unmapped_area(struct file *filp,
               unsigned long addr, unsigned long len, unsigned long pgoff,
               unsigned long flags)
{
    return 0;
}

...to get some type checking in the CONFIG_TRANSPARENT_HUGEPAGE=n case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
