Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7763FC3
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 05:04:27 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so4030196pjt.0
        for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 22:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nFc3sdoCByIwYxggk+AQ1a3lDorwtem5TNHN34NU5Jc=;
        b=LgiKD4Zo3v0mLVNslAx3ru3XtLkSlizC6BQHy54CHr1TxM3DHOu8L6d9ohwdHl5jFZ
         LkcpZVu3aeWV1BX8/WFgZg1yawyzpq8FRD5EBw7PgkylUIhyTGYix6wr2qwhNnngONqR
         0KEMJ1c1HG4X4r9v8ML+NuRn40w61WyyPUGqLvzFkC62+nmMKhUUfuMWrU18/421ViQw
         qFNP/c7LIRCkO8UxTd8/rAJ/bKWN642/FNsp6dFY0IbLVvkYKT9H1q/Fr2eYwf6Wktjf
         Nu3mNKm9t+SZYpDwmalLqn/R31CQX0b42gZapFrwVOZEwfLcUvhSXcOfnpyRdxw2a61t
         npiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nFc3sdoCByIwYxggk+AQ1a3lDorwtem5TNHN34NU5Jc=;
        b=ixRIAPuUrRkbow1AY/G3eOATKQ+8v4BhVlnjKk+xetyjDnPx+jZvjyiL8OPRz/gBde
         sBsp9MMyceeRkwWwNiR5mJIFEAcVYmkZwoPykEqgvE9RwFTa4PmrEm5qHm2KFRgZtlbt
         GtWh3ahWl8jeMhLYo8TtCqLLGvlmqtu1BIhxD3cfS6ammSD8mwh7eeKRYD6T2WLKOH4x
         I0SwE0iPvtsaM5azKuYwBwA5GcHqz/m7PDVdBtVR6/J0FPbYCBfBSiY4lmewZIwIUXTf
         Np7uQlxOTNAnzuEiK1ZQy52AOkeOrXdErbb0ooJE0DtoYhGRcdKCS2xJ9FIpDkEuN1uW
         7YbQ==
X-Gm-Message-State: AOAM531rP55P5d2hJT50z125IHr/5jW2K2xMX1KJaA3fhHa/Cqeb0guc
	N9h/i+jbwPgBTYHfWFFONyx5mZG173k4quX0yZ47RA==
X-Google-Smtp-Source: ABdhPJxvR/6WuE0nuMIGGz2Pojzx66g7oICbrEpMke2L3VvjgMUVihqBqiOP0icctaqTxFJqBEFwX39hG1MdjiOxRvM=
X-Received: by 2002:a17:902:e550:b0:137:734f:1d84 with SMTP id
 n16-20020a170902e55000b00137734f1d84mr6796413plf.27.1630040666934; Thu, 26
 Aug 2021 22:04:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-8-ruansy.fnst@fujitsu.com> <CAPcyv4jbi=p=SjFYZcHnEAu+KY821pW_k_yA5u6hya4jEfrTUg@mail.gmail.com>
 <c7e68dc8-5a43-f727-c262-58dcf244c711@fujitsu.com> <CAPcyv4jM86gy-T5EEZf6M2m44v4MiGqYDhxisX59M5QJii6DVg@mail.gmail.com>
 <32fa5333-b14e-2060-d659-d77f6c75ff16@fujitsu.com>
In-Reply-To: <32fa5333-b14e-2060-d659-d77f6c75ff16@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Aug 2021 22:04:16 -0700
Message-ID: <CAPcyv4h801eipbvOpzSnw_GnUcuSxcm6eUfJdoHNW2ZmZgzW=Q@mail.gmail.com>
Subject: Re: [PATCH v7 7/8] fsdax: Introduce dax_iomap_ops for end of reflink
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, 
	david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 26, 2021 at 8:30 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrot=
