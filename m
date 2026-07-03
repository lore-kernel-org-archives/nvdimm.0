Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD2518A6D4
	for <nvdimm@lists.linux.dev>; Fri,  3 Jul 2026 00:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783037837; cv=pass; b=B/iY/gGRlsXrYvgrOZuqxQGTMnTo+t8MABGv6oihfgyO1D8ycFEHMdUx04cjlwyUiGDt2yFbWgFElWO0lTvXlSRkxD+ZLvpDIcnMtrh6mZ6LVcBUfdMEP/uJnHdpMyS6ZZYMLHHTZJYom818ZUamTjjd4tgJ/1nidJSELY+/+i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783037837; c=relaxed/simple;
	bh=kRH5ME6cl2uOZNTf4Hz7cjp4HebVSYInnLBFWd3k8/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJpzDru+K6V2Ty2UduxCS4icX/94CQE7PSfQPcuqlaMd4QPCF796LNLYrBcLA8ekovTJJ4pmK4myqhKMUns9dLu2rcC5uqBxvzQqDz0l/R1E85uWe8g6g92DXXa1fWZ00160DB8H6EMZi2LCjvYFx/mL1ChJZNEB9UIZ2dGCAlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tBchV30U; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBchV30U"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso12080275e9.1
        for <nvdimm@lists.linux.dev>; Thu, 02 Jul 2026 17:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783037834; cv=none;
        d=google.com; s=arc-20260327;
        b=Zy8ktdSnsQUr5rmKHiPmZOKE+h7AE5rraLk99UtTmFUgYzYm0CDlGzTcWov3Q4bMAH
         +14Mijkq6ReqemwbYaSq4wAXZZbAc5MenWR/N0T+2cbrujOvkd+ntg8kBjWJ/eZhhCMp
         UgUzCkri+JNWPN+BYk8e6IwkkTKlD9cBf3qAm3fx+a7A+jUIOa5gy/fS9Fem1O2dZJqj
         t701R1U+lavTiK5MQCKHCC3am0i7UBYPpu3yU+cTlIRgvM09bP4IFIGll2l8eiW84bzk
         W9XyziBoPNFFHx84+vIBEb0O547340Xx0uFN/7S+L4MgRrQ4Nfc5xsjJhmX2dvDSUpcS
         S2ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vU7OEUrLlyve1bXZ6P0sGV5EAt2DQDqFHvcpp7wTUdg=;
        fh=Dj1ynHehHASBn0Ggct/pnOmw07zJIuN1tKK61CkrwxY=;
        b=pPi4avN77ylQzjblIeISwV42R6VBKHtChTrRugrUjE1iLtuzVuhyiiKX9Df1hnSBO4
         COSM9z7/LCsiAH7yxDFgGf3J0u3rGOgpRsKPUj7QRsTstyRkBmJ6LoLTLCP6qYs2GLof
         PRriCXnfyhUx544HFxcTBw1UI8IWVUs4PEycv2KsoRybHEo1bvm5HfcsQEIJYN44gPh4
         EYkvoe5jrV4+xeGA6lhoxoaWEWbiPDH1Y0BGGib4GLgyN32BH2hHs6wUknbMvsIzzZxX
         bNovb5DSB00qfp7IEXDfyaYEU9yVYxJLNCIkGZ2TV2oBGQwLusFSakekQwyrI+yBaWkH
         2pgg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783037834; x=1783642634; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vU7OEUrLlyve1bXZ6P0sGV5EAt2DQDqFHvcpp7wTUdg=;
        b=tBchV30Uub+P+NkFmtsnfZbLWBXKPtWYqaNFPV3tgiaS3MhvG8cHqkQriOkVS49D8J
         nf4V+ROheyi4afaZ+JaYHs15DqV6tnOKQ25Y/BAk2QIlT6jdiYb1M/B6x2Bva41FJDHp
         U/fy8ES7ElanDgMDDrFEAzXooxqppSUydwMMJrrJAQboJ7UulsH1HhKomSr1Elqd0elF
         y0mweFEjdU6A3z4CwySUiddgdFuwktOLfjNcIszkjBQG6ieTMErMAns+2CA6Woc0YKud
         QAiWb7sFYf5QNNKMRuehB1RmIKNpl/AwjrQvGhuSpX5jcNrmkLy7hxUQ5KuIvVKOlqRs
         ooPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783037834; x=1783642634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vU7OEUrLlyve1bXZ6P0sGV5EAt2DQDqFHvcpp7wTUdg=;
        b=i+TaCyddlkxOKQZ/fD8cCfj4ZmHR3ZRxsD4pryKUohSwU8uRjYpI9Ry0OvYIfh25d0
         WqAJZFEKBmzCP4k8b/6cV2gvI6b5PSB/LiQwigRat6KLFUjyh9Xz0JxQhr40JeS6mM1t
         cOycowYt/aweWSVoUQ0bf8YXrbqLr7cemUKM5X4N3xFGxYocnqmamRpsiezIDrN8yvXt
         cRLef2MAjD8IbLTCVmyijOCw68Naiw7Rg8UQxxAUVciv6IbZI+QVdbeYzfoxPtqKQm59
         oVLP1LEAeQhasaJOtsB/Dro3gSzesG11C9W1qDtwI4+8hve/jIk6s+ZcdQUUcwoyC0i2
         13dQ==
