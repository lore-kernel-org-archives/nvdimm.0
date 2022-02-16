Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5F31844
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 01:49:39 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id y5so885178pfe.4
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 17:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JqjP6+knVxmjPk+6TmXifMsYagmkY7dGlbu+Cp4tVhU=;
        b=bqoqzVAheRcyp+ejCrtXym4Z2mkOqeEcWbPXTP4OrhtoSvFe6qeX8Z+qPcG8we/1WU
         6vbAyx7hqOvrJBnqbsp1sqSNf3F5Sh0/8KdLZhBDYN+20l/T4GsRKpeDia0wfTPIn6h8
         tAcUGMCYG7vXuKkQnHZAv8O0VoFaWE7ZhzTDN26+PdBRy2vEI0dd6kyetaKcI9xcwcOZ
         EHP8wxlTGOhAUvtsP7NY3Th5mcnzS+6y2h696Ho+CKjG6t2zUnbt27OQo5fpX0o6+oQW
         DarJKZu/sVNRGQqf04WmgOdeeT/+QOnl2oPtPQCo18HBMl/o7HhW9fz1Vs0mkfLOXX+D
         Ig/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JqjP6+knVxmjPk+6TmXifMsYagmkY7dGlbu+Cp4tVhU=;
        b=FfC8a/CwhN1gkJJxZ2GrCaTDtZA3T5UbA5KI7c4txd4Co0PX1H+48DH3DHJmonw/0z
         U1ISH5DdPHugtaTCkrBM3CQ1mxJVg8YE149X/tj3b7DOU+NOO2NCAvdEo350p3o2/CbH
         LV52ULk3BItGey69eGZfppvKZ4wwUaIoVjOhc7//lQEsKjWYDNdIn+UfjKtS+rpeOXEW
         HoNkGlkt+aVEN0XTAJrJF/wb3L3vQ30YArl/gq92puzhNRkgcXf4KhjvBcPcZs6AYX2/
         Vzgb9NS40bRszKfGod4JS8FX4BVdmINJaLBU1i/fAbFPt89LlKdla0nOlWis1S7e8llT
         XHmA==
X-Gm-Message-State: AOAM531l2OozU9WPFD1mJSABRhL53fSc0lXp5kJGB2R91Skq0BFxXj0x
	3rUNtGfhXp4yclHvcU6LWY9mpjzYh8JSJkHH1mpfpg==
X-Google-Smtp-Source: ABdhPJzBpx1jse2xbj8mriAE5IRH5N45DhXrywujvPaUi9rvoKWGSdtDsmmftwEW/BKqPOTy/zsrvgbsO0oqrb+xe0E=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr411493pgb.74.1644976179422; Tue, 15 Feb
 2022 17:49:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-8-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-8-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 17:49:33 -0800
