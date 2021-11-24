Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611752C82
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 03:21:59 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so3362367pjj.0
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 19:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EL31Cy62VKrYRYptuLHbJfb/IYu8BUfyrtV7sdQIaLc=;
        b=tTzNJ2xX5PU2ZMtodj9dANcIKZZwQKRHX4lB/NL5LZNN4Zr1VE+P5ovmtCw8EES+Wi
         NQ80+oi4ntIVYsB1h9MkMbp03nngY0IViVo2xEBceq5t5+uhw3UVcNgcwXpITZJ3CCyC
         SpZn8KQKXy9b4rqCakALc7KqdS6D7C5QHJit1vCpGIDnMWhrdqyaarz+LrZmWI3mEXOm
         ygI9Ibrs/NzMWc7N8tOq7qOYtk6nUBQRWJgA2OarsoGDF20YgKNLJkU8STlFqZsVqk64
         ncL/ACZOLTjitKw6c3ssSTeyj3d8bbWUIk03dhK9dD82q1d41Wmi7s8ZhTarVWeBvFfe
         SvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EL31Cy62VKrYRYptuLHbJfb/IYu8BUfyrtV7sdQIaLc=;
        b=tw51DzLG5/4Zw2fJowL6q+6HHZ8jSmRYv1b2p/j/Cs/lClOk8zi1klKWUIrNHu4hlH
         JSWWZeDKNc/2R0RIURL1MDQUneMtgbgYReDTiQOJTcuyZi/wyvmZplwXx3pO6SBTyPTK
         Bg9qmUKwLQDP7ISNizYFe240mGLqbhJDSDSVBY6nBuE5Qx9jYuKRdR4NIbBjL4+EgoTF
         NOl9MeCIUWj+SKMmrR4eAmDG5svb8zQP5WnM94Pi3IeF8vwKvx988Plz6qF301zZfN3E
         7ZajYqFIEwk0t4tMFY4ASjXIBlYBo0xr8Gj2U5S4CqTGgXFELhJVEknmABdVjFNnqsKU
         M4Uw==
X-Gm-Message-State: AOAM531qnDSsOj3tuyEL8EnVcY8o+IpnfV6W8aI7a6WWMvy+7Y7C27JY
	tiPdlJ7x/iCZkSWRXMb1CxjY33tiRD7hujnoYfDwCw==
X-Google-Smtp-Source: ABdhPJy2aFen0PqWttd8BjEdIQsqphuBXqzJVHlhc+QCr5UJA27t1P+Fp9qpkknnP9tnEfW8e0xOGoy/eRGZQ5QtCf0=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr3873250pjb.220.1637724118856;
 Tue, 23 Nov 2021 19:21:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-27-hch@lst.de>
In-Reply-To: <20211109083309.584081-27-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 19:21:47 -0800
Message-ID: <CAPcyv4hHQMngb634K87hJkEgQEhMkGKft30JCbFy2eEXA57oKA@mail.gmail.com>
Subject: Re: [PATCH 26/29] fsdax: shift partition offset handling into the
 file systems
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Remove the last user of ->bdev in dax.c by requiring the file system to
> pass in an address that already includes the DAX offset.  As part of the
> only set ->bdev or ->daxdev when actually required in the ->iomap_begin
> methods.

Changes look good except for what looks like an argument position
fixup needed for an xfs_bmbt_to_iomap() caller below...

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c                 |  6 +-----
>  fs/erofs/data.c          | 11 ++++++++--
>  fs/erofs/internal.h      |  1 +
>  fs/ext2/inode.c          |  8 +++++--
>  fs/ext4/inode.c          | 16 +++++++++-----
>  fs/xfs/libxfs/xfs_bmap.c |  4 ++--
>  fs/xfs/xfs_aops.c        |  2 +-
>  fs/xfs/xfs_iomap.c       | 45 +++++++++++++++++++++++++---------------
>  fs/xfs/xfs_iomap.h       |  5 +++--
>  fs/xfs/xfs_pnfs.c        |  2 +-
>  10 files changed, 63 insertions(+), 37 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 0bd6cdcbacfc4..2c13c681edf09 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -711,11 +711,7 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>
>  static pgoff_t dax_iomap_pgoff(const struct iomap *iomap, loff_t pos)
>  {
> -       phys_addr_t paddr = iomap->addr + (pos & PAGE_MASK) - iomap->offset;
> -
> -       if (iomap->bdev)
> -               paddr += (get_start_sect(iomap->bdev) << SECTOR_SHIFT);
> -       return PHYS_PFN(paddr);
> +       return PHYS_PFN(iomap->addr + (pos & PAGE_MASK) - iomap->offset);
>  }
>
>  static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 0e35ef3f9f3d7..9b1bb177ce303 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
[..]
               }
> @@ -215,9 +218,13 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>         if (ret)
>                 return ret;
>
> -       iomap->bdev = mdev.m_bdev;
> -       iomap->dax_dev = mdev.m_daxdev;
>         iomap->offset = map.m_la;
> +       if (flags & IOMAP_DAX) {
> +               iomap->dax_dev = mdev.m_daxdev;
> +               iomap->offset += mdev.m_dax_part_off;
> +       } else {
> +               iomap->bdev = mdev.m_bdev;
> +       }

Ah, that's what IOMAP_DAX is for, to stop making iomap carry bdev
details unnecessarily.

[..]
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 704292c6ce0c7..74dbf1fd99d39 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -54,7 +54,8 @@ xfs_bmbt_to_iomap(
>         struct xfs_inode        *ip,
>         struct iomap            *iomap,
>         struct xfs_bmbt_irec    *imap,
> -       u16                     flags)
> +       unsigned int            flags,
> +       u16                     iomap_flags)

It would be nice if the compiler could help with making sure that
right 'flags' values are passed to the right 'flags' parameter, but I
can't think of

[..]
> @@ -1053,23 +1061,24 @@ xfs_buffered_write_iomap_begin(
>          */
>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
>         trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
> -       return xfs_bmbt_to_iomap(ip, iomap, &imap, IOMAP_F_NEW);
> +       return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW);
>
>  found_imap:
>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -       return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
> +       return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);

The iomap flags are supposed to be the last argument, right?
