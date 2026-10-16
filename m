Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E41F4E3EE6
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166659; cv=pass; b=CH3VzDiPBDS7LL+5DyT1+RBtCWnUiR1Snmxyl1Ep0WKOIBJy0c0KgrzE8/6w1dl8X4WLn3TOksIvpgqErjRMIieYSr0XhYb9XXeLnNcec/AB2Li/QE8GEtgvpWYTZ4/KKVX90mDl0wfJrwVVreg6RVu68+l1/OalPZMhB5QlbZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166659; c=relaxed/simple;
	bh=9lv8y/8boJJYeoN6PZYJjxSqtNYDKsLSBds0Xi+bxrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aMmRRsWdqzOPFM9iyjs8qJWopoDWgqWIQJ6S6H6UUsrh/GkBUX+AQR5nD1N6Fd4O3Nomcqk54y8458yH0mUhFpXyKgq8yCFmhw35ZjHunmwZccHuGsizSaIXcKn9QwT8QlhQlmjbBi0E/Sc9WYoNYvhM1BaFDH2+aH51c4NSL7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pTk0g8EL; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pTk0g8EL"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b21cf1a580so5922a12.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 09:04:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792166652; cv=none;
        d=google.com; s=arc-20260327;
        b=shvH8fd/I88544jmR773m0W0X6qPbFQEOruZZdqshrA/WxHf44lMk/nBKA+QD6/61x
         RSTnLFrCBzglQZAphCmpJrtTfh8ohPnMb0IMPanaJPZ/VYrMPrks1wNL8ot5oylG44CJ
         ZH+z7NS9C28B3KoJ/K/j7gd6tRB5I5iPGCSIA7aY/fHAKPUUPhqbWUGOxn+2/dWy335x
         YrL/g8a4uVqKP4PoxEwuaKQQM8lIkbgwoTkqit465ArjtaeFu3GDuR1YB+l+TQCZ6kZQ
         iGCCbySpF6ZjdsBs2ypK/m7kszqf1zClfGsROWlY0NAK3PFqX686mgMD0xRB99UH81vK
         Jlag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0XT9gf6Lc+1fX8Xrkj2lJ0FO4HQTQ65QLq9M5IgaTRo=;
        fh=0VHaWGxXDbcwx/LfpMlICeMbVnTRfP9l7EMHNIgELQk=;
        b=AHswryohaBwK2zyUWf0Yvb1HRqIM94F7oeiNu0dHbJ0KMnXu29z8cWXw/BYBq7H4mZ
         AvXFfGPkoH7XsHUfxC+qDVuuMqwLj5wj7FHZellu4u7rXF1WIQRSa/sZQyFnmQfMUofO
         mztdgY7cOu7cnlIZGJn2bt/x4OCUQODO49olPSRkWum4J5YuHfCW8KJ1hy7d+j1kpokr
         URkiEW5bHDW8NJAH0bDh3arek0JkatDDPhPKbmF9PB7G/5mDx3cPtL1CJPusuDw7ijAQ
         oytI+AK7emR9Hbw7m5YButn+50Tw9I0Su95hegxPiFx293WIXOYuA2FP1eToUSqCnnjM
         bUlQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792166652; x=1792771452; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0XT9gf6Lc+1fX8Xrkj2lJ0FO4HQTQ65QLq9M5IgaTRo=;
        b=pTk0g8ELftlQCkPZNhI+EIq+kzIHNB8LxG0WUhlatxLimO4E1G9yGAFi6IeC4hAFUV
         Xu5C2JslqKr5900s1SjPrpJxOLRDt1gztPI9Lria8UyIZxiHwb01KjhRuKdaIZPGJscY
         xOhqgL6kCVM54ZNTnByO+dmoK/UJ0S3IaUb65843bOySeodP8B4KODbo+doYplZ9zgpd
         2Oh6xJZ/BcKHylhNTI/qgYBucgMLAjSqZQyaSsHEy10hDJIEG6fpBRJeGr+NZAOU2i2a
         5t9xzz/FGDIysuULJedeN81tg6paZBN+z1SHNQcUTVn9ljhuwA8m1uhkQXOJ45SDKxtg
         nghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792166652; x=1792771452;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0XT9gf6Lc+1fX8Xrkj2lJ0FO4HQTQ65QLq9M5IgaTRo=;
        b=ih5N6fgoyBhXKH4FEv9LsHlOrn1nztDTUf7myICu8GrOFAnLfKiUmzhSU6w88hTTNA
         lwE/ywlkYRMh+rx5F4/+tvDvutPU8cCS23MJIODsq+h4AXUkxwsK6cqH/dH5YJKSP7FI
         qpFLn/bZeMkvqX518yoj0CtyYYj8bgg8q9hoYqy6hHjnhlivNMwFdGIcJgaBtkB+EMML
         ooGLBR98H151sQRN4OpkST38sO6ta0Yg/LJlAxBtOxR7jqZgePp+Qg62Q7PBnCLtUF8/
         26q3zZOJ+HQLQjxUxwkJD+D7jm92K6amaxG8j5IVzyO89xSuQ33hv5kF1IJUow6OOwsJ
         CsOw==
