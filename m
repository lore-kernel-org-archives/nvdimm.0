Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2C87B
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 02:06:51 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id bx5so535354pjb.3
        for <nvdimm@lists.linux.dev>; Tue, 12 Apr 2022 19:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0MNiYyg47Q/lgq+p2TnJidv+4v97sJVTq+BwgFSq+VQ=;
        b=Lpgu/kIIY6OTgkq6DK8AGceWu1W0JSwkDntRla5RelvUGWpCef4ixTRLk0CeQg8uh+
         FOdDJCUfB9Gum6HLdD0Qv54dDadV8PRLhEpwklqG9/ZxLMK2ggaz8YeybLNI2CmXSQaB
         CIzPn8mr7GfABn6kfFCNd0FvU1OjjKt+1d1ZWBZNl6HXGN0xetQzhaTyw1kRDVF3a1VT
         U7mV2jnhRXrgYDedNMRbb0cBKmZb0sx8bXXilHxQQHeS3ikfhZESBiLkrjEasqxrSKKm
         z94G3RWuGw9aL9Za7IFByAm9JWMkqZauiXIex4BhIZ933SiUEodMsIXWevWOXUYXfT7s
         OcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0MNiYyg47Q/lgq+p2TnJidv+4v97sJVTq+BwgFSq+VQ=;
        b=SL9IsJrryA/yTZ4WolOWg/JGFdsgeJ6cJipPlAkCU8hEklzB0RlLzeajAMjrtVHJeK
         709jDMNW1X8tofyypXA2j89zyaZX0h6jWVimuJ6LRYUfRfa1QwEEYYIpx/+FPMLDdRzm
         qMuIhHsGQDNSQeuObc9wj2uRiZU93zK8hFK36xhkVzLT5jDy38/Owa0P24UKPpUA2pjj
         3S18+FVaikwIuUA4FFsHQaIrgQgv82LgpQtZv87Ls+zKVqw6UqC5ti741PLvfoTKWbxp
         IYAowhdPKmiYPtePIzGpvzbbftZ3vN2bsJXQC/S7mTSgVPT77q4u84o4lTWPEyRCkubq
         7a5A==
X-Gm-Message-State: AOAM533ijkRva6po3pClZofTUwdTiACaA8NxzFqOMCBVFxyI6nIYX0sn
	3IxGO9h+y+cScPPC9yzUnFMFMwvaeU/qBSwOb5NYlw==
X-Google-Smtp-Source: ABdhPJxWw5xA7X5gjbLtdUOG67b6VL4topnpS9iw/C6hutLuDw/UuVcok1a0F93UlSgXX0Iq41Uluo4OCw+GE3qP/QE=
X-Received: by 2002:a17:902:eb92:b0:158:4cc9:698e with SMTP id
 q18-20020a170902eb9200b001584cc9698emr17120666plg.147.1649815611069; Tue, 12
 Apr 2022 19:06:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-7-ruansy.fnst@fujitsu.com> <20220413000423.GK1544202@dread.disaster.area>
