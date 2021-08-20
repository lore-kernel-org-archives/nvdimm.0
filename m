Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665D23FC2
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 15:18:56 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so7462164pjb.3
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 08:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e7Os9VAnizBXv51HC/2jWtdqVC6IT3MX2PEly7Hzllc=;
        b=M+ibRtOTQAZRmC0FnL3AMilGRh2mUgMJmWUfg9JNOtAKXFs9lFLPXucpaO7ELUpNDb
         EGbzGydfkHCtIjzQLeNz+1/fIOA2rFhRJv3yC4ZhYvpISJH4iNfkhazi5Hz/Nq0fpYXO
         QpGdn8L+8PdTFb0E+p78qZDHRXkUnXo7JNSYlGQecnF0IhE5VtdC/Y+7Y9yUsL+y7PV3
         5x4ObvPPy0AxrVohJG1gL8vPnbME69k1gCKAA1GyMrEqgR+PWW/PMthly7voCniXVW59
         FcwvvH0AWzl2X+1XFpdijT2XoPDvNcAXBc2pyggbrImBdT+vil40sbH7g0dNEEtf0bPA
         hjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e7Os9VAnizBXv51HC/2jWtdqVC6IT3MX2PEly7Hzllc=;
        b=k/qk1PTxsFGw3jj1nyMSjAVVn7BzaNKy7qyI2uX70UZDWkjyws4xCdriRQVLzL3tFH
         clq2wDEePpExgKC+EWBqr73O5EYRRwx4OPrzj6JkWFhkoIaFR8BCyi/7KcfhvnFhrtpj
         +QfRVu1BQya83IBa/OFcAtxkPU5tG9k7EfruApCoFanoUvft26HyTHs/B7ZQPAwdCB7E
         CX90yhl2sC2kBxWMzska6Mo67MLT9LXFI4RTjxhjmv2Zp1Te5cRZPo9d33cPQW9qbaOj
         9RNYsebTWsaA/fxvo5Zop7ctdmsmn27CMvnIEJDXEy9p2tuLT0HSbyDtNbc42/QkbK3s
         yuWg==
X-Gm-Message-State: AOAM533m3mXbzhPovhyDYrltcQbMP5rGYLMt8c1T/5p9+MBNUsXpL/ZE
	VS82T55RdnUFpxT/M3ocsae1DMhAM1okQs2Gl8duSA==
X-Google-Smtp-Source: ABdhPJzh0Gic3915Mh1iFhrG9Et6Tc2pawPckB/akGEtXtIixYmIi3AnAExi5rU0t9vJgG3HUdy+9gqyxaTkb99WGQ0=
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr5224172pjk.13.1629472735668;
 Fri, 20 Aug 2021 08:18:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-8-ruansy.fnst@fujitsu.com> <CAPcyv4jbi=p=SjFYZcHnEAu+KY821pW_k_yA5u6hya4jEfrTUg@mail.gmail.com>
 <c7e68dc8-5a43-f727-c262-58dcf244c711@fujitsu.com>
In-Reply-To: <c7e68dc8-5a43-f727-c262-58dcf244c711@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 08:18:44 -0700
Message-ID: <CAPcyv4jM86gy-T5EEZf6M2m44v4MiGqYDhxisX59M5QJii6DVg@mail.gmail.com>
Subject: Re: [PATCH v7 7/8] fsdax: Introduce dax_iomap_ops for end of reflink
To: "ruansy.fnst" <ruansy.fnst@fujitsu.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, 
	david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 2021 at 11:13 PM ruansy.fnst <ruansy.fnst@fujitsu.com> wrot=
e:
>
>
>
> On 2021/8/20 =E4=B8=8A=E5=8D=8811:01, Dan Williams wrote:
> > On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com>=
 wrote:
