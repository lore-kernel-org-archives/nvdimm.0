Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A274E72
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 19:35:54 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id s137so41469pgs.5
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 11:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5gWZdeoaC7jqVM8zeJ3InHmY5XgJ6AqsmAXMbMD6MVc=;
        b=RJbNLKJNENQkqCXxCv3ZqjAgJzmntRoY3C9WBVTRGPV4VV3BsA76Ni4hsnMjx2nH/v
         HoiW9wDtjxXp5Nt6qMkQL0DPLfSBqYL70YxFRSH4TO9PJ9rbhGeY0C9ffVxxiP3dggG6
         ohinBGy+D49Vm9oB3XNJcjF56eTmII8MaKy/6svWS/35apN6jxq7L2Jsl7ZSria5TcBs
         sLOxMGIhfsaMyGw+N0BmXXRNkuqqf4hp2KFJVKWMR0zMfA+xCeAOOLZYbsOOHncwIK6l
         JAuPbkyAWXwtk4Cvm6LivVMjAyUckXc1oEC/hdIwN1ZU2iT426Roiy5HqofbB7cbAMCs
         R42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5gWZdeoaC7jqVM8zeJ3InHmY5XgJ6AqsmAXMbMD6MVc=;
        b=qW5LlCJuTMsgv82xGrwHSM27JUy0yakBxmqwMiYA7SYV8bFGR1gETEojgmM+qBwCqp
         DOoG8CKaK0fdi6wpW2+vgarx8uPbfrXKOBd/55adD1w/6bnLBQj/22Yfm5rdcnbJfa7K
         UnlqhT1lYnyow6Mj9Vf8FKSmTfvtXFva1DEc81D7374571T1DrU8XrPv14+fFP3JkHf/
         /DruyI92rsbbY9epi99hqxUhraaDJ1qjFvsX/TbPvPnMkTLmoyzn0oYNMnTYUhCzwJt8
         dloc6VfpFo/ewpLQ4JbrT13IdcYtzySfq4lumXuaVUW28HNf3M6YFF3PLG8C52i3UQPb
         Uakw==
X-Gm-Message-State: AOAM530fdeh+sptdekJpFD/I6Ep6VdaNli/+Uxq0I+HAi57rOt52Cad5
	spHi8CE4rmeF7K3ifxOU0aJoDM+nZt34I63rTsRORQ==
X-Google-Smtp-Source: ABdhPJyUgiLjRKYUsHsrV83l3gO1RrPxkMBAXyAi/veRroUOh2xEn4EazOAyxkpoKqaxXeG2LfQdh/0f6yLjguWrfLs=
X-Received: by 2002:a63:5401:: with SMTP id i1mr5642151pgb.356.1637696154262;
 Tue, 23 Nov 2021 11:35:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-14-hch@lst.de>
In-Reply-To: <20211109083309.584081-14-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 11:35:43 -0800
Message-ID: <CAPcyv4i=PnXu6ixHtj4Bqi0gy=bJJijrWgTNEcQ6uEJiut4PfQ@mail.gmail.com>
Subject: Re: [PATCH 13/29] fsdax: use a saner calling convention for copy_cow_page_dax
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Just pass the vm_fault and iomap_iter structures, and figure out the rest
> locally.  Note that this requires moving dax_iomap_sector up in the file.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 73bd1439d8089..e51b4129d1b65 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -709,26 +709,31 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>         return __dax_invalidate_entry(mapping, index, false);
>  }
>
> -static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_dev,
> -                            sector_t sector, struct page *to, unsigned long vaddr)
> +static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
>  {
> +       return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> +}
> +
> +static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
> +{
> +       sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
>         void *vto, *kaddr;
>         pgoff_t pgoff;
>         long rc;
>         int id;
>
> -       rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
> +       rc = bdev_dax_pgoff(iter->iomap.bdev, sector, PAGE_SIZE, &pgoff);
>         if (rc)
>                 return rc;
>
>         id = dax_read_lock();
> -       rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
> +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>         if (rc < 0) {
>                 dax_read_unlock(id);
>                 return rc;
>         }
> -       vto = kmap_atomic(to);
> -       copy_user_page(vto, kaddr, vaddr, to);
> +       vto = kmap_atomic(vmf->cow_page);
> +       copy_user_page(vto, kaddr, vmf->address, vmf->cow_page);
>         kunmap_atomic(vto);
>         dax_read_unlock(id);
>         return 0;
> @@ -1005,11 +1010,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>
> -static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
> -{
> -       return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> -}
> -
>  static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
>                          pfn_t *pfnp)
>  {
> @@ -1332,19 +1332,16 @@ static vm_fault_t dax_fault_synchronous_pfnp(pfn_t *pfnp, pfn_t pfn)
>  static vm_fault_t dax_fault_cow_page(struct vm_fault *vmf,
>                 const struct iomap_iter *iter)
>  {
> -       sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
> -       unsigned long vaddr = vmf->address;
>         vm_fault_t ret;
>         int error = 0;
>
>         switch (iter->iomap.type) {
>         case IOMAP_HOLE:
>         case IOMAP_UNWRITTEN:
> -               clear_user_highpage(vmf->cow_page, vaddr);
> +               clear_user_highpage(vmf->cow_page, vmf->address);
>                 break;
>         case IOMAP_MAPPED:
> -               error = copy_cow_page_dax(iter->iomap.bdev, iter->iomap.dax_dev,
> -                                         sector, vmf->cow_page, vaddr);
> +               error = copy_cow_page_dax(vmf, iter);
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
> --
> 2.30.2
>
