Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F229168
	for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 22:54:13 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id i21so6909288pfd.8
        for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 15:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lv2BeH4bgVl/il3tYjXjqwuIZSwlS9CtCv+JW+Pfbnk=;
        b=dEJPorhN3VxbZejMS9q6PqBKwfMxKo1HPdf3+5BUH3dfXPgs88YSbj05k1hkBef+nM
         7vvU9XbId6WFv2lSIWSM6XXy2UPxLdeQ01Wfso2qKlbUco0zvIots/ul6DKzQ3DZcYNi
         P23cHa+p9+b2jIJWKtu1dQDl7lc5qIeAeuXdBKWusDgdFF5Zj6LRxzv+LIlIsEDHbKIC
         bA+OW2FTcspqya2PhtHxAy1glalU05anLkdQRHMAOe/TGgzUsBpfY3vrr6LgE6ZRnpxT
         PRy9SHdri/5ppUNRZwQkgaG+JzE/XBJi92LOIl7cj7phiuPVPAc4PUoOZ9875GEsDMjs
         SlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lv2BeH4bgVl/il3tYjXjqwuIZSwlS9CtCv+JW+Pfbnk=;
        b=oU2Tu52iA3FGLakosiN2pOZjOf8XQTLummbM0OcnRhYh+Ta0R1U2OVSV43hfymI50Y
         lr+nNmBaAZQRqeYZ6bvhN/vRrbZ+4kZ13TbrzEsNY1pPss9kVxlAKlKgjTpkLG2QjVwg
         Rxoa9fxS8n6Ozs3H1NZgUKWPJDc0+W/tQtz76Ic92R3MN7CTcKb5Z48VP0dwxoWaHzKC
         8zN6jftCjn+6zq1zA/Em6pHpgY39pBBPw4lwfLLHUVGrndRLagcIGRNJOkC0jkAmTADB
         u41nPcBz78+yEmGNB0lxwwB1yXoNRJqds8YNx62hbzSAQEEZ/XHPTC6Q8InrqrSnj7B9
         3wHw==
X-Gm-Message-State: AOAM5325i7557nD9gyYDC4Fah/rmyMUQe4LYtwhsU3E8MqxvG2JPzks1
	Nen4xMDi0iIFjlXLMCTHlKLRn7Tfj63WrO2+an9kow==
X-Google-Smtp-Source: ABdhPJy6c4gZ53hpbV6ORkyR2hmtHChkZnjGtdS6jdctPV28zWH0Y9aOAbm0cOMMyjXm7vkX87wjxDLfz1NQUUNKdrQ=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
 l6-20020a056a0016c6b029032de1909dd0mr16584327pfc.70.1629413652651; Thu, 19
 Aug 2021 15:54:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-4-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210816060359.1442450-4-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Aug 2021 15:54:01 -0700
Message-ID: <CAPcyv4iOSxoy-qGfAd3i4uzwfDX0t1xTmyM0pNd+-euVMDUwrQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] fsdax: Replace mmap entry in case of CoW
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, 
	david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>, 
	Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> We replace the existing entry to the newly allocated one in case of CoW.
> Also, we mark the entry as PAGECACHE_TAG_TOWRITE so writeback marks this
> entry as writeprotected.  This helps us snapshots so new write
> pagefaults after snapshots trigger a CoW.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/dax.c | 39 ++++++++++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 11 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 697a7b7bb96f..e49ba68cc7e4 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -734,6 +734,10 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
>         return 0;
>  }
>
> +/* DAX Insert Flag: The state of the entry we insert */
> +#define DAX_IF_DIRTY           (1 << 0)
> +#define DAX_IF_COW             (1 << 1)
> +
>  /*
>   * By this point grab_mapping_entry() has ensured that we have a locked entry
>   * of the appropriate size so we don't have to worry about downgrading PMDs to
> @@ -741,16 +745,19 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
>   * already in the tree, we will skip the insertion and just dirty the PMD as
>   * appropriate.
>   */
> -static void *dax_insert_entry(struct xa_state *xas,
> -               struct address_space *mapping, struct vm_fault *vmf,
> -               void *entry, pfn_t pfn, unsigned long flags, bool dirty)
> +static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
> +               void *entry, pfn_t pfn, unsigned long flags,
> +               unsigned int insert_flags)

I'm late, so feel free to ignore this style feedback, but what about
changing the signature to:

static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
                              const struct iomap_iter *iter, void
*entry, pfn_t pfn,
                              unsigned long flags)


>  {
> +       struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>         void *new_entry = dax_make_entry(pfn, flags);
> +       bool dirty = insert_flags & DAX_IF_DIRTY;
> +       bool cow = insert_flags & DAX_IF_COW;

...and then calculate these flags from the source data. I'm just
reacting to "yet more flags".

So, take it or leave it,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