In-Reply-To: <20220413000423.GK1544202@dread.disaster.area>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Apr 2022 19:06:40 -0700
Message-ID: <CAPcyv4jKLZhcCiSEU+O+OJ2e+y9_B2CvaEfAKyBnhhSd+da=Zg@mail.gmail.com>
Subject: Re: [PATCH v12 6/7] xfs: Implement ->notify_failure() for XFS
To: Dave Chinner <david@fromorbit.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 12, 2022 at 5:04 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Apr 11, 2022 at 12:09:03AM +0800, Shiyang Ruan wrote:
> > Introduce xfs_notify_failure.c to handle failure related works, such as
> > implement ->notify_failure(), register/unregister dax holder in xfs, and
> > so on.
> >
> > If the rmap feature of XFS enabled, we can query it to find files and
> > metadata which are associated with the corrupt data.  For now all we do
> > is kill processes with that file mapped into their address spaces, but
> > future patches could actually do something about corrupt metadata.
> >
> > After that, the memory failure needs to notify the processes who are
> > using those files.
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >  fs/xfs/Makefile             |   5 +
> >  fs/xfs/xfs_buf.c            |   7 +-
> >  fs/xfs/xfs_fsops.c          |   3 +
> >  fs/xfs/xfs_mount.h          |   1 +
> >  fs/xfs/xfs_notify_failure.c | 219 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_super.h          |   1 +
> >  6 files changed, 233 insertions(+), 3 deletions(-)
> >  create mode 100644 fs/xfs/xfs_notify_failure.c
> >
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 04611a1068b4..09f5560e29f2 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -128,6 +128,11 @@ xfs-$(CONFIG_SYSCTL)             += xfs_sysctl.o
> >  xfs-$(CONFIG_COMPAT)         += xfs_ioctl32.o
> >  xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)     += xfs_pnfs.o
> >
> > +# notify failure
> > +ifeq ($(CONFIG_MEMORY_FAILURE),y)
> > +xfs-$(CONFIG_FS_DAX)         += xfs_notify_failure.o
> > +endif
> > +
> >  # online scrub/repair
> >  ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
> >
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index f9ca08398d32..9064b8dfbc66 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -5,6 +5,7 @@
> >   */
> >  #include "xfs.h"
> >  #include <linux/backing-dev.h>
> > +#include <linux/dax.h>
> >
> >  #include "xfs_shared.h"
> >  #include "xfs_format.h"
> > @@ -1911,7 +1912,7 @@ xfs_free_buftarg(
> >       list_lru_destroy(&btp->bt_lru);
> >
> >       blkdev_issue_flush(btp->bt_bdev);
> > -     fs_put_dax(btp->bt_daxdev, NULL);
> > +     fs_put_dax(btp->bt_daxdev, btp->bt_mount);
> >
> >       kmem_free(btp);
> >  }
> > @@ -1964,8 +1965,8 @@ xfs_alloc_buftarg(
> >       btp->bt_mount = mp;
> >       btp->bt_dev =  bdev->bd_dev;
> >       btp->bt_bdev = bdev;
> > -     btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off, NULL,
> > -                                         NULL);
> > +     btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off, mp,
> > +                                         &xfs_dax_holder_operations);
>
> I see a problem with this: we are setting up notify callbacks before
> we've even read in the superblock during mount. i.e. we don't even
> kow yet if we've got an XFS filesystem on this block device.
>
> Hence if we get a notification immediately after registering this
> notification callback....
>
> [...]
>
> > +
> > +static int
> > +xfs_dax_notify_ddev_failure(
> > +     struct xfs_mount        *mp,
> > +     xfs_daddr_t             daddr,
> > +     xfs_daddr_t             bblen,
> > +     int                     mf_flags)
> > +{
> > +     struct xfs_trans        *tp = NULL;
> > +     struct xfs_btree_cur    *cur = NULL;
> > +     struct xfs_buf          *agf_bp = NULL;
> > +     int                     error = 0;
> > +     xfs_fsblock_t           fsbno = XFS_DADDR_TO_FSB(mp, daddr);
> > +     xfs_agnumber_t          agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > +     xfs_fsblock_t           end_fsbno = XFS_DADDR_TO_FSB(mp, daddr + bblen);
> > +     xfs_agnumber_t          end_agno = XFS_FSB_TO_AGNO(mp, end_fsbno);
>
> .... none of this code is going to function correctly because it
> is dependent on the superblock having been read, validated and
> copied to the in-memory superblock.
>
> > +     error = xfs_trans_alloc_empty(mp, &tp);
> > +     if (error)
> > +             return error;
>
> ... and it's not valid to use transactions (even empty ones) before
> log recovery has completed and set the log up correctly.
>
> > +
> > +     for (; agno <= end_agno; agno++) {
> > +             struct xfs_rmap_irec    ri_low = { };
> > +             struct xfs_rmap_irec    ri_high;
> > +             struct failure_info     notify;
> > +             struct xfs_agf          *agf;
> > +             xfs_agblock_t           agend;
> > +
> > +             error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
> > +             if (error)
> > +                     break;
> > +
> > +             cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, agf_bp->b_pag);
>
> ... and none of the structures this rmapbt walk is dependent on
> (e.g. perag structures) have been initialised yet so there's null
> pointer dereferences going to happen here.
>
> Perhaps even worse is that the rmapbt is not guaranteed to be in
> consistent state until after log recovery has completed, so this
> walk could get stuck forever in a stale on-disk cycle that
> recovery would have corrected....
>
> Hence these notifications need to be delayed until after the
> filesystem is mounted, all the internal structures have been set up
> and log recovery has completed.

So I think this gets back to the fact that there will eventually be 2
paths into this notifier. One will be the currently proposed
synchronous / CPU-consumes-poison while accessing the filesystem
(potentially even while recovery is running), and another will be in
response to some asynchronous background scanning. I am thinking that
the latter would be driven from a userspace daemon reconciling
background scan events and notifying the filesystem and any other
interested party.

All that to say, I think it is ok / expected for the filesystem to
drop notifications on the floor when it is not ready to handle them.
For example there are no processes to send SIGBUS to if the filesystem
has not even finished mount. It is then up to userspace to replay any
relevant error notifications that may be pending after mount completes
to sync the filesystem with the current state of the hardware.
