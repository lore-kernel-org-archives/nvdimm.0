Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286073FC4
	for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 21:26:04 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id y11so6717543pfl.13
        for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 14:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/+4vlEEAudVfYKUxZZmR1avsO58lGkEG6r6/9NuzjB0=;
        b=GcootYiu+qyxArUabMdyG4IqWavV54aowLk08BBPIEnlK8+EEnyz2Bs9Qnyj904R1y
         CDw1eNTKzCN1HRYVOZcRLRkEzYQJvTk8BVLomrVdsGdzpC/6+mu2O7s0aw9t0HSNz/Vk
         dNCZGdNuQGrc6TFoTfjjgkoo5o3Rksm1CsPDr9M+sHd39KqY4ienvwG+7Dy0+/0y2afH
         Ac2F+zF07AdKz98cxb6pEDDT0S8m7FnHMVdaL5pqJ6Upe/xwN5twWY1e+3bhwdKLEf5m
         8J7hqUFL0m9NzK3HDH0h6NFjdtBiEPOB9C7CAMh0xZXBrF9hxNS4/fEF9TG/n6LeGNnT
         N6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/+4vlEEAudVfYKUxZZmR1avsO58lGkEG6r6/9NuzjB0=;
        b=qq6kZPW1vTb8LwSQcC++0bibG1sj9Q85Ybfm8i6rvY2CJoUEJJWCDgatwkHIvxkDQX
         MTJWPBtpb62rUuLnA4J43l5atQoaTvJbPqggo1KlnPOhaEQNEv/DfePjam66d0/jlaoJ
         YGtS0py0JA5QJKf4I77uhkEz4sykaoxm6jhVDmaz/iKFXNhDtvn/Jeerao+K4AO5zlbP
         c7DjNS04nt4kmaWDr6RvoQzPU6KXW4JQ4ZQOGs0u16B0CiBa21apkhJT6D0XfAl6esKU
         pgVipnhcRQl5Rx5OTUMvBEnpP0zTgqHIpIvHttSM7fXHZIQBs418V/iQvaTHYSQGp4QP
         6uaw==
X-Gm-Message-State: AOAM530RFvohI9dBCF2y2MLEeBaAbgpSNjmidOiqT99K18EMx8XV38ek
	BHzOqEWsOR0XgFciOlSEXKREsy/g6MJpyZOunRscpw==
X-Google-Smtp-Source: ABdhPJzKZYtlwFa7VXvyk4oUfNnz7UdFBAgEuwiVTYzP34GSZ6p0NdAO9joIfVAHSnYYO/DjZcvseW3kcO9yjw3n+I0=
X-Received: by 2002:a63:311:: with SMTP id 17mr15597460pgd.450.1629408363613;
 Thu, 19 Aug 2021 14:26:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de>
