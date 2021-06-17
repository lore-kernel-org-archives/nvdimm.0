Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1771
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 07:04:25 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id e33so4192748pgm.3
        for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 00:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LDO+ysM0sZT13J4jvjx62XJsQjzELPOWU0d8eft8zqE=;
        b=MSYHsRMV+YBgrqCmtspIiBHsjVSnp8q2rrU7xIz1exEHNDD8d7ZXVFDAiYBGzUTszU
         oxWDRoOSLJRRil8r0ifAAGjL5CWEnd/9F61h67dMi34JsBfVO0VLMQtf5+pezRqLC5go
         PZTK6NzMCmnsv6Qee5K86hnFigHdQ1dgeZcQIuVrdFW0XhnCWNCv6gPMF5NyGFHxeSL2
         dMEKiaeQr/vUpglRZ2etWHZYLgOnrHHZEM97IasJ8/tLkV4naYw1TegZMq93k1Ibrwf3
         nx7W6YkErqI+becB9QtyiVW1SHmC8nzieD38fWwyhux5OnGh/tqoZ0JbbhUCgYq1ZMiH
         JyTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LDO+ysM0sZT13J4jvjx62XJsQjzELPOWU0d8eft8zqE=;
        b=ah1IRpxkBjo3NledQLkT3tSVT74XsOBuXf25DM37VIgDeBlQMw8MmAlcrgnAno0dCr
         b+NPFNr7r6B5s3qKe8nw5pEfA7ZGwWwhYhRlj+aR610wtDCZNE0Kn+ZuZLjImLyx1dkc
         W7++aT+YXXfUE3w/Uu+IgWCEQpFjnjN2jQAvbfe3XjOKfAuyNUPcMeUz46rLCowuaWWN
         9NIzgsf5qLSD4cSj0pH9ZnYzfqCdG9/Bb1qn1oH3kuJsZ5dKH5InrBHo5ATTMk+Mon8G
         9XHeUaVblFH2EAH8teH2DFUd/T18Q/B53iIArfs4hmX3muiwPvFWQmoTvlxU/DnaPPtf
         3+oA==
X-Gm-Message-State: AOAM532vC5FHGicKoe1eJ5i1su5U/4nUl+daF0+lSMQ5FV0O2oglnc40
	+gq3M+e+Gi+IDXVurdEle5GomxbFYjrIADapf/W8Mw==
X-Google-Smtp-Source: ABdhPJytJXCfpu88GCMpLd2JmLVLvndI0iUm974A4Uf+gWPRlWE3qUqN/z2XXe284KMMKTo0F5nBS9HRMjP/H8ccbSA=
X-Received: by 2002:a62:768c:0:b029:2ff:2002:d3d0 with SMTP id
 r134-20020a62768c0000b02902ff2002d3d0mr324838pfc.70.1623913464979; Thu, 17
 Jun 2021 00:04:24 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
 <20210604011844.1756145-4-ruansy.fnst@fujitsu.com> <CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
 <OSBPR01MB29203DC17C538F7B1B1C9224F40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB29203DC17C538F7B1B1C9224F40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 Jun 2021 00:04:14 -0700
Message-ID: <CAPcyv4ihuErfVWHL0F1OExQashutJjBdaLn5X5oPm44OkQ+a_A@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for superblock
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 16, 2021 at 11:51 PM ruansy.fnst@fujitsu.com
<ruansy.fnst@fujitsu.com> wrote:
>
> > -----Original Message-----
> > From: Dan Williams <dan.j.williams@intel.com>
> > Subject: Re: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for sup=
erblock
> >
> > [ drop old linux-nvdimm@lists.01.org, add nvdimm@lists.linux.dev ]
> >
> > On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> w=
rote:
> > >
> > > Memory failure occurs in fsdax mode will finally be handled in
> > > filesystem.  We introduce this interface to find out files or metadat=
a
> > > affected by the corrupted range, and try to recover the corrupted dat=
a
> > > if possiable.
> > >
> > > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > > ---
> > >  include/linux/fs.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h index
> > > c3c88fdb9b2a..92af36c4225f 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -2176,6 +2176,8 @@ struct super_operations {
> > >                                   struct shrink_control *);
> > >         long (*free_cached_objects)(struct super_block *,
> > >                                     struct shrink_control *);
> > > +       int (*corrupted_range)(struct super_block *sb, struct block_d=
evice
> > *bdev,
> > > +                              loff_t offset, size_t len, void *data)=
;
> >
> > Why does the superblock need a new operation? Wouldn't whatever functio=
n is
> > specified here just be specified to the dax_dev as the
> > ->notify_failure() holder callback?
>
> Because we need to find out which file is effected by the given poison pa=
ge so that memory-failure code can do collect_procs() and kill_procs() jobs=
.  And it needs filesystem to use its rmap feature to search the file from =
a given offset.  So, we need this implemented by the specified filesystem a=
nd called by dax_device's holder.
>
> This is the call trace I described in cover letter:
> memory_failure()
>  * fsdax case
>  pgmap->ops->memory_failure()      =3D> pmem_pgmap_memory_failure()
>   dax_device->holder_ops->corrupted_range() =3D>
>                                       - fs_dax_corrupted_range()
>                                       - md_dax_corrupted_range()
>    sb->s_ops->currupted_range()    =3D> xfs_fs_corrupted_range()  <=3D=3D=
 **HERE**
>     xfs_rmap_query_range()
>      xfs_currupt_helper()
>       * corrupted on metadata
>           try to recover data, call xfs_force_shutdown()
>       * corrupted on file data
>           try to recover data, call mf_dax_kill_procs()
>  * normal case
>  mf_generic_kill_procs()
>
> As you can see, this new added operation is an important for the whole pr=
ogress.

I don't think you need either fs_dax_corrupted_range() nor
sb->s_ops->corrupted_range(). In fact that fs_dax_corrupted_range()
looks broken because the filesystem may not even be mounted on the
device associated with the error. The holder_data and holder_op should
be sufficient from communicating the stack of notifications:

pgmap->notify_memory_failure() =3D> pmem_pgmap_notify_failure()
pmem_dax_dev->holder_ops->notify_failure(pmem_dax_dev) =3D>
md_dax_notify_failure()
md_dax_dev->holder_ops->notify_failure() =3D> xfs_notify_failure()

I.e. the entire chain just walks dax_dev holder ops.