Message-ID: <CAPcyv4h+jQcwSo-CHUhy98xVvjJzvK74-s4uH+Qu-jCr1+zKjw@mail.gmail.com>
Subject: Re: [PATCH v10 7/9] mm: Introduce mf_dax_kill_procs() for fsdax case
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> This function is called at the end of RMAP routine, i.e. filesystem
> recovery function, to collect and kill processes using a shared page of
> DAX file.  The difference with mf_generic_kill_procs() is, it accepts
> file's (mapping,offset) instead of struct page because different files'
> mappings and offsets may share the same page in fsdax mode.
> It will be called when filesystem's RMAP results are found.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  include/linux/mm.h  |  4 ++
>  mm/memory-failure.c | 91 +++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 84 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9b1d56c5c224..0420189e4788 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3195,6 +3195,10 @@ enum mf_flags {
>         MF_SOFT_OFFLINE = 1 << 3,
>         MF_UNPOISON = 1 << 4,
>  };
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> +                     unsigned long count, int mf_flags);
> +#endif /* CONFIG_FS_DAX */
>  extern int memory_failure(unsigned long pfn, int flags);
>  extern void memory_failure_queue(unsigned long pfn, int flags);
>  extern void memory_failure_queue_kick(int cpu);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b2d13eba1071..8d123cc4102e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -304,10 +304,9 @@ void shake_page(struct page *p)
>  }
>  EXPORT_SYMBOL_GPL(shake_page);
>
> -static unsigned long dev_pagemap_mapping_shift(struct page *page,
> -               struct vm_area_struct *vma)
> +static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
> +               unsigned long address)
>  {
> -       unsigned long address = vma_address(page, vma);
>         unsigned long ret = 0;
>         pgd_t *pgd;
>         p4d_t *p4d;
> @@ -347,9 +346,8 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
>   * Schedule a process for later kill.
>   * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
>   */
> -static void add_to_kill(struct task_struct *tsk, struct page *p,
> -                      struct vm_area_struct *vma,
> -                      struct list_head *to_kill)
> +static void add_to_kill(struct task_struct *tsk, struct page *p, pgoff_t pgoff,
> +                       struct vm_area_struct *vma, struct list_head *to_kill)
>  {
>         struct to_kill *tk;
>
> @@ -360,9 +358,15 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
>         }
>
>         tk->addr = page_address_in_vma(p, vma);
> -       if (is_zone_device_page(p))
> -               tk->size_shift = dev_pagemap_mapping_shift(p, vma);
> -       else
> +       if (is_zone_device_page(p)) {
> +               /*
> +                * Since page->mapping is not used for fsdax, we need
> +                * calculate the address based on the vma.
> +                */
> +               if (p->pgmap->type == MEMORY_DEVICE_FS_DAX)
> +                       tk->addr = vma_pgoff_address(vma, pgoff);
> +               tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
> +       } else
>                 tk->size_shift = page_shift(compound_head(p));
>
>         /*
> @@ -510,7 +514,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
>                         if (!page_mapped_in_vma(page, vma))
>                                 continue;
>                         if (vma->vm_mm == t->mm)
> -                               add_to_kill(t, page, vma, to_kill);
> +                               add_to_kill(t, page, 0, vma, to_kill);
>                 }
>         }
>         read_unlock(&tasklist_lock);
> @@ -546,12 +550,40 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
>                          * to be informed of all such data corruptions.
>                          */
>                         if (vma->vm_mm == t->mm)
> -                               add_to_kill(t, page, vma, to_kill);
> +                               add_to_kill(t, page, 0, vma, to_kill);
> +               }
> +       }
> +       read_unlock(&tasklist_lock);
> +       i_mmap_unlock_read(mapping);
> +}
> +
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +/*
> + * Collect processes when the error hit a fsdax page.
> + */
> +static void collect_procs_fsdax(struct page *page,
> +               struct address_space *mapping, pgoff_t pgoff,
> +               struct list_head *to_kill)
> +{
> +       struct vm_area_struct *vma;
> +       struct task_struct *tsk;
> +
> +       i_mmap_lock_read(mapping);
> +       read_lock(&tasklist_lock);
> +       for_each_process(tsk) {
> +               struct task_struct *t = task_early_kill(tsk, true);
> +
> +               if (!t)
> +                       continue;
> +               vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
> +                       if (vma->vm_mm == t->mm)
> +                               add_to_kill(t, page, pgoff, vma, to_kill);
>                 }
>         }
>         read_unlock(&tasklist_lock);
>         i_mmap_unlock_read(mapping);
>  }
> +#endif /* CONFIG_FS_DAX */
>
>  /*
>   * Collect the processes who have the corrupted page mapped to kill.
> @@ -1574,6 +1606,43 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>         return 0;
>  }
>
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +/**
> + * mf_dax_kill_procs - Collect and kill processes who are using this file range
> + * @mapping:   the file in use
> + * @index:     start pgoff of the range within the file
> + * @count:     length of the range, in unit of PAGE_SIZE
> + * @mf_flags:  memory failure flags
> + */
> +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> +               unsigned long count, int mf_flags)
> +{
> +       LIST_HEAD(to_kill);
> +       int rc;
> +       struct page *page;
> +       size_t end = index + count;
> +
> +       mf_flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +       for (; index < end; index++) {
> +               page = NULL;
> +               rc = dax_load_page(mapping, index, &page);
> +               if (rc)
> +                       return rc;
> +               if (!page)
> +                       continue;
> +
> +               SetPageHWPoison(page);
> +
> +               collect_procs_fsdax(page, mapping, index, &to_kill);
> +               unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
> +                               index, mf_flags);

Depending on the answer to the question in patch5 there may need to be
a put_page() or dax_unlock_page() here.
