Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6383FC0
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 18:46:03 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id t1so17476976pgv.3
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bsWLS5Lsvli6/G6DR+M0//W1oeoCxpbroaiM0AweC2U=;
        b=cJwve58u1e5m7sq1m17LOxCx1TWZxIV225n3TyUIWLcuS7wiK3So1eEBRuWJuVlR2f
         ZLXuzA8sLPpwGnGe2Yk1AyXRJZDBWlRISfYsJ8gv6749D39kIF8KnvTCK3EbCOxUaxlp
         LGmfd7P1T4eH9WLpW17RKt0hIP2I/Vhp5q00KhjRS7FCdn/BvKP+nFi/hJKqAUpSBmBQ
         ahmtxdhOeKhEeHJ6iEJJFl9MgIYiM+ZU9UmBohE35lPT+s38Y12qHJ/Yq7JJTx4WQoaB
         L/OYBbRTy1crtTWqUvFh5XbJQGNjKDLPiSiYFz84weHUGmtIs3wik5fXRuL2uugwYOeE
         pLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bsWLS5Lsvli6/G6DR+M0//W1oeoCxpbroaiM0AweC2U=;
        b=Kzp3uJcH0GpCf2btQfa76pdOjn9ediHeJssCkoa04lUPiYmwPTotowcMO+exd7zty9
         e12NWRYTJ8PCWKkDX/1dJmRr0YEy90WznSXK9ipblPp63jN27HXEdF7Xl4wPCK0Y6cbJ
         5TBWevL9s3xl6hO/9hVSDSvTHWLKGtOgodIsLLMeApTKw3cgZdkAnamUxiFdVz5eqeIR
         USp1TY4JM7ddybFspLJiLK1ntJlkcGRBv+tJPwEvwZX4xa8NOexkmMOacjUMBrD0kCb/
         ZVt1PONPye9HNrNSEcXqy+VqW9Bnt1YXeXo5DGQBrvnZ0ykxOK3aKFZQ7OGEWFf59okq
         6P2w==
X-Gm-Message-State: AOAM532uwnxKlFBA3YjZe9JXGr8xlwlH/WR3FoMoNMblsMbTcEz+T0nl
	aSr8XTXRjlXcov4jL2DqRwcD+3qWIPKv5gmqk95kBA==
X-Google-Smtp-Source: ABdhPJxpo0+vyQ+xK7UvVGbCGg974A5JaeqyO5j1qTLhfDJa9Ok2iMc/TS0rPaPh8KlGL59bGBG0Nq+rOhg4vkr2vRw=
X-Received: by 2002:a63:dd0e:: with SMTP id t14mr32040633pgg.279.1629744363336;
 Mon, 23 Aug 2021 11:46:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-2-hch@lst.de>
In-Reply-To: <20210823123516.969486-2-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 11:45:52 -0700
Message-ID: <CAPcyv4h0QdHi10ngaXtuisxeZ+66wd-oy0F7r9C0FjJmyXBOFg@mail.gmail.com>
Subject: Re: [PATCH 1/9] fsdax: improve the FS_DAX Kconfig description and
 help text
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:37 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Rename the main option text to clarify it is for file system access,
> and add a bit of text that explains how to actually switch a nvdimm
> to a fsdax capable state.
>

Looks good, nice improvement. A couple suggestions below.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/Kconfig | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/fs/Kconfig b/fs/Kconfig
> index a7749c126b8e..37e4441119cf 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -43,7 +43,7 @@ source "fs/f2fs/Kconfig"
>  source "fs/zonefs/Kconfig"
>
>  config FS_DAX
> -       bool "Direct Access (DAX) support"
> +       bool "File system based Direct Access (DAX) support"
>         depends on MMU
>         depends on !(ARM || MIPS || SPARC)
>         select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
> @@ -53,8 +53,19 @@ config FS_DAX
>           Direct Access (DAX) can be used on memory-backed block devices.
>           If the block device supports DAX and the filesystem supports DAX,
>           then you can avoid using the pagecache to buffer I/Os.  Turning
> -         on this option will compile in support for DAX; you will need to
> -         mount the filesystem using the -o dax option.
> +         on this option will compile in support for DAX.
> +
> +         For a DAX device to support file system access it needs to have
> +         struct pages.  For the nfit based NVDIMMs this can be enabled
> +         using the ndctl utility:
> +
> +               # ndctl create-namespace --force --reconfig=namespace0.0 \
> +                       --mode=fsdax --map=mem

There's still the concern that on systems with small amount of DRAM
relative to large amounts of PMEM that --map=mem might consume all
available memory for 'struct page'. Perhaps just add:

"See the 'create-namespace' man page for details on the overhead of
--map=mem: https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace"

> +
> +          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well.
> +         For most file systems DAX support needs to be manually enable
> +         globally or per-inode using a mount option as well.  See the
> +         file system documentation for details.

How about include the link?

"See the file system documentation for details:
https://www.kernel.org/doc/html/latest/filesystems/dax.html"
