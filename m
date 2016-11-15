Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22c.google.com (mail-it0-x22c.google.com
 [IPv6:2607:f8b0:4001:c0b::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AACD881D70
 for <linux-nvdimm@lists.01.org>; Mon, 14 Nov 2016 19:14:18 -0800 (PST)
Received: by mail-it0-x22c.google.com with SMTP id q124so144238675itd.1
 for <linux-nvdimm@lists.01.org>; Mon, 14 Nov 2016 19:14:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Nov 2016 19:14:22 -0800
Message-ID: <CAPcyv4hTchhsNXhKx6WpUWsvFyZjzJ4sx1emLCSU2iDKSMG1hA@mail.gmail.com>
Subject: Re: [PATCH] mm: add ZONE_DEVICE statistics to smaps
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
To: Christoph Hellwig <hch@lst.de>
Cc: Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 10, 2016 at 2:11 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> ZONE_DEVICE pages are mapped into a process via the filesystem-dax and
> device-dax mechanisms.  There are also proposals to use ZONE_DEVICE
> pages for other usages outside of dax.  Add statistics to smaps so
> applications can debug that they are obtaining the mappings they expect,
> or otherwise accounting them.
>
> Cc: Christoph Hellwig <hch@lst.de>

Christoph,

Wanted to get your opinion on this given your earlier concerns about
the VM_DAX flag.

This instead lets an application know how much of a vma is backed by
ZONE_DEVICE pages, but does not make any indications about the vma
having DAX semantics or not.  I.e. it is possible that 'device' and
'device_huge' are non-zero *and* vma_is_dax() is false.  So, it is
purely accounting the composition of the present pages in the vma.

Another option is to have something like 'shared_thp' just to account
for file backed huge pages that dax can map.  However if ZONE_DEVICE
is leaking into other use cases I think it makes sense to have it be a
first class-citizen with respect to accounting alongside
'anonymous_thp'.

> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/proc/task_mmu.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 35b92d81692f..6765cafcf057 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -445,6 +445,8 @@ struct mem_size_stats {
>         unsigned long swap;
>         unsigned long shared_hugetlb;
>         unsigned long private_hugetlb;
> +       unsigned long device;
> +       unsigned long device_huge;
>         u64 pss;
>         u64 swap_pss;
>         bool check_shmem_swap;
> @@ -458,6 +460,8 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
>
>         if (PageAnon(page))
>                 mss->anonymous += size;
> +       else if (is_zone_device_page(page))
> +               mss->device += size;
>
>         mss->resident += size;
>         /* Accumulate the size in pages that have been accessed. */
> @@ -575,7 +579,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>         else if (PageSwapBacked(page))
>                 mss->shmem_thp += HPAGE_PMD_SIZE;
>         else if (is_zone_device_page(page))
> -               /* pass */;
> +               mss->device_huge += HPAGE_PMD_SIZE;
>         else
>                 VM_BUG_ON_PAGE(1, page);
>         smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd));
> @@ -774,6 +778,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
>                    "ShmemPmdMapped: %8lu kB\n"
>                    "Shared_Hugetlb: %8lu kB\n"
>                    "Private_Hugetlb: %7lu kB\n"
> +                  "Device:         %8lu kB\n"
> +                  "DeviceHugePages: %7lu kB\n"
>                    "Swap:           %8lu kB\n"
>                    "SwapPss:        %8lu kB\n"
>                    "KernelPageSize: %8lu kB\n"
> @@ -792,6 +798,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
>                    mss.shmem_thp >> 10,
>                    mss.shared_hugetlb >> 10,
>                    mss.private_hugetlb >> 10,
> +                  mss.device >> 10,
> +                  mss.device_huge >> 10,
>                    mss.swap >> 10,
>                    (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
>                    vma_kernel_pagesize(vma) >> 10,
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