X-Forwarded-Encrypted: i=1; AFNElJ8yovHz8YFi2DLy9DHzhbJGD7JgIWmMOrmvN4ASAwt0Yuteh471Y7wMxlPThGR/DVuGCb8Rpfk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4c5bD5CKLx/JkeNiCWZE/g6kETO2t5Di1AziiNnutmxBUWwHo
	weGB/s+HbSSJ7yCb5jG0SjUfCY34X47ZBJlvb88ePYd6qwgUxAiGQTAF2CiR309A6J8dW+D8B80
	8bAe5HWOJ0Yd0wubAm+k3a2xKGyjqLvc=
X-Gm-Gg: AfdE7cmBnulqsVxdrQGe50WFwc14YhaOiM1eZfmMg+GiHlNtIuKu4abYf8gVBnq2MDC
	tVjv4CHI/Tv9m3w6u1H0ETURb9j0F3JWjYm3csMwTlkuyorR3+5kVBxYb0pHi23XM1uYk+50p2b
	KNkTfhnihrJu/3yNZup8jS8TV43tp3JlXH3+x4KYbAD6AJi8E+jGsCG2tzcWZeeBTagreKgXg12
	8oUUMWFAVRCB1mZU+6otjvuRNiSxw98Nt7xrWquWfwGy5u9xXQVCNxkByrhnotByNCq3vr8B1NH
	51S+SlD+CJWhh2F9HBC9nNbPOhZNhx3tcqEbaGq8mY2mH9iaGvwOrfUmFIbwS+o=
X-Received: by 2002:a05:600c:46d0:b0:493:bc4a:c6b6 with SMTP id
 5b1f17b1804b1-493c2ba1d3emr113298325e9.38.1783037834179; Thu, 02 Jul 2026
 17:17:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com> <20260702165841.GM9392@frogsfrogsfrogs>
In-Reply-To: <20260702165841.GM9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 17:17:02 -0700
X-Gm-Features: AVVi8CcxJan3XgaMiYmE7l9m1K7rjamtB3vH8NBAZsWn7x4K1BrIcNnVAJIzZPo
Message-ID: <CAJnrk1YW0gKRVvHRC+WeKoV2vrquzaC6UkipZkQ34Z0RAQDjtg@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:58=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 3f0932e46fd6..0aa8abc438c1 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -626,7 +626,7 @@ static int iomap_read_folio_iter(struct iomap_iter =
*iter,
> >       return 0;
> >  }
> >
> > -void iomap_read_folio(const struct iomap_ops *ops,
> > +void iomap_read_folio(iomap_next_fn iomap_next,
>
> If you took my earlier suggestion to rename the typedef to
> iomap_iter_fn, then this parameter ought to be named iter_fn.

Hmm... maybe at that point, it's self-explanatory enough that the arg
could just be called "iter" instead of "iter_fn"?

>
> >               struct iomap_read_folio_ctx *ctx, void *private)
> >  {
> >       struct folio *folio =3D ctx->cur_folio;
> > @@ -650,7 +650,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
> >               fsverity_readahead(ctx->vi, folio->index,
> >                                  folio_nr_pages(folio));
> >
> > -     while ((ret =3D iomap_iter(&iter, ops)) > 0) {
> > +     while ((ret =3D iomap_iter(&iter, iomap_next)) > 0) {
> >               iter.status =3D iomap_read_folio_iter(&iter, ctx,
> >                               &bytes_submitted);
> >               iomap_read_submit(&iter, ctx);
> > @@ -688,22 +688,22 @@ static int iomap_readahead_iter(struct iomap_iter=
 *iter,
> >
> >  /**
> >   * iomap_readahead - Attempt to read pages from a file.
> > - * @ops: The operations vector for the filesystem.
> > + * @iomap_next: The iomap_next callback for the filesystem.
>
> "The iomap iteration function for the filesystem" ?
>
> Using the term "iomap_next" in the definition for iomap_next isn't that
> helpful.

Agreed, I'll replace this with your suggestion.

>
> >       return ret;
> > @@ -824,16 +824,16 @@ xfs_file_dio_write_atomic(
> >       unsigned int            iolock =3D XFS_IOLOCK_SHARED;
> >       ssize_t                 ret, ocount =3D iov_iter_count(from);
> >       unsigned int            dio_flags =3D 0;
> > -     const struct iomap_ops  *dops;
> > +     iomap_next_fn           dops;
> >
> >       /*
> >        * HW offload should be faster, so try that first if it is alread=
y
> >        * known that the write length is not too large.
> >        */
> >       if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
> > -             dops =3D &xfs_atomic_write_cow_iomap_ops;
> > +             dops =3D xfs_atomic_write_cow_iomap_next;
> >       else
> > -             dops =3D &xfs_direct_write_iomap_ops;
> > +             dops =3D xfs_direct_write_iomap_next;
>
> Probably ought to be called iter_fn, or at least something that isn't
> "dops".

Nice spotting, I'll rename this in the next version.

Thanks,
Joanne