X-Forwarded-Encrypted: i=1; AKwUvBxe2rH05v9ABDD8BWDBK+5MUMBiLLU6g2yihPVy/3ne+joq/WlQpFe8vVZmO1R7GEXN5thOTvU=@lists.linux.dev
X-Gm-Message-State: AFq9FYLTJPHfp9TnQbHXn/+jN0jQpB/won9qU5gjd46A+7UMU7E9Giuf
	45DQ1+1W2KCRvgj9VTRSjkLh6IWjQx8HH1zp29CeBOMTxQvcfZ5BJxK2hVu3CXue65Hd421J0HN
	Ai9ngdbVyJHems8HuV7MPumGN5AzECfc=
X-Gm-Gg: AYBFou3ImZqJzMacnZsdCm+uRbo52nozrjbqKSbvBiRMMOIDg+ug2Wzj0QJKPXK3zBe
	5O4cIxEPJbeVDYsql9Dp0CkIp5EamJSCBpQRPQvTgb/TRv+qRmIPb0VV04YQT33xom6winBNHuY
	P0R+62Fre7ZA6aN2YzsXMy8sCViofnhzbnkkXPbE4jpH9teiJgKvR2i5mI14b11ysSZ2b5wPFRH
	+BFmg7vl4S9OFdIBgVAGyalijP4l8Y0atrB4ERdwC3nF+rYfWy/DkD8SKn7rZICFOueCR0IKhY4
	tBVt9z2weIp4b9ic5zeEfO7mzKVXc5OdUfUYXnXU+EsfTZQ/+JtiJDGq
X-Received: by 2002:a05:6402:4402:b0:6b1:c299:b3f8 with SMTP id
 4fb4d7f45d1cf-6b1c299b53dmr13158335a12.33.1792166651834; Fri, 16 Oct 2026
 09:04:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261008112004.1899560-1-mszeredi@redhat.com> <20261008112004.1899560-9-mszeredi@redhat.com>
 <sashiko-outbox-164097@kernel.org> <CAOssrKeEOMUHz_Esfi6L0tu0rbd+aMbb9+fi9fzFYu5NWczOZA@mail.gmail.com>
In-Reply-To: <CAOssrKeEOMUHz_Esfi6L0tu0rbd+aMbb9+fi9fzFYu5NWczOZA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Oct 2026 18:03:59 +0200
X-Gm-Features: AclHuK-Evug5KGDMq7YW7UlXb9Ln9FrCYT22ooxxec4w9tRZ6QLvbe-ThSbMDYI
Message-ID: <CAOQ4uxhgFM=SN_WKGp8PXGpHJhk=vr9ADS0OU-UeEv8Mrba-XQ@mail.gmail.com>
Subject: Re: [PATCH v4 8/9] fuse: add extent map I/O support
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, John Groves <john@groves.net>, 
	sashiko-reviews@lists.linux.dev, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 11:26=E2=80=AFAM Miklos Szeredi <mszeredi@redhat.co=
m> wrote:
>
> [Restored Cc list]
>
> On Thu, Oct 8, 2026 at 1:36=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> > > diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> > > index e9ab1aea34e27..040817ad76e94 100644
> > > --- a/fs/fuse/passthrough.c
> > > +++ b/fs/fuse/passthrough.c
> > [ ... ]
> > > @@ -74,10 +73,13 @@ ssize_t fuse_passthrough_write_iter(struct kiocb =
*iocb,
> > >       if (!count)
> > >               return 0;
> > >
> > > -     inode_lock(inode);
> > > +     guard(rwsem_write)(&inode->i_rwsem);
> > > +
> > > +     if (!backing_file)
> > > +             return fuse_ext_map_write_iter(iocb, iter);
> >
> > [Severity: High]
> > Does this introduce an ABBA deadlock between pipe_lock and the inode lo=
ck?
> >
> > For normal passthrough, fuse_passthrough_splice_write() acquires the in=
ode
> > lock first, and then calls backing_file_splice_write(), which ultimatel=
y
> > acquires pipe_lock() via the backing file's splice_write callback.
> >
> > However, the EXTMAP DAX path added below for splice_write() directly ca=
lls
> > iter_file_splice_write(), which acquires pipe_lock() first. That functi=
on then
> > invokes fuse_passthrough_write_iter() where the inode lock is acquired =
here
> > via guard(rwsem_write).
>
> Brute force fix would be to prevent mixing plain and ext-map
> passthrough.   Might be a good idea anyway.

You mean not mix on the same fs?
Make sense. So another init flag?

>
> However I'm thinking about why fuse_passthrough_splice_write() needs
> to lock the fuse inode.
>
> Tracing back through git history that inode lock really originates
> from commit 2a92e07edc5e ("ovl: add ovl_write_iter()"), which added
> stacked writes.  That was copied into ovl_splice_write() by commit
> 9b91b6b019fd ("ovl: fix deadlock in splice write").   Which was then
> added to fuse_passthrough_splice_write() by commit 5ca73468612d
> ("fuse: implement splice read/write passthrough").
>
> Even for the original ovl code, I don't see an explanation for the
> inode lock, but I'm probably missing something.
>
> Amir, any thoughts about why that inode_lock() could be necessary?
>

It is my understanding that the inode lock is used to synchronize the
copy of size/mtime from the backing inode to the ovl inode by
ovl_file_end_write().

We don't have this model in fuse passthrough (yet).
I think that fuse_passthrough_end_write() do not need to be synchronized
so could probably lose the inode lock in fuse passthrough.
If we even implement the inode passthrough mode where the
backing inode attributes are the source of truth, it will surely be
a mode that does not mix ext-map.

Thanks,
Amir.