> >>
> >> After writing data, reflink requires end operations to remap those new
> >> allocated extents.  The current ->iomap_end() ignores the error code
> >> returned from ->actor(), so we introduce this dax_iomap_ops and change
> >> the dax_iomap_*() interfaces to do this job.
> >>
> >> - the dax_iomap_ops contains the original struct iomap_ops and fsdax
> >>      specific ->actor_end(), which is for the end operations of reflin=
k
> >> - also introduce dax specific zero_range, truncate_page
> >> - create new dax_iomap_ops for ext2 and ext4
> >>
> >> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> >> ---
> >>   fs/dax.c               | 68 +++++++++++++++++++++++++++++++++++++---=
--
> >>   fs/ext2/ext2.h         |  3 ++
> >>   fs/ext2/file.c         |  6 ++--
> >>   fs/ext2/inode.c        | 11 +++++--
> >>   fs/ext4/ext4.h         |  3 ++
> >>   fs/ext4/file.c         |  6 ++--
> >>   fs/ext4/inode.c        | 13 ++++++--
> >>   fs/iomap/buffered-io.c |  3 +-
> >>   fs/xfs/xfs_bmap_util.c |  3 +-
> >>   fs/xfs/xfs_file.c      |  8 ++---
> >>   fs/xfs/xfs_iomap.c     | 36 +++++++++++++++++++++-
> >>   fs/xfs/xfs_iomap.h     | 33 ++++++++++++++++++++
> >>   fs/xfs/xfs_iops.c      |  7 ++---
> >>   fs/xfs/xfs_reflink.c   |  3 +-
> >>   include/linux/dax.h    | 21 ++++++++++---
> >>   include/linux/iomap.h  |  1 +
> >>   16 files changed, 189 insertions(+), 36 deletions(-)
> >>
> >> diff --git a/fs/dax.c b/fs/dax.c
> >> index 74dd918cff1f..0e0536765a7e 100644
> >> --- a/fs/dax.c
> >> +++ b/fs/dax.c
> >> @@ -1348,11 +1348,30 @@ static loff_t dax_iomap_iter(const struct ioma=
p_iter *iomi,
> >>          return done ? done : ret;
> >>   }
> >>
> >> +static inline int
> >> +__dax_iomap_iter(struct iomap_iter *iter, const struct dax_iomap_ops =
*ops)
> >> +{
> >> +       int ret;
> >> +
> >> +       /*
> >> +        * Call dax_iomap_ops->actor_end() before iomap_ops->iomap_end=
() in
> >> +        * each iteration.
> >> +        */
> >> +       if (iter->iomap.length && ops->actor_end) {
> >> +               ret =3D ops->actor_end(iter->inode, iter->pos, iter->l=
en,
> >> +                                    iter->processed);
> >> +               if (ret < 0)
> >> +                       return ret;
> >> +       }
> >> +
> >> +       return iomap_iter(iter, &ops->iomap_ops);
> >
> > This reorganization looks needlessly noisy. Why not require the
> > iomap_end operation to perform the actor_end work. I.e. why can't
> > xfs_dax_write_iomap_actor_end() just be the passed in iomap_end? I am
> > not seeing where the ->iomap_end() result is ignored?
> >
>
> The V6 patch[1] was did in this way.
> [1]https://lore.kernel.org/linux-xfs/20210526005159.GF202144@locust/T/#m7=
9a66a928da2d089e2458c1a97c0516dbfde2f7f
>
> But Darrick reminded me that ->iomap_end() will always take zero or
> positive 'written' because iomap_apply() handles this argument.
>
> ```
>         if (ops->iomap_end) {
>                 ret =3D ops->iomap_end(inode, pos, length,
>                                      written > 0 ? written : 0,
>                                      flags, &iomap);
>         }
> ```
>
> So, we cannot get actual return code from CoW in ->actor(), and as a
> result, we cannot handle the xfs end_cow correctly in ->iomap_end().
> That's where the result of CoW was ignored.

Ah, thank you for the explanation.

However, this still seems like too much code thrash just to get back
to the original value of iter->processed. I notice you are talking
about iomap_apply(), but that routine is now gone in Darrick's latest
iomap-for-next branch. Instead iomap_iter() does this:

        if (iter->iomap.length && ops->iomap_end) {
                ret =3D ops->iomap_end(iter->inode, iter->pos, iomap_length=
(iter),
                                iter->processed > 0 ? iter->processed : 0,
                                iter->flags, &iter->iomap);
                if (ret < 0 && !iter->processed)
                        return ret;
        }


I notice that the @iomap argument to ->iomap_end() is reliably coming
from @iter. So you could do the following in your iomap_end()
callback:

        struct iomap_iter *iter =3D container_of(iomap, typeof(*iter), ioma=
p);
        struct xfs_inode *ip =3D XFS_I(inode);
        ssize_t written =3D iter->processed;
        bool cow =3D xfs_is_cow_inode(ip);

        if (cow) {
                if (written <=3D 0)
                        xfs_reflink_cancel_cow_range(ip, pos, length, true)
        }
