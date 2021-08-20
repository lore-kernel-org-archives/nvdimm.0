Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB04F72
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 03:01:19 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso6310136pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 20:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+qoHaIYFFF4+QiXB7j7KUJJJiqOIA/zGN5Tjr436H8=;
        b=kuG8T90/qXgx0IHMQpBfZ+mBvJWi6GWu2OW94VNop4bdF/v0Ajv0stPWwAdY39B7n5
         0aB+dCe80t5j46UCI0ZvrGeJn0mFR9VX8hnhHUJdfbFaCMx8Ho5EDzzMsYlp/3xPaxLp
         j/WFNlI2US+mpDGvS1ZH0lQnqTZSvh7wVwgww7oJS4uXDcSBDIsNWJnDKsF6br0hov4a
         220s+hY2spVwQdy7e4PmmtHuKjhrUBgOXmxZteVxKw0AfKz7XUvv7eyiZialc1aa32ND
         VO3oxca5GGNZpDrFx8Dt2JhAsxvFZSw6J2ewu9KXmYD+BVvuonFZp0Df7/aF1vGZI2u+
         JfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+qoHaIYFFF4+QiXB7j7KUJJJiqOIA/zGN5Tjr436H8=;
        b=bDZnA4zc1Tcqa4BBmoRTanJTs/0FD51E0Ga/EiHzulLVOszjqNV49Kkqpy1FCAqa80
         y3s7ka9CJDi8/3Nw7jyQN8n3rFMI0+310vK9udMwUY6oxc5IMz6DpDbJUz2/sXTOnA9W
         eGqIGYSr22v27ZtX/NYdAagLwSpP6TLMI/jrsDzSnBM/Y5vs7wx9Sk+4WPZ12WRIaGME
         rMcWw0d28ABfxzHqj9uGJnWazp9N0n2x3xRsf/PVd99DBmWtGVuThLP8z59aLQz/DM5N
         MHPIFf5H36QGTctMmVxpHcFBjd7bRerrHnlqoy5DHSssN2DTukR3eXmhCBVPhBUmMyCm
         pd5Q==
X-Gm-Message-State: AOAM5311mTcIgvZZzpFnjUqKpwzqmxW5JoVnnaY0qzD2shtkUrFIGQJm
	GJGwRWBbBC8VCO4Pp1Ta02LgmUzEtXhorJPukc+JBA==
X-Google-Smtp-Source: ABdhPJz+jFXZsqQZ/gZaDxbc92zc/Y1j4Ft80o1VnMYNl6dPXIcaIjMkAG6+B7QQk+6/6e1OSlMA19PSKXwEaEfrwuU=
X-Received: by 2002:a17:902:9b95:b0:130:6a7b:4570 with SMTP id
 y21-20020a1709029b9500b001306a7b4570mr2784453plp.27.1629428479249; Thu, 19
 Aug 2021 20:01:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-8-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210816060359.1442450-8-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Aug 2021 20:01:08 -0700
Message-ID: <CAPcyv4jbi=p=SjFYZcHnEAu+KY821pW_k_yA5u6hya4jEfrTUg@mail.gmail.com>
Subject: Re: [PATCH v7 7/8] fsdax: Introduce dax_iomap_ops for end of reflink
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, 
	david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> After writing data, reflink requires end operations to remap those new
> allocated extents.  The current ->iomap_end() ignores the error code
> returned from ->actor(), so we introduce this dax_iomap_ops and change
> the dax_iomap_*() interfaces to do this job.
>
> - the dax_iomap_ops contains the original struct iomap_ops and fsdax
>     specific ->actor_end(), which is for the end operations of reflink
> - also introduce dax specific zero_range, truncate_page
> - create new dax_iomap_ops for ext2 and ext4
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c               | 68 +++++++++++++++++++++++++++++++++++++-----
>  fs/ext2/ext2.h         |  3 ++
>  fs/ext2/file.c         |  6 ++--
>  fs/ext2/inode.c        | 11 +++++--
>  fs/ext4/ext4.h         |  3 ++
>  fs/ext4/file.c         |  6 ++--
>  fs/ext4/inode.c        | 13 ++++++--
>  fs/iomap/buffered-io.c |  3 +-
>  fs/xfs/xfs_bmap_util.c |  3 +-
>  fs/xfs/xfs_file.c      |  8 ++---
>  fs/xfs/xfs_iomap.c     | 36 +++++++++++++++++++++-
>  fs/xfs/xfs_iomap.h     | 33 ++++++++++++++++++++
>  fs/xfs/xfs_iops.c      |  7 ++---
>  fs/xfs/xfs_reflink.c   |  3 +-
>  include/linux/dax.h    | 21 ++++++++++---
>  include/linux/iomap.h  |  1 +
>  16 files changed, 189 insertions(+), 36 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 74dd918cff1f..0e0536765a7e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1348,11 +1348,30 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>         return done ? done : ret;
>  }
>
> +static inline int
> +__dax_iomap_iter(struct iomap_iter *iter, const struct dax_iomap_ops *ops)
> +{
> +       int ret;
> +
> +       /*
> +        * Call dax_iomap_ops->actor_end() before iomap_ops->iomap_end() in
> +        * each iteration.
> +        */
> +       if (iter->iomap.length && ops->actor_end) {
> +               ret = ops->actor_end(iter->inode, iter->pos, iter->len,
> +                                    iter->processed);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return iomap_iter(iter, &ops->iomap_ops);

This reorganization looks needlessly noisy. Why not require the
iomap_end operation to perform the actor_end work. I.e. why can't
xfs_dax_write_iomap_actor_end() just be the passed in iomap_end? I am
not seeing where the ->iomap_end() result is ignored?
