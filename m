Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22d.google.com (mail-ob0-x22d.google.com
 [IPv6:2607:f8b0:4003:c01::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55E751A1EF8
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:34:55 -0800 (PST)
Received: by mail-ob0-x22d.google.com with SMTP id ts10so91394104obc.1
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:34:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457637535-21633-12-git-send-email-jack@suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-12-git-send-email-jack@suse.cz>
Date: Thu, 10 Mar 2016 11:34:39 -0800
Message-ID: <CAPcyv4iQZ0UG=ikW6OCgsFUqFT6K36U_K02-R0tv4XrKwAc69Q@mail.gmail.com>
Subject: Re: [PATCH 11/12] dax: Disable huge page handling
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Wilcox, Matthew R  <matthew.r.wilcox@intel.com>, NeilBrown <neilb@suse.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 10, 2016 at 11:18 AM, Jan Kara <jack@suse.cz> wrote:
> Currently the handling of huge pages for DAX is racy. For example the
> following can happen:
>
> CPU0 (THP write fault)                  CPU1 (normal read fault)
>
> __dax_pmd_fault()                       __dax_fault()
>   get_block(inode, block, &bh, 0) -> not mapped
>                                         get_block(inode, block, &bh, 0)
>                                           -> not mapped
>   if (!buffer_mapped(&bh) && write)
>     get_block(inode, block, &bh, 1) -> allocates blocks
>   truncate_pagecache_range(inode, lstart, lend);
>                                         dax_load_hole();
>
> This results in data corruption since process on CPU1 won't see changes
> into the file done by CPU0.
>
> The race can happen even if two normal faults race however with THP the
> situation is even worse because the two faults don't operate on the same
> entries in the radix tree and we want to use these entries for
> serialization. So disable THP support in DAX code for now.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c            | 2 +-
>  include/linux/dax.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 3951237ff248..7148fcdb2c92 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -715,7 +715,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  }
>  EXPORT_SYMBOL_GPL(dax_fault);
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#if 0
>  /*
>   * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
>   * more often than one might expect in the below function.
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 4b63923e1f8d..fd28d824254b 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -29,7 +29,7 @@ static inline struct page *read_dax_sector(struct block_device *bdev,
>  }
>  #endif
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#if 0
>  int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
>                                 unsigned int flags, get_block_t);
>  int __dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
> --
> 2.6.2
>

Maybe switch to marking FS_DAX_PMD as "depends on BROKEN" again?  That
way we re-use the same mechanism as the check for the presence of
ZONE_DEVICE / struct page for the given pfn.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