In-Reply-To: <20210809061244.1196573-12-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Aug 2021 14:25:52 -0700
Message-ID: <CAPcyv4hbSYnOC6Pdi1QShRxGjBAteig7nN1h-5cEvsFDX9SuAQ@mail.gmail.com>
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 8, 2021 at 11:23 PM Christoph Hellwig <hch@lst.de> wrote:
>
> The iomap_iter struct provides a convenient way to package up and
> maintain all the arguments to the various mapping and operation
> functions.  It is operated on using the iomap_iter() function that
> is called in loop until the whole range has been processed.  Compared
> to the existing iomap_apply() function this avoid an indirect call
> for each iteration.
>
> For now iomap_iter() calls back into the existing ->iomap_begin and
> ->iomap_end methods, but in the future this could be further optimized
> to avoid indirect calls entirely.
>
> Based on an earlier patch from Matthew Wilcox <willy@infradead.org>.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/Makefile     |  1 +
>  fs/iomap/core.c       | 79 +++++++++++++++++++++++++++++++++++++++++++
>  fs/iomap/trace.h      | 37 +++++++++++++++++++-
>  include/linux/iomap.h | 56 ++++++++++++++++++++++++++++++
>  4 files changed, 172 insertions(+), 1 deletion(-)
>  create mode 100644 fs/iomap/core.c
>
> diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
> index eef2722d93a183..6b56b10ded347a 100644
> --- a/fs/iomap/Makefile
> +++ b/fs/iomap/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_FS_IOMAP)                += iomap.o
>
>  iomap-y                                += trace.o \
>                                    apply.o \
> +                                  core.o \
>                                    buffered-io.o \
>                                    direct-io.o \
>                                    fiemap.o \
> diff --git a/fs/iomap/core.c b/fs/iomap/core.c
> new file mode 100644
> index 00000000000000..89a87a1654e8e6
> --- /dev/null
> +++ b/fs/iomap/core.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021 Christoph Hellwig.
> + */
> +#include <linux/fs.h>
> +#include <linux/iomap.h>
> +#include "trace.h"
> +
> +static inline int iomap_iter_advance(struct iomap_iter *iter)
> +{
> +       /* handle the previous iteration (if any) */
> +       if (iter->iomap.length) {
> +               if (iter->processed <= 0)
> +                       return iter->processed;
> +               if (WARN_ON_ONCE(iter->processed > iomap_length(iter)))
> +                       return -EIO;
> +               iter->pos += iter->processed;
> +               iter->len -= iter->processed;
> +               if (!iter->len)
> +                       return 0;
> +       }
> +
> +       /* clear the state for the next iteration */
> +       iter->processed = 0;
> +       memset(&iter->iomap, 0, sizeof(iter->iomap));
> +       memset(&iter->srcmap, 0, sizeof(iter->srcmap));
> +       return 1;
> +}
> +
> +static inline void iomap_iter_done(struct iomap_iter *iter)
> +{
> +       WARN_ON_ONCE(iter->iomap.offset > iter->pos);
> +       WARN_ON_ONCE(iter->iomap.length == 0);
> +       WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos);
> +
> +       trace_iomap_iter_dstmap(iter->inode, &iter->iomap);
> +       if (iter->srcmap.type != IOMAP_HOLE)
> +               trace_iomap_iter_srcmap(iter->inode, &iter->srcmap);

Given most of the iomap_iter users don't care about srcmap, i.e. are
not COW cases, they are leaving srcmap zero initialized. Should the
IOMAP types be incremented by one so that there is no IOMAP_HOLE
confusion? In other words, fold something like this?

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 479c1da3e221..b9c62d0909b0 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -21,14 +21,23 @@ struct page;
 struct vm_area_struct;
 struct vm_fault;

-/*
- * Types of block ranges for iomap mappings:
+/**
+ * enum iomap_type - Types of block ranges for iomap mappings
+ * @IOMAP_NONE: invalid iomap
+ * @IOMAP_HOLE: no blocks allocated, need allocation
+ * @IOMAP_DELALLOC: delayed allocation blocks
+ * @IOMAP_MAPPED: blocks allocated at @addr
+ * @IOMAP_UNWRITTEN: blocks allocated at @addr in unwritten state
+ * @IOMAP_INLINE: data inline in the inode
  */
-#define IOMAP_HOLE     0       /* no blocks allocated, need allocation */
-#define IOMAP_DELALLOC 1       /* delayed allocation blocks */
-#define IOMAP_MAPPED   2       /* blocks allocated at @addr */
-#define IOMAP_UNWRITTEN        3       /* blocks allocated at @addr
in unwritten state */
-#define IOMAP_INLINE   4       /* data inline in the inode */
+enum iomap_type {
+       IOMAP_NONE = 0,
+       IOMAP_HOLE,
+       IOMAP_DELALLOC
+       IOMAP_MAPPED,
+       IOMAP_UNWRITTEN,
+       IOMAP_INLINE,
+};

 /*
  * Flags reported by the file system from iomap_begin:


> +}
> +
> +/**
> + * iomap_iter - iterate over a ranges in a file
> + * @iter: iteration structue

s/structue/structure/

Other than the minor stuff above, looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