e:
>
>
>
> On 2021/8/20 23:18, Dan Williams wrote:
> > On Thu, Aug 19, 2021 at 11:13 PM ruansy.fnst <ruansy.fnst@fujitsu.com> =
wrote:
> >>
> >>
> >>
> >> On 2021/8/20 =E4=B8=8A=E5=8D=8811:01, Dan Williams wrote:
> >>> On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.co=
m> wrote:
> >>>>
> >>>> After writing data, reflink requires end operations to remap those n=
ew
> >>>> allocated extents.  The current ->iomap_end() ignores the error code
> >>>> returned from ->actor(), so we introduce this dax_iomap_ops and chan=
ge
> >>>> the dax_iomap_*() interfaces to do this job.
> >>>>
> >>>> - the dax_iomap_ops contains the original struct iomap_ops and fsdax
> >>>>       specific ->actor_end(), which is for the end operations of ref=
link
> >>>> - also introduce dax specific zero_range, truncate_page
> >>>> - create new dax_iomap_ops for ext2 and ext4
> >>>>
> >>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> >>>> ---
> >>>>    fs/dax.c               | 68 +++++++++++++++++++++++++++++++++++++=
-----
> >>>>    fs/ext2/ext2.h         |  3 ++
> >>>>    fs/ext2/file.c         |  6 ++--
> >>>>    fs/ext2/inode.c        | 11 +++++--
> >>>>    fs/ext4/ext4.h         |  3 ++
> >>>>    fs/ext4/file.c         |  6 ++--
> >>>>    fs/ext4/inode.c        | 13 ++++++--
> >>>>    fs/iomap/buffered-io.c |  3 +-
> >>>>    fs/xfs/xfs_bmap_util.c |  3 +-
> >>>>    fs/xfs/xfs_file.c      |  8 ++---
> >>>>    fs/xfs/xfs_iomap.c     | 36 +++++++++++++++++++++-
> >>>>    fs/xfs/xfs_iomap.h     | 33 ++++++++++++++++++++
> >>>>    fs/xfs/xfs_iops.c      |  7 ++---
> >>>>    fs/xfs/xfs_reflink.c   |  3 +-
> >>>>    include/linux/dax.h    | 21 ++++++++++---
> >>>>    include/linux/iomap.h  |  1 +
> >>>>    16 files changed, 189 insertions(+), 36 deletions(-)
> >>>>
> >>>> diff --git a/fs/dax.c b/fs/dax.c
> >>>> index 74dd918cff1f..0e0536765a7e 100644
> >>>> --- a/fs/dax.c
> >>>> +++ b/fs/dax.c
> >>>> @@ -1348,11 +1348,30 @@ static loff_t dax_iomap_iter(const struct io=
map_iter *iomi,
> >>>>           return done ? done : ret;
> >>>>    }
> >>>>
> >>>> +static inline int
> >>>> +__dax_iomap_iter(struct iomap_iter *iter, const struct dax_iomap_op=
s *ops)
> >>>> +{
> >>>> +       int ret;
> >>>> +
> >>>> +       /*
> >>>> +        * Call dax_iomap_ops->actor_end() before iomap_ops->iomap_e=
nd() in
> >>>> +        * each iteration.
> >>>> +        */
> >>>> +       if (iter->iomap.length && ops->actor_end) {
> >>>> +               ret =3D ops->actor_end(iter->inode, iter->pos, iter-=
>len,
> >>>> +                                    iter->processed);
> >>>> +               if (ret < 0)
> >>>> +                       return ret;
> >>>> +       }
> >>>> +
> >>>> +       return iomap_iter(iter, &ops->iomap_ops);
> >>>
> >>> This reorganization looks needlessly noisy. Why not require the
> >>> iomap_end operation to perform the actor_end work. I.e. why can't
> >>> xfs_dax_write_iomap_actor_end() just be the passed in iomap_end? I am
> >>> not seeing where the ->iomap_end() result is ignored?
> >>>
> >>
> >> The V6 patch[1] was did in this way.
> >> [1]https://lore.kernel.org/linux-xfs/20210526005159.GF202144@locust/T/=
#m79a66a928da2d089e2458c1a97c0516dbfde2f7f
> >>
> >> But Darrick reminded me that ->iomap_end() will always take zero or
> >> positive 'written' because iomap_apply() handles this argument.
> >>
> >> ```
> >>          if (ops->iomap_end) {
> >>                  ret =3D ops->iomap_end(inode, pos, length,
> >>                                       written > 0 ? written : 0,
> >>                                       flags, &iomap);
> >>          }
> >> ```
> >>
> >> So, we cannot get actual return code from CoW in ->actor(), and as a
> >> result, we cannot handle the xfs end_cow correctly in ->iomap_end().
> >> That's where the result of CoW was ignored.
> >
> > Ah, thank you for the explanation.
> >
> > However, this still seems like too much code thrash just to get back
> > to the original value of iter->processed. I notice you are talking
> > about iomap_apply(), but that routine is now gone in Darrick's latest
> > iomap-for-next branch. Instead iomap_iter() does this:
> >
> >          if (iter->iomap.length && ops->iomap_end) {
> >                  ret =3D ops->iomap_end(iter->inode, iter->pos, iomap_l=
ength(iter),
> >                                  iter->processed > 0 ? iter->processed =
: 0,
>
> As you can see, here is the same logic as the old iomap_apply(): the
> negative iter->processed won't be passed into ->iomap_end().
>
> >                                  iter->flags, &iter->iomap);
> >                  if (ret < 0 && !iter->processed)
> >                          return ret;
> >          }
> >
> >
> > I notice that the @iomap argument to ->iomap_end() is reliably coming
> > from @iter. So you could do the following in your iomap_end()
> > callback:
> >
> >          struct iomap_iter *iter =3D container_of(iomap, typeof(*iter),=
 iomap);
> >          struct xfs_inode *ip =3D XFS_I(inode);
> >          ssize_t written =3D iter->processed;
>
> The written will be 0 or positive.  The original error code is ingnored.

Correct, but you can use container_of() to get back to the iter and
consider the raw untranslated value of iter->processed. As Christoph
mentioned this needs a comment explaining the layering violation, but
that's a cleaner change than the dax_iomap_ops approach.
