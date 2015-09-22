Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1442943979-1931-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1442943979-1931-1-git-send-email-ross.zwisler@linux.intel.com>
Date: Tue, 22 Sep 2015 11:00:08 -0700
Message-ID: <CAPcyv4g8-jL3ufPJ9o7ro2sXpzAyQAucSP9YFrjvgt0XtT0Fuw@mail.gmail.com>
Subject: Re: [PATCH] dax: fix NULL pointer in __dax_pmd_fault()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 22, 2015 at 10:46 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> The following commit:
>
> commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for
>         DAX")
>
> moved some code in __dax_pmd_fault() that was responsible for zeroing
> newly allocated PMD pages.  The new location didn't properly set up
> 'kaddr', though, so when run this code resulted in a NULL pointer BUG.
>
> Fix this by getting the correct 'kaddr' via bdev_direct_access(), and
> only make the second call to bdev_direct_access() if we don't already
> have a PFN from the first call.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/dax.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 7ae6df7..08ac2bd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -532,7 +532,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>         void __pmem *kaddr;
>         pgoff_t size, pgoff;
>         sector_t block, sector;
> -       unsigned long pfn;
> +       unsigned long pfn = 0;
>         int result = 0;
>
>         /* Fall back to PTEs if we're going to COW */
> @@ -569,8 +569,20 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>         if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
>                 goto fallback;
>
> +       sector = bh.b_blocknr << (blkbits - 9);
> +
>         if (buffer_unwritten(&bh) || buffer_new(&bh)) {
>                 int i;
> +
> +               length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
> +                                               bh.b_size);
> +               if (length < 0) {
> +                       result = VM_FAULT_SIGBUS;
> +                       goto out;
> +               }
> +               if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
> +                       goto fallback;
> +
>                 for (i = 0; i < PTRS_PER_PMD; i++)
>                         clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
>                 wmb_pmem();
> @@ -623,15 +635,16 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>                 result = VM_FAULT_NOPAGE;
>                 spin_unlock(ptl);
>         } else {
> -               sector = bh.b_blocknr << (blkbits - 9);
> -               length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
> -                                               bh.b_size);
> -               if (length < 0) {
> -                       result = VM_FAULT_SIGBUS;
> -                       goto out;
> +               if (pfn == 0) {
> +                       length = bdev_direct_access(bh.b_bdev, sector, &kaddr,
> +                                       &pfn, bh.b_size);

bdev_direct_access isn't that expensive just call it twice
unconditionally.  We'll be going that direction anyways when we fix
the lifetime of 'kaddr' race in DAX.
